import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/utils/date_time/weekday.dart';
import 'package:uuid/uuid.dart';

part 'grouped.freezed.dart';

@freezed
// 時間&服用者ごとに、服薬予定の薬が1:Nで紐づいている
// [時間&服用者(scheduleTime&doseReceiver): [服薬予定の薬(scheduleRows)]]
// scheduleTime(id無し。値一致)とdoseReceiverごとのscheduleRowsを管理する
// NOTE: scheduleRowsは、もっと`薬`を表す構造体として命名し直しても良いかも
class MedicationGroup with _$MedicationGroup {
  const factory MedicationGroup({
    required String id,
    required MedicationGroupScheduleTime scheduleTime,
    required DoseReceiver doseReceiver,
    required List<MedicationGroupScheduleRow> scheduleRows,
  }) = _MedicationGroup;
}

@freezed
class MedicationGroupScheduleRow with _$MedicationGroupScheduleRow {
  const factory MedicationGroupScheduleRow({
    required String id,
    required MedicationHistory? medicationHistory,
    required Medicine medicine,
    required MedicationSchedule medicationSchedule,
    required String quantityMemo,
    required DateTime date,
  }) = _MedicationGroupScheduleRow;
  const MedicationGroupScheduleRow._();

  bool get isDisabled {
    return date.date().isAfter(today());
  }
}

@freezed
class MedicationGroupScheduleTime with _$MedicationGroupScheduleTime {
  const factory MedicationGroupScheduleTime({
    required int hour,
    required int minute,
  }) = _MedicationGroupScheduleTime;
  const MedicationGroupScheduleTime._();

  String toTimeString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}

// lib/features/medications/page.dart に表示される要素であり、通知に使われる単位
// 取り除かれる要素
// * medicine.beganDateTime.isAfter(date.date())
// * medicine.frequency に該当しない date の場合
List<MedicationGroup> medicationGroups({
  required List<Medicine> medicines,
  required List<MedicationHistory> medicationHistories,
  required DateTime date,
}) {
  final groupedValues = <MedicationGroup>[];
  // scheduleTimeとdoseReceiverごとのtileValuesを構築する
  for (final medicine in medicines) {
    final doseReceiver = medicine.doseReceiver;
    if (medicine.beganDateTime.date().isAfter(date.date())) {
      continue;
    }
    final bool isMatched;
    switch (medicine.frequency) {
      case DailyMedicationFrequency():
        isMatched = true;
      case EveryXDaysMedicationFrequency(interval: final interval):
        isMatched = daysBetween(medicine.beganDateTime, date.date()) % interval == 0;
      case SpecificWeekdaysMedicationFrequency(weekdays: final weekdays):
        isMatched = weekdays.any((weekday) => WeekdayFunctions.weekdayFromDate(date.date()) == weekday);
      case CycleMedicationFrequency(consecutiveDays: final consecutiveDays, restDays: final restDays):
        isMatched = daysBetween(medicine.beganDateTime, date.date()) % (consecutiveDays + restDays) < consecutiveDays;
    }
    if (!isMatched) {
      continue;
    }

    for (final schedule in medicine.schedules) {
      final scheduleTime = MedicationGroupScheduleTime(hour: schedule.hour, minute: schedule.minute);
      final matchedTile = groupedValues.firstWhereOrNull(
        (tile) => tile.scheduleTime == scheduleTime && tile.doseReceiver.id == doseReceiver.id,
      );
      if (matchedTile != null) {
        continue;
      } else {
        groupedValues.add(
          MedicationGroup(
            id: const Uuid().v4(),
            scheduleTime: scheduleTime,
            doseReceiver: doseReceiver,
            scheduleRows: [],
          ),
        );
      }
    }
  }

  // dosingRowsを構築する
  for (final medicine in medicines) {
    final doseReceiver = medicine.doseReceiver;
    if (medicine.beganDateTime.date().isAfter(date.date())) {
      continue;
    }
    final bool isMatched;
    switch (medicine.frequency) {
      case DailyMedicationFrequency():
        isMatched = true;
      case EveryXDaysMedicationFrequency(interval: final interval):
        isMatched = daysBetween(medicine.beganDateTime, date.date()) % interval == 0;
      case SpecificWeekdaysMedicationFrequency(weekdays: final weekdays):
        isMatched = weekdays.any((weekday) => WeekdayFunctions.weekdayFromDate(date.date()) == weekday);
      case CycleMedicationFrequency(consecutiveDays: final consecutiveDays, restDays: final restDays):
        isMatched = daysBetween(medicine.beganDateTime, date.date()) % (consecutiveDays + restDays) < consecutiveDays;
    }
    if (!isMatched) {
      continue;
    }

    for (final schedule in medicine.schedules) {
      final scheduleTime = MedicationGroupScheduleTime(hour: schedule.hour, minute: schedule.minute);

      final tileIndex = groupedValues.indexWhere(
        (tile) => tile.scheduleTime == scheduleTime && tile.doseReceiver.id == doseReceiver.id,
      );
      final tile = groupedValues[tileIndex];

      final scheduleRows = [...tile.scheduleRows];
      final medicationHistory = medicationHistories.firstWhereOrNull(
        (history) =>
            history.medicine.id == medicine.id &&
            history.action.medicationSchedule.id == schedule.id &&
            isSameDay(history.scheduledRecordedDate, date.date()),
      );
      final row = MedicationGroupScheduleRow(
        id: const Uuid().v4(),
        medicationHistory: medicationHistory,
        medicine: medicine,
        medicationSchedule: schedule,
        quantityMemo: schedule.quantityMemo,
        date: date,
      );

      scheduleRows.add(row);
      groupedValues[tileIndex] = tile.copyWith(scheduleRows: [...scheduleRows]);
    }
  }

  final ordered = groupedValues.sortedBy((tile) => tile.scheduleTime.toTimeString());

  return ordered;
}
