import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';

part 'grouped.freezed.dart';

@freezed
// scheduleTime(id無し。値一致)とdoseReceiverごとのdosingRowsを管理する
class MedicationGroup with _$MedicationGroup {
  const factory MedicationGroup({
    required String id,
    required MedicationGroupScheduleTime scheduleTime,
    required DoseReceiver doseReceiver,
    required List<MedicationGroupScheduleRow> dosingRows,
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

List<MedicationGroup> grouped(List<Medicine> medicines, List<MedicationHistory> medicationHistories, DateTime date) {
  final tileValues = <MedicationGroup>[];
  // scheduleTimeとdoseReceiverごとのtileValuesを構築する
  for (final medicine in medicines) {
    final doseReceiver = medicine.doseReceiver;
    if (medicine.beganDateTime.isAfter(date.value.date())) {
      continue;
    }

    for (final schedule in medicine.schedules) {
      final scheduleTime = MedicationGroupScheduleTime(hour: schedule.hour, minute: schedule.minute);
      final matchedTile = tileValues.firstWhereOrNull(
        (tile) => tile.scheduleTime == scheduleTime && tile.doseReceiver.id == doseReceiver.id,
      );
      if (matchedTile != null) {
        continue;
      } else {
        tileValues.add(
          MedicineTileValue(
            id: const Uuid().v4(),
            scheduleTime: scheduleTime,
            doseReceiver: doseReceiver,
            dosingRows: [],
          ),
        );
      }
    }
  }

  // dosingRowsを構築する
  for (final medicine in medicines) {
    final doseReceiver = medicine.doseReceiver;
    if (medicine.beganDateTime.isAfter(date.value.date())) {
      continue;
    }

    for (final schedule in medicine.schedules) {
      final scheduleTime = MedicationGroupScheduleTime(hour: schedule.hour, minute: schedule.minute);

      final tileIndex = tileValues.indexWhere(
        (tile) => tile.scheduleTime == scheduleTime && tile.doseReceiver.id == doseReceiver.id,
      );
      final tile = tileValues[tileIndex];

      final dosingRows = [...tile.dosingRows];
      final medicationHistory = medicationHistories.firstWhereOrNull(
        (history) =>
            history.medicine.id == medicine.id &&
            history.action.medicationSchedule.id == schedule.id &&
            isSameDay(history.scheduledRecordedDate, date.value.date()),
      );
      final row = MedicationGroupScheduleRow(
        id: const Uuid().v4(),
        medicationHistory: medicationHistory,
        medicine: medicine,
        medicationSchedule: schedule,
        quantityMemo: schedule.quantityMemo,
        date: date.value,
      );

      dosingRows.add(row);
      tileValues[tileIndex] = tile.copyWith(dosingRows: [...dosingRows]);
    }
  }

  final ordered = tileValues.sortedBy((tile) => tile.scheduleTime.toTimeString());

  return ordered;
}
