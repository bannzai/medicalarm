import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/utils/alarm_kit_service.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/analytics/error.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'medication_history.g.dart';

@Riverpod(dependencies: [currentGroupDatabase])
Stream<List<MedicationHistory>> medicationHistories(MedicationHistoriesRef ref) {
  final database = ref.watch(currentGroupDatabaseProvider);
  return database.medicationHistoriesReference().snapshots().map((event) => event.docs.map((doc) => doc.data()).toList());
}

@Riverpod(dependencies: [currentGroupDatabase])
Stream<List<MedicationHistory>> medicationHistoriesByDate(MedicationHistoriesRef ref, DateTime date) {
  final database = ref.watch(currentGroupDatabaseProvider);
  return database
      .medicationHistoriesReference()
      .where(
        'scheduledRecordedDate',
        isGreaterThanOrEqualTo: date.date(),
        isLessThanOrEqualTo: date.date().add(const Duration(days: 1)).subtract(const Duration(seconds: 1)),
      )
      .snapshots()
      .map((event) => event.docs.map((doc) => doc.data()).toList());
}

class MedicationHistoryTake {
  final GroupDatabase database;
  // 記録者(自分)の uid。userID(作成者) と recordedByUserID(記録者) の両方に設定する。
  final String userID;

  MedicationHistoryTake({required this.database, required this.userID});

  Future<MedicationHistory> call({
    required MedicationHistory? medicationHistory,
    required DateTime recordedDateTime,
    required DateTime scheduledRecordedDate,
    required Medicine medicine,
    required MedicationSchedule medicationSchedule,
  }) async {
    final docRef = database.medicationHistoriesReference().doc();

    final newMedicationHistory = medicationHistory ??
        MedicationHistory(
          id: docRef.id,
          userID: userID,
          recordedByUserID: userID,
          medicine: medicine,
          actionKind: MedicationHistoryActionKind.take,
          action: MedicationHistoryAction.take(
            medicationSchedule: medicationSchedule,
            scheduledRecordedDate: scheduledRecordedDate,
          ),
          memo: '',
          recordedDateTime: recordedDateTime,
          scheduledRecordedDate: scheduledRecordedDate,
          ttlExpiresDateTime: DateTime.now().addDays(365),
        );

    // 服用記録を保存
    await docRef.set(newMedicationHistory, SetOptions(merge: true));

    if (medicationSchedule.notificationSetting.useAlarmKit) {
      try {
        await AlarmKitService.stopAllAlarms();
        analytics.debug(name: 'medication_history_take_alarm_kit_stopped');
      } catch (e, st) {
        // AlarmKit停止に失敗しても服用記録は成功しているので継続
        errorLogger.recordError(e, st);
        analytics.debug(name: 'medication_history_take_alarm_kit_stop_failed', parameters: {
          'error': e.toString(),
        });
      }
    }

    return newMedicationHistory;
  }
}

@Riverpod(dependencies: [currentGroupDatabase, appUserID])
MedicationHistoryTake medicationHistoryTake(MedicationHistoryTakeRef ref) {
  return MedicationHistoryTake(database: ref.watch(currentGroupDatabaseProvider), userID: ref.watch(appUserIDProvider));
}

class MedicationHistoryDelete {
  final GroupDatabase database;

  MedicationHistoryDelete(this.database);

  Future<void> call(MedicationHistory medicationHistory) async {
    await database.medicationHistoriesReference().doc(medicationHistory.id).delete();
  }
}

@Riverpod(dependencies: [currentGroupDatabase])
MedicationHistoryDelete medicationHistoryDelete(MedicationHistoryDeleteRef ref) {
  return MedicationHistoryDelete(ref.watch(currentGroupDatabaseProvider));
}

class MedicationHistoryMemoUpdate {
  final GroupDatabase database;

  MedicationHistoryMemoUpdate(this.database);

  Future<void> call({required MedicationHistory medicationHistory, required String memo}) async {
    await database.medicationHistoriesReference().doc(medicationHistory.id).set(
          medicationHistory.copyWith(memo: memo),
          SetOptions(merge: true),
        );
  }
}

@Riverpod(dependencies: [currentGroupDatabase])
MedicationHistoryMemoUpdate medicationHistoryMemoUpdate(MedicationHistoryMemoUpdateRef ref) {
  return MedicationHistoryMemoUpdate(ref.watch(currentGroupDatabaseProvider));
}
