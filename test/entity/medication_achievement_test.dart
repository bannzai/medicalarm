import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_achievement.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/utils/date_time/weekday.dart';

/// 服用時刻。1 日の予定回数は薬が持つスケジュールの件数で決まるため、複数回服用の薬は
/// [buildMedicine] に 2 件目([eveningSchedule])を渡して表現する
const morningSchedule = MedicationSchedule(
  id: 'schedule-morning',
  hour: 9,
  minute: 0,
  quantityMemo: '',
  notificationSetting: MedicineScheduleNotificationSetting(
    isReminderEnabled: true,
    isFollowupEnabled: false,
    useCriticalAlert: false,
  ),
  focusConnectSetting: null,
);

const eveningSchedule = MedicationSchedule(
  id: 'schedule-evening',
  hour: 20,
  minute: 0,
  quantityMemo: '',
  notificationSetting: MedicineScheduleNotificationSetting(
    isReminderEnabled: true,
    isFollowupEnabled: false,
    useCriticalAlert: false,
  ),
  focusConnectSetting: null,
);

Medicine buildMedicine({
  String id = 'medicine-1',
  MedicationFrequency frequency = const MedicationFrequency.daily(),
  List<MedicationSchedule> schedules = const [morningSchedule],
  DateTime? beganDateTime,
  DateTime? pausedDateTime,
  DateTime? archivedDateTime,
}) {
  return Medicine(
    id: id,
    userID: 'user-a',
    name: 'Medicine $id',
    frequency: frequency,
    schedules: schedules,
    doseReceiver: const DoseReceiver(id: 'dose-receiver-1', userID: 'user-a', name: 'me'),
    memo: '',
    memoImageURL: '',
    minimumDoseIntervalHours: null,
    pausedDateTime: pausedDateTime,
    archivedDateTime: archivedDateTime,
    beganDateTime: beganDateTime ?? DateTime(2026, 9, 1),
  );
}

MedicationHistory buildTake({
  required String id,
  required DateTime scheduledRecordedDate,
  String medicineID = 'medicine-1',
  MedicationSchedule schedule = morningSchedule,
}) {
  return MedicationHistory(
    id: id,
    userID: 'user-a',
    recordedByUserID: 'user-a',
    medicine: buildMedicine(id: medicineID),
    actionKind: MedicationHistoryActionKind.take,
    action: MedicationHistoryAction.take(medicationSchedule: schedule, scheduledRecordedDate: scheduledRecordedDate),
    memo: '',
    recordedDateTime: scheduledRecordedDate.add(const Duration(hours: 9)),
    scheduledRecordedDate: scheduledRecordedDate,
    ttlExpiresDateTime: scheduledRecordedDate.add(const Duration(days: 365)),
  );
}

MedicationHistory buildRevert({required MedicationHistory takeMedicationHistory}) {
  return MedicationHistory(
    id: '${takeMedicationHistory.id}-revert',
    userID: 'user-a',
    recordedByUserID: 'user-a',
    medicine: takeMedicationHistory.medicine,
    actionKind: MedicationHistoryActionKind.revert,
    action: MedicationHistoryAction.revert(
      takeAction: takeMedicationHistory,
      medicationSchedule: takeMedicationHistory.action.medicationSchedule,
    ),
    memo: '',
    recordedDateTime: takeMedicationHistory.recordedDateTime.add(const Duration(minutes: 5)),
    scheduledRecordedDate: takeMedicationHistory.scheduledRecordedDate,
    ttlExpiresDateTime: takeMedicationHistory.ttlExpiresDateTime,
  );
}

void main() {
  // #278: 達成集計の予定日判定。服薬予定一覧(medicationGroups)と同じ頻度判定に、
  // 開始前・停止・アーカイブの除外を加えたもの
  group('isMedicineScheduledOnDate', () {
    test('毎日の薬は開始日以降のどの日も予定に該当する', () {
      final medicine = buildMedicine(beganDateTime: DateTime(2026, 9, 1));

      expect(isMedicineScheduledOnDate(medicine: medicine, date: DateTime(2026, 9, 1)), isTrue);
      expect(isMedicineScheduledOnDate(medicine: medicine, date: DateTime(2026, 9, 15)), isTrue);
    });

    test('開始日より前の日は予定に該当しない', () {
      expect(
        isMedicineScheduledOnDate(medicine: buildMedicine(beganDateTime: DateTime(2026, 9, 10)), date: DateTime(2026, 9, 9)),
        isFalse,
      );
    });

    test('2日ごとの薬は開始日から偶数日だけ予定に該当する', () {
      final medicine = buildMedicine(
        frequency: const MedicationFrequency.everyXDays(interval: 2),
        beganDateTime: DateTime(2026, 9, 1),
      );

      expect(isMedicineScheduledOnDate(medicine: medicine, date: DateTime(2026, 9, 1)), isTrue);
      expect(isMedicineScheduledOnDate(medicine: medicine, date: DateTime(2026, 9, 2)), isFalse);
      expect(isMedicineScheduledOnDate(medicine: medicine, date: DateTime(2026, 9, 3)), isTrue);
    });

    test('特定の曜日の薬は指定した曜日だけ予定に該当する', () {
      // 2026-09-07 は月曜、2026-09-08 は火曜
      final medicine = buildMedicine(
        frequency: const MedicationFrequency.specificWeekdays(weekdays: [Weekday.Monday]),
        beganDateTime: DateTime(2026, 9, 1),
      );

      expect(isMedicineScheduledOnDate(medicine: medicine, date: DateTime(2026, 9, 7)), isTrue);
      expect(isMedicineScheduledOnDate(medicine: medicine, date: DateTime(2026, 9, 8)), isFalse);
    });

    test('周期(連続3日・休薬2日)の薬は連続服用日だけ予定に該当する', () {
      final medicine = buildMedicine(
        frequency: const MedicationFrequency.cycle(consecutiveDays: 3, restDays: 2),
        beganDateTime: DateTime(2026, 9, 1),
      );

      expect(isMedicineScheduledOnDate(medicine: medicine, date: DateTime(2026, 9, 3)), isTrue);
      // 4日目・5日目は休薬日
      expect(isMedicineScheduledOnDate(medicine: medicine, date: DateTime(2026, 9, 4)), isFalse);
      expect(isMedicineScheduledOnDate(medicine: medicine, date: DateTime(2026, 9, 5)), isFalse);
      // 6日目から次の周期が始まる
      expect(isMedicineScheduledOnDate(medicine: medicine, date: DateTime(2026, 9, 6)), isTrue);
    });

    test('停止した薬は停止当日から予定に該当しない(前日までは該当する)', () {
      final medicine = buildMedicine(pausedDateTime: DateTime(2026, 9, 10, 15, 0));

      expect(isMedicineScheduledOnDate(medicine: medicine, date: DateTime(2026, 9, 9)), isTrue);
      expect(isMedicineScheduledOnDate(medicine: medicine, date: DateTime(2026, 9, 10)), isFalse);
      expect(isMedicineScheduledOnDate(medicine: medicine, date: DateTime(2026, 9, 11)), isFalse);
    });

    test('アーカイブした薬はアーカイブ当日から予定に該当しない(前日までは該当する)', () {
      final medicine = buildMedicine(archivedDateTime: DateTime(2026, 9, 10, 15, 0));

      expect(isMedicineScheduledOnDate(medicine: medicine, date: DateTime(2026, 9, 9)), isTrue);
      expect(isMedicineScheduledOnDate(medicine: medicine, date: DateTime(2026, 9, 10)), isFalse);
    });
  });

  // #278: 日ごとの服用キー索引。revert による論理削除と記録の重複を除いたキーだけを日付ごとに持つ
  group('effectiveTakeDoseKeysByDate', () {
    test('取消(revert)で打ち消された服用はキーに含めない', () {
      final take = buildTake(id: 'take-1', scheduledRecordedDate: DateTime(2026, 9, 10));

      expect(
        effectiveTakeDoseKeysByDate([take, buildRevert(takeMedicationHistory: take)])[DateTime(2026, 9, 10)],
        isNull,
      );
    });

    test('同じ薬・同じスケジュールの記録が重複していても1件のキーになる', () {
      expect(
        effectiveTakeDoseKeysByDate([
          buildTake(id: 'take-1', scheduledRecordedDate: DateTime(2026, 9, 10)),
          buildTake(id: 'take-2', scheduledRecordedDate: DateTime(2026, 9, 10)),
        ])[DateTime(2026, 9, 10)],
        {'medicine-1/schedule-morning'},
      );
    });

    test('スケジュールが違えば別のキーになり、記録は予定日ごとに分かれる', () {
      final doseKeysByDate = effectiveTakeDoseKeysByDate([
        buildTake(id: 'take-1', scheduledRecordedDate: DateTime(2026, 9, 10)),
        buildTake(id: 'take-2', scheduledRecordedDate: DateTime(2026, 9, 10), schedule: eveningSchedule),
        buildTake(id: 'take-3', scheduledRecordedDate: DateTime(2026, 9, 11)),
      ]);

      expect(doseKeysByDate[DateTime(2026, 9, 10)], {'medicine-1/schedule-morning', 'medicine-1/schedule-evening'});
      expect(doseKeysByDate[DateTime(2026, 9, 11)], {'medicine-1/schedule-morning'});
    });
  });

  // #278: カレンダーの達成ドットが表す、その日の達成状態
  group('dayMedicationAchievement', () {
    final medicines = [buildMedicine(schedules: const [morningSchedule, eveningSchedule])];

    test('予定が無い日は null を返す(ドットを表示しない)', () {
      expect(
        dayMedicationAchievement(medicines: medicines, medicationHistories: [], date: DateTime(2026, 8, 31)),
        isNull,
      );
    });

    test('予定をすべて服用した日は allTaken', () {
      expect(
        dayMedicationAchievement(
          medicines: medicines,
          medicationHistories: [
            buildTake(id: 'take-1', scheduledRecordedDate: DateTime(2026, 9, 10)),
            buildTake(id: 'take-2', scheduledRecordedDate: DateTime(2026, 9, 10), schedule: eveningSchedule),
          ],
          date: DateTime(2026, 9, 10),
        ),
        DayMedicationAchievement.allTaken,
      );
    });

    test('予定の一部だけ服用した日は partiallyTaken', () {
      expect(
        dayMedicationAchievement(
          medicines: medicines,
          medicationHistories: [buildTake(id: 'take-1', scheduledRecordedDate: DateTime(2026, 9, 10))],
          date: DateTime(2026, 9, 10),
        ),
        DayMedicationAchievement.partiallyTaken,
      );
    });

    test('予定があるのに1件も服用していない日は noneTaken', () {
      expect(
        dayMedicationAchievement(medicines: medicines, medicationHistories: [], date: DateTime(2026, 9, 10)),
        DayMedicationAchievement.noneTaken,
      );
    });

    test('その日に予定の無い別の薬の記録は、予定されている薬の分子に数えない', () {
      expect(
        dayMedicationAchievement(
          medicines: [buildMedicine(schedules: const [morningSchedule, eveningSchedule])],
          medicationHistories: [
            // 停止・スケジュール削除などで予定から外れた別の薬の記録
            buildTake(id: 'take-1', scheduledRecordedDate: DateTime(2026, 9, 10), medicineID: 'medicine-2'),
            buildTake(id: 'take-2', scheduledRecordedDate: DateTime(2026, 9, 10), medicineID: 'medicine-2', schedule: eveningSchedule),
          ],
          date: DateTime(2026, 9, 10),
        ),
        DayMedicationAchievement.noneTaken,
      );
    });

    test('予定から外れた薬の記録が残っていても allTaken 止まりで、100% を超えない', () {
      expect(
        dayMedicationAchievement(
          medicines: [buildMedicine()],
          medicationHistories: [
            buildTake(id: 'take-1', scheduledRecordedDate: DateTime(2026, 9, 10)),
            // 停止・削除された別の薬の記録
            buildTake(id: 'take-2', scheduledRecordedDate: DateTime(2026, 9, 10), medicineID: 'medicine-2'),
          ],
          date: DateTime(2026, 9, 10),
        ),
        DayMedicationAchievement.allTaken,
      );
    });
  });

  // #278: 「今週の服薬 x/y 回」の集計
  group('weeklyMedicationCounts', () {
    test('週(日曜始まり)の範囲だけを数え、分母は未来の曜日も含めた週全体になる', () {
      // 2026-09-06(日)〜2026-09-12(土) の週。水曜の 2026-09-09 を基準日にする
      final counts = weeklyMedicationCounts(
        medicines: [buildMedicine(beganDateTime: DateTime(2026, 9, 1))],
        medicationHistories: [
          // 前の週(土曜)の記録は数えない
          buildTake(id: 'take-0', scheduledRecordedDate: DateTime(2026, 9, 5)),
          buildTake(id: 'take-1', scheduledRecordedDate: DateTime(2026, 9, 6)),
          buildTake(id: 'take-2', scheduledRecordedDate: DateTime(2026, 9, 7)),
        ],
        date: DateTime(2026, 9, 9),
      );

      expect(counts.takenCount, 2);
      expect(counts.scheduledCount, 7);
    });

    test('1日2回の薬は週の予定回数が14回になる', () {
      expect(
        weeklyMedicationCounts(
          medicines: [buildMedicine(schedules: const [morningSchedule, eveningSchedule], beganDateTime: DateTime(2026, 9, 1))],
          medicationHistories: [],
          date: DateTime(2026, 9, 9),
        ).scheduledCount,
        14,
      );
    });

    test('その日に予定の無い別の薬の記録は週の服薬回数に数えない', () {
      expect(
        weeklyMedicationCounts(
          medicines: [buildMedicine(beganDateTime: DateTime(2026, 9, 1))],
          medicationHistories: [
            buildTake(id: 'take-1', scheduledRecordedDate: DateTime(2026, 9, 6), medicineID: 'medicine-2'),
            buildTake(id: 'take-2', scheduledRecordedDate: DateTime(2026, 9, 7), medicineID: 'medicine-2'),
          ],
          date: DateTime(2026, 9, 9),
        ).takenCount,
        0,
      );
    });
  });

  // #278: 「連続記録 n 日」の集計
  group('consecutiveAchievedDaysCount', () {
    test('今日を含めて連続して達成した日数を数える', () {
      expect(
        consecutiveAchievedDaysCount(
          medicines: [buildMedicine(beganDateTime: DateTime(2026, 9, 1))],
          medicationHistories: [
            buildTake(id: 'take-1', scheduledRecordedDate: DateTime(2026, 9, 8)),
            buildTake(id: 'take-2', scheduledRecordedDate: DateTime(2026, 9, 9)),
            buildTake(id: 'take-3', scheduledRecordedDate: DateTime(2026, 9, 10)),
          ],
          today: DateTime(2026, 9, 10),
        ),
        3,
      );
    });

    test('今日がまだ未服用でも、前日までの連続は途切れない(今日は数えない)', () {
      expect(
        consecutiveAchievedDaysCount(
          medicines: [buildMedicine(beganDateTime: DateTime(2026, 9, 1))],
          medicationHistories: [
            buildTake(id: 'take-1', scheduledRecordedDate: DateTime(2026, 9, 8)),
            buildTake(id: 'take-2', scheduledRecordedDate: DateTime(2026, 9, 9)),
          ],
          today: DateTime(2026, 9, 10),
        ),
        2,
      );
    });

    test('予定が無い日を跨いでも連続は途切れず、その日は日数に数えない', () {
      // 2日ごとの薬。2026-09-06, 08, 10 が予定日で、07・09 は予定が無い
      expect(
        consecutiveAchievedDaysCount(
          medicines: [
            buildMedicine(frequency: const MedicationFrequency.everyXDays(interval: 2), beganDateTime: DateTime(2026, 9, 6)),
          ],
          medicationHistories: [
            buildTake(id: 'take-1', scheduledRecordedDate: DateTime(2026, 9, 6)),
            buildTake(id: 'take-2', scheduledRecordedDate: DateTime(2026, 9, 8)),
            buildTake(id: 'take-3', scheduledRecordedDate: DateTime(2026, 9, 10)),
          ],
          today: DateTime(2026, 9, 10),
        ),
        3,
      );
    });

    test('未達成の日にぶつかった時点で遡るのをやめる', () {
      expect(
        consecutiveAchievedDaysCount(
          medicines: [buildMedicine(beganDateTime: DateTime(2026, 9, 1))],
          medicationHistories: [
            buildTake(id: 'take-1', scheduledRecordedDate: DateTime(2026, 9, 7)),
            // 2026-09-08 は未服用
            buildTake(id: 'take-3', scheduledRecordedDate: DateTime(2026, 9, 9)),
            buildTake(id: 'take-4', scheduledRecordedDate: DateTime(2026, 9, 10)),
          ],
          today: DateTime(2026, 9, 10),
        ),
        2,
      );
    });

    test('薬が1件も無ければ0日', () {
      expect(
        consecutiveAchievedDaysCount(medicines: [], medicationHistories: [], today: DateTime(2026, 9, 10)),
        0,
      );
    });
  });

  // #278: カレンダー画面の月間達成率の集計
  group('monthlyMedicationCounts', () {
    test('今月は今日までを分母にする(まだ来ていない日を含めない)', () {
      final counts = monthlyMedicationCounts(
        medicines: [buildMedicine(beganDateTime: DateTime(2026, 9, 1))],
        medicationHistories: [
          buildTake(id: 'take-1', scheduledRecordedDate: DateTime(2026, 9, 1)),
          buildTake(id: 'take-2', scheduledRecordedDate: DateTime(2026, 9, 2)),
        ],
        month: DateTime(2026, 9, 10),
        today: DateTime(2026, 9, 10),
      );

      expect(counts.takenCount, 2);
      expect(counts.scheduledCount, 10);
    });

    test('過去の月は月末までを分母にする', () {
      expect(
        monthlyMedicationCounts(
          medicines: [buildMedicine(beganDateTime: DateTime(2026, 8, 1))],
          medicationHistories: [buildTake(id: 'take-1', scheduledRecordedDate: DateTime(2026, 8, 5))],
          month: DateTime(2026, 8, 1),
          today: DateTime(2026, 9, 10),
        ).scheduledCount,
        31,
      );
    });

    test('その日に予定の無い別の薬の記録は月の服薬回数に数えない', () {
      expect(
        monthlyMedicationCounts(
          medicines: [buildMedicine(beganDateTime: DateTime(2026, 9, 1))],
          medicationHistories: [
            buildTake(id: 'take-1', scheduledRecordedDate: DateTime(2026, 9, 1), medicineID: 'medicine-2'),
            buildTake(id: 'take-2', scheduledRecordedDate: DateTime(2026, 9, 2), medicineID: 'medicine-2'),
          ],
          month: DateTime(2026, 9, 10),
          today: DateTime(2026, 9, 10),
        ).takenCount,
        0,
      );
    });

    test('未来の月は集計対象が無いため(0, 0)を返す', () {
      final counts = monthlyMedicationCounts(
        medicines: [buildMedicine(beganDateTime: DateTime(2026, 9, 1))],
        medicationHistories: [],
        month: DateTime(2026, 10, 1),
        today: DateTime(2026, 9, 10),
      );

      expect(counts.takenCount, 0);
      expect(counts.scheduledCount, 0);
    });
  });
}
