import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';

part 'grouped.freezed.dart';

@freezed
// 時間&服用者ごとに、服薬予定の薬が1:Nで紐づいている
// [時間&服用者(scheduleTime&doseReceiver): [服薬予定の薬(scheduleRows)]]
// scheduleTime(id無し。値一致)とdoseReceiverごとのscheduleRowsを管理する
// NOTE: scheduleRowsは、もっと`薬`を表す構造体として命名し直しても良いかも
abstract class MedicationGroup with _$MedicationGroup {
  const factory MedicationGroup({
    required String id,
    required MedicationGroupScheduleTime scheduleTime,
    required DoseReceiver doseReceiver,
    required List<MedicationGroupScheduleRow> scheduleRows,
  }) = _MedicationGroup;
}

@freezed
abstract class MedicationGroupScheduleRow with _$MedicationGroupScheduleRow {
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
abstract class MedicationGroupScheduleTime with _$MedicationGroupScheduleTime {
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
    if (medicine.pausedDateTime != null) {
      continue;
    }
    final doseReceiver = medicine.doseReceiver;
    if (medicine.beganDateTime.date().isAfter(date.date())) {
      continue;
    }
    if (!medicine.frequency.isScheduledOnDate(beganDateTime: medicine.beganDateTime, date: date)) {
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
            // snapshot 更新のたびに変わらないよう内容から決定的に生成する安定キー。
            // 毎回ランダムな id だと ValueKey 経由で全行の Widget 状態が破棄・再生成され、誤タップや stale クロージャの温床になる (#253)。
            // 通知登録時の analytics パラメータ(groupID)にも使われる
            id: [date.date().toIso8601String(), doseReceiver.id, scheduleTime.toTimeString()].join('/'),
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
    if (medicine.pausedDateTime != null) {
      continue;
    }
    final doseReceiver = medicine.doseReceiver;
    if (medicine.beganDateTime.date().isAfter(date.date())) {
      continue;
    }
    if (!medicine.frequency.isScheduledOnDate(beganDateTime: medicine.beganDateTime, date: date)) {
      continue;
    }

    for (final schedule in medicine.schedules) {
      final scheduleTime = MedicationGroupScheduleTime(hour: schedule.hour, minute: schedule.minute);

      final tileIndex = groupedValues.indexWhere(
        (tile) => tile.scheduleTime == scheduleTime && tile.doseReceiver.id == doseReceiver.id,
      );
      final tile = groupedValues[tileIndex];

      final scheduleRows = [...tile.scheduleRows];
      // revert アクション追記による論理削除 (#253) を考慮し、「take が存在し、それを打ち消す revert が
      // 存在しない」場合のみチェック済み(medicationHistory 非 null)として扱う
      final medicationHistory = effectiveTakeMedicationHistories(medicationHistories).firstWhereOrNull(
        (history) =>
            history.medicine.id == medicine.id &&
            history.action.medicationSchedule.id == schedule.id &&
            isSameDay(history.scheduledRecordedDate, date.date()),
      );
      final row = MedicationGroupScheduleRow(
        // 行の Widget 状態(チェック表示・遅延削除の猶予)を snapshot 更新をまたいで維持するための安定キー。
        // 表示日付をまたいで状態を引き継がないよう date も含める (#253)
        id: [date.date().toIso8601String(), medicine.id, schedule.id].join('/'),
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
