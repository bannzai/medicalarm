import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
        isLessThanOrEqualTo: date.date().add(const Duration(days: 1)),
      )
      .snapshots()
      .map((event) => event.docs.map((doc) => doc.data()).toList());
}

@Riverpod(dependencies: [userDatabase])
Stream<List<MedicationHistory>> medicationHistoriesByDateRange(MedicationHistoriesRef ref, DateTimeRange dateRange) {
  final database = ref.watch(userDatabaseProvider);
  return database
      .medicationHistoriesReference()
      .where(
        'scheduledRecordedDate',
        isGreaterThanOrEqualTo: dateRange.start,
        isLessThanOrEqualTo: dateRange.end,
      )
      .snapshots()
      .map((event) => event.docs.map((doc) => doc.data()).toList());
}

class MedicationHistoryTake {
  final UserDatabase database;

  MedicationHistoryTake(this.database);

  Future<MedicationHistory> call({
    required MedicationHistory? medicationHistory,
    required String memo,
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
          memo: memo,
          recordedDateTime: recordedDateTime,
          scheduledRecordedDate: scheduledRecordedDate,
        );

    await docRef.set(newMedicationHistory, SetOptions(merge: true));
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
