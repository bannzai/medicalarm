import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medications/entity/grouped.dart';

Medicine buildMedicine({
  required String id,
  required DateTime beganDateTime,
  DateTime? pausedDateTime,
  // 同名・同時刻スケジュールの複数行を再現するテスト用に差し替え可能にする
  List<MedicationSchedule> schedules = const [
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
}) {
  return Medicine(
    id: id,
    userID: 'user',
    name: 'Medicine $id',
    frequency: const MedicationFrequency.daily(),
    schedules: schedules,
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

  // #253: 毎ビルドのランダム UUID による Widget 状態破棄を防ぐため、id は内容から決まる安定キーであること
  group('medicationGroups の id は内容から決まる安定キー', () {
    final today = DateTime(2026, 4, 22);
    final began = DateTime(2026, 4, 1);

    // 同時刻(9:00)のスケジュールを2つ持つ薬。誤タップ事故 (#253) の再現構成
    Medicine buildMedicineWithTwoSameTimeSchedules({required String id}) {
      return buildMedicine(
        id: id,
        beganDateTime: began,
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
          MedicationSchedule(
            id: 'schedule-2',
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
      );
    }

    test('同じ入力で2回呼んでも group / row の id が一致する', () {
      final medicines = [buildMedicineWithTwoSameTimeSchedules(id: 'medicine-1')];
      final first = medicationGroups(medicines: medicines, medicationHistories: const [], date: today);
      final second = medicationGroups(medicines: medicines, medicationHistories: const [], date: today);

      expect(first.map((group) => group.id).toList(), second.map((group) => group.id).toList());
      expect(
        first.expand((group) => group.scheduleRows).map((row) => row.id).toList(),
        second.expand((group) => group.scheduleRows).map((row) => row.id).toList(),
      );
    });

    test('同名・同時刻のスケジュールが2つあっても row の id は重複しない', () {
      final groups = medicationGroups(
        medicines: [buildMedicineWithTwoSameTimeSchedules(id: 'medicine-1')],
        medicationHistories: const [],
        date: today,
      );

      final rowIDs = groups.expand((group) => group.scheduleRows).map((row) => row.id).toList();
      expect(rowIDs, hasLength(2));
      expect(rowIDs.toSet(), hasLength(2));
    });

    test('日付が変わると group / row の id も変わる(表示日をまたいで Widget 状態を引き継がない)', () {
      final medicines = [buildMedicineWithTwoSameTimeSchedules(id: 'medicine-1')];
      final todayGroups = medicationGroups(medicines: medicines, medicationHistories: const [], date: today);
      final tomorrowGroups = medicationGroups(medicines: medicines, medicationHistories: const [], date: DateTime(2026, 4, 23));

      expect(todayGroups.first.id, isNot(tomorrowGroups.first.id));
      expect(
        todayGroups.first.scheduleRows.map((row) => row.id).toSet().intersection(
              tomorrowGroups.first.scheduleRows.map((row) => row.id).toSet(),
            ),
        isEmpty,
      );
    });
  });
}
