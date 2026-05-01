import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'medicine.g.dart';

@Riverpod(dependencies: [userDatabase])
Stream<List<Medicine>> activeMedicines(ActiveMedicinesRef ref) {
  final database = ref.watch(userDatabaseProvider);
  return database
      .medicinesReference()
      .snapshots()
      .map((event) => event.docs.map((doc) => doc.data()).where((medicine) => medicine.archivedDateTime == null).toList());
}

class MedicineAdd {
  final UserDatabase database;

  MedicineAdd({required this.database});

  Future<Medicine> call({
    required String name,
    required MedicationFrequency frequency,
    required List<MedicationSchedule> schedules,
    required DoseReceiver doseReceiver,
    required String memo,
    required String memoImageURL,
    required DateTime beganDateTime,
  }) async {
    final collectionRef = database.medicinesReference();
    final docRef = collectionRef.doc();
    final medicine = Medicine(
      userID: database.userID,
      id: docRef.id,
      name: name.trim(),
      frequency: frequency,
      schedules: schedules,
      doseReceiver: doseReceiver,
      memo: memo,
      memoImageURL: memoImageURL,
      beganDateTime: beganDateTime,
    );
    await docRef.set(medicine, SetOptions(merge: true));
    return medicine;
  }
}

@Riverpod(dependencies: [userDatabase])
MedicineAdd medicineAdd(MedicineAddRef ref) {
  final database = ref.watch(userDatabaseProvider);
  return MedicineAdd(database: database);
}

class MedicineUpdate {
  final UserDatabase database;

  MedicineUpdate({required this.database});

  Future<Medicine> call({
    required String medicineID,
    required Medicine medicine,
    required String name,
    required MedicationFrequency frequency,
    required List<MedicationSchedule> schedules,
    required DoseReceiver doseReceiver,
    required String memo,
    required String memoImageURL,
    required DateTime beganDateTime,
  }) async {
    final docRef = database.medicineReference(medicineID: medicineID);
    final newMedicine = medicine.copyWith(
      name: name.trim(),
      frequency: frequency,
      schedules: schedules,
      doseReceiver: doseReceiver,
      memo: memo,
      memoImageURL: memoImageURL,
      beganDateTime: beganDateTime,
    );
    await docRef.set(newMedicine, SetOptions(merge: true));
    return newMedicine;
  }
}

@Riverpod(dependencies: [userDatabase])
MedicineUpdate medicineUpdate(Ref ref) {
  final database = ref.watch(userDatabaseProvider);
  return MedicineUpdate(database: database);
}

class MedicineDelete {
  final UserDatabase database;

  MedicineDelete({required this.database});

  Future<void> call({required String medicineID}) async {
    final docRef = database.medicineReference(medicineID: medicineID);
    await docRef.delete();
  }
}

@Riverpod(dependencies: [userDatabase])
MedicineDelete medicineDelete(Ref ref) {
  final database = ref.watch(userDatabaseProvider);
  return MedicineDelete(database: database);
}

// 指定した薬の pausedDateTime のみを更新する。停止時は DateTime.now()、再開時は null を渡す
class MedicineSetPaused {
  final UserDatabase database;

  MedicineSetPaused({required this.database});

  Future<Medicine> call({
    required String medicineID,
    required Medicine medicine,
    required DateTime? pausedDateTime,
  }) async {
    final docRef = database.medicineReference(medicineID: medicineID);
    final newMedicine = medicine.copyWith(pausedDateTime: pausedDateTime);
    await docRef.set(newMedicine, SetOptions(merge: true));
    return newMedicine;
  }
}

@Riverpod(dependencies: [userDatabase])
MedicineSetPaused medicineSetPaused(Ref ref) {
  final database = ref.watch(userDatabaseProvider);
  return MedicineSetPaused(database: database);
}
