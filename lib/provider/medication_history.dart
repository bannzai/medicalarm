import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/utils/alarm_kit_service.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/analytics/error.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/utils/shared_preferences/keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'medication_history.g.dart';

@Riverpod(dependencies: [userDatabase])
Stream<List<MedicationHistory>> medicationHistories(MedicationHistoriesRef ref) {
  final database = ref.watch(userDatabaseProvider);
  return database.medicationHistoriesReference().snapshots().map((event) => event.docs.map((doc) => doc.data()).toList());
}

@Riverpod(dependencies: [userDatabase])
Stream<List<MedicationHistory>> medicationHistoriesByDate(MedicationHistoriesRef ref, DateTime date) {
  final database = ref.watch(userDatabaseProvider);
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
  final UserDatabase database;

  MedicationHistoryTake(this.database);

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
          userID: database.userID,
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

    // AlarmKitが有効な場合はアラームを停止
    final sharedPreferences = await SharedPreferences.getInstance();
    final useAlarmKit = sharedPreferences.getBool(BoolKey.useAlarmKit) ?? false;

    if (useAlarmKit) {
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

@Riverpod(dependencies: [userDatabase])
MedicationHistoryTake medicationHistoryTake(MedicationHistoryTakeRef ref) {
  return MedicationHistoryTake(ref.watch(userDatabaseProvider));
}

class MedicationHistoryDelete {
  final UserDatabase database;

  MedicationHistoryDelete(this.database);

  Future<void> call(MedicationHistory medicationHistory) async {
    await database.medicationHistoriesReference().doc(medicationHistory.id).delete();
  }
}

@Riverpod(dependencies: [userDatabase])
MedicationHistoryDelete medicationHistoryDelete(MedicationHistoryDeleteRef ref) {
  return MedicationHistoryDelete(ref.watch(userDatabaseProvider));
}

class MedicationHistoryMemoUpdate {
  final UserDatabase database;

  MedicationHistoryMemoUpdate(this.database);

  Future<void> call({required MedicationHistory medicationHistory, required String memo}) async {
    await database.medicationHistoriesReference().doc(medicationHistory.id).set(
          medicationHistory.copyWith(memo: memo),
          SetOptions(merge: true),
        );
  }
}

@Riverpod(dependencies: [userDatabase])
MedicationHistoryMemoUpdate medicationHistoryMemoUpdate(MedicationHistoryMemoUpdateRef ref) {
  return MedicationHistoryMemoUpdate(ref.watch(userDatabaseProvider));
}
