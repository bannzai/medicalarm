import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medications/entity/grouped.dart';

// #276 の進捗ヒーロー・飲み忘れ警告の判定関数(isMissedDoseSuspected / nextDoseGroup)の検証。
// 予定時刻を可変にするため grouped_test.dart のヘルパーを時刻指定できる形にして持つ
Medicine buildMedicine({
  required String id,
  required DateTime beganDateTime,
  required int hour,
  required int minute,
}) {
  return Medicine(
    id: id,
    userID: 'user',
    name: 'Medicine $id',
    frequency: const MedicationFrequency.daily(),
    schedules: [
      MedicationSchedule(
        id: 'schedule-$id',
        hour: hour,
        minute: minute,
        quantityMemo: '',
        notificationSetting: const MedicineScheduleNotificationSetting(
          isReminderEnabled: true,
          isFollowupEnabled: false,
          useCriticalAlert: false,
        ),
        focusConnectSetting: null,
      ),
    ],
    doseReceiver: const DoseReceiver(id: 'dose-receiver-1', userID: 'user', name: 'me'),
    memo: '',
    memoImageURL: '',
    minimumDoseIntervalHours: null,
    beganDateTime: beganDateTime,
  );
}

// 有効な服用記録(effectiveTakeMedicationHistories が take として拾う形)を作る
MedicationHistory buildTakeHistory({required Medicine medicine, required DateTime date}) {
  return MedicationHistory(
    id: 'take-${medicine.id}',
    userID: 'user',
    recordedByUserID: 'user',
    medicine: medicine,
    actionKind: MedicationHistoryActionKind.take,
    action: MedicationHistoryAction.take(
      medicationSchedule: medicine.schedules.first,
      scheduledRecordedDate: date,
    ),
    memo: '',
    recordedDateTime: date,
    scheduledRecordedDate: date,
    ttlExpiresDateTime: DateTime(date.year + 1, date.month, date.day),
  );
}

void main() {
  final began = DateTime(2026, 4, 1);
  // 表示日 = 2026/4/22。now は同日の 12:00 とし、9:00 は超過済み・18:00 はこれからの予定になる
  final date = DateTime(2026, 4, 22);
  final now = DateTime(2026, 4, 22, 12, 0);

  group('isMissedDoseSuspected', () {
    test('予定時刻を過ぎていて未服用の行が残るグループは飲み忘れの可能性ありと判定する', () {
      final groups = medicationGroups(
        medicines: [buildMedicine(id: 'morning', beganDateTime: began, hour: 9, minute: 0)],
        medicationHistories: const [],
        date: date,
      );

      expect(isMissedDoseSuspected(group: groups.single, now: now), isTrue);
    });

    test('予定時刻を過ぎていても全行が服用済みなら判定しない', () {
      final medicine = buildMedicine(id: 'morning', beganDateTime: began, hour: 9, minute: 0);
      final groups = medicationGroups(
        medicines: [medicine],
        medicationHistories: [buildTakeHistory(medicine: medicine, date: date)],
        date: date,
      );

      expect(groups.single.scheduleRows.single.medicationHistory, isNotNull);
      expect(isMissedDoseSuspected(group: groups.single, now: now), isFalse);
    });

    test('予定時刻がまだ来ていないグループは判定しない', () {
      final groups = medicationGroups(
        medicines: [buildMedicine(id: 'evening', beganDateTime: began, hour: 18, minute: 0)],
        medicationHistories: const [],
        date: date,
      );

      expect(isMissedDoseSuspected(group: groups.single, now: now), isFalse);
    });

    test('表示日が今日以外(過去日)なら未服用でも判定しない', () {
      final groups = medicationGroups(
        medicines: [buildMedicine(id: 'morning', beganDateTime: began, hour: 9, minute: 0)],
        medicationHistories: const [],
        date: DateTime(2026, 4, 21),
      );

      expect(isMissedDoseSuspected(group: groups.single, now: now), isFalse);
    });
  });

  group('nextDoseGroup', () {
    test('現在時刻以降で未服用の最初のグループを返す', () {
      final groups = medicationGroups(
        medicines: [
          buildMedicine(id: 'morning', beganDateTime: began, hour: 9, minute: 0),
          buildMedicine(id: 'evening', beganDateTime: began, hour: 18, minute: 0),
          buildMedicine(id: 'night', beganDateTime: began, hour: 22, minute: 0),
        ],
        medicationHistories: const [],
        date: date,
      );

      expect(nextDoseGroup(groups: groups, now: now)?.scheduleTime.toTimeString(), '18:00');
    });

    test('現在時刻以降のグループが全て服用済みなら null を返す', () {
      final evening = buildMedicine(id: 'evening', beganDateTime: began, hour: 18, minute: 0);
      final groups = medicationGroups(
        medicines: [buildMedicine(id: 'morning', beganDateTime: began, hour: 9, minute: 0), evening],
        medicationHistories: [buildTakeHistory(medicine: evening, date: date)],
        date: date,
      );

      expect(nextDoseGroup(groups: groups, now: now), isNull);
    });

    test('現在時刻を過ぎた予定しか無ければ null を返す', () {
      final groups = medicationGroups(
        medicines: [buildMedicine(id: 'morning', beganDateTime: began, hour: 9, minute: 0)],
        medicationHistories: const [],
        date: date,
      );

      expect(nextDoseGroup(groups: groups, now: now), isNull);
    });

    test('groups が空なら null を返す', () {
      expect(nextDoseGroup(groups: const [], now: now), isNull);
    });
  });
}
