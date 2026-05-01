import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medications/entity/grouped.dart';

Medicine buildMedicine({
  required String id,
  required DateTime beganDateTime,
  DateTime? pausedDateTime,
}) {
  return Medicine(
    id: id,
    userID: 'user',
    name: 'Medicine $id',
    frequency: const MedicationFrequency.daily(),
    schedules: const [
      MedicationSchedule(
        id: 'schedule-1',
        hour: 9,
        minute: 0,
        quantityMemo: '',
        notificationSetting: MedicineScheduleNotificationSetting(
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
    beganDateTime: beganDateTime,
    pausedDateTime: pausedDateTime,
  );
}

void main() {
  // Medicine.pausedDateTime のフィルタ確認
  group('medicationGroups は pausedDateTime でフィルタする', () {
    final today = DateTime(2026, 4, 22);
    final began = DateTime(2026, 4, 1);

    test('pausedDateTime が null の薬は結果に含まれる', () {
      final groups = medicationGroups(
        medicines: [buildMedicine(id: 'active', beganDateTime: began)],
        medicationHistories: const [],
        date: today,
      );

      expect(groups, hasLength(1));
      expect(groups.first.scheduleRows, hasLength(1));
      expect(groups.first.scheduleRows.first.medicine.id, 'active');
    });

    test('pausedDateTime がセットされた薬は結果に含まれない', () {
      final groups = medicationGroups(
        medicines: [buildMedicine(id: 'paused', beganDateTime: began, pausedDateTime: DateTime(2026, 4, 10))],
        medicationHistories: const [],
        date: today,
      );

      expect(groups, isEmpty);
    });

    test('一時停止中の薬は除外され、稼働中の薬だけが残る', () {
      final groups = medicationGroups(
        medicines: [
          buildMedicine(id: 'active', beganDateTime: began),
          buildMedicine(id: 'paused', beganDateTime: began, pausedDateTime: DateTime(2026, 4, 10)),
        ],
        medicationHistories: const [],
        date: today,
      );

      expect(groups, hasLength(1));
      final scheduleRows = groups.first.scheduleRows;
      expect(scheduleRows.map((row) => row.medicine.id).toList(), ['active']);
    });
  });
}
