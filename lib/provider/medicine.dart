import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'medicine.g.dart';

@Riverpod(dependencies: [currentGroupDatabase])
Stream<List<Medicine>> activeMedicines(ActiveMedicinesRef ref) {
  final database = ref.watch(currentGroupDatabaseProvider);
  return database
      .medicinesReference()
      .snapshots()
      .map((event) => event.docs.map((doc) => doc.data()).where((medicine) => medicine.archivedDateTime == null).toList());
}

class MedicineAdd {
  final GroupDatabase database;
  // 作成者(creator)の uid。Medicine.userID に設定する。
  final String userID;

  MedicineAdd({required this.database, required this.userID});

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
      userID: userID,
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

  // 画像からの一括登録など、複数の薬を 1 回で登録する。call を 1 件ずつ await すると途中失敗で
  // 一部だけ保存され、再実行時に重複登録になるため、WriteBatch で原子的に書き込む。
  Future<List<Medicine>> callAll({
    required List<
            ({
              String name,
              MedicationFrequency frequency,
              List<MedicationSchedule> schedules,
              DoseReceiver doseReceiver,
              String memo,
              String memoImageURL,
              DateTime beganDateTime
            })>
        medicineInputs,
  }) async {
    final collectionRef = database.medicinesReference();
    final batch = collectionRef.firestore.batch();
    final medicines = <Medicine>[];
    for (final medicineInput in medicineInputs) {
      final docRef = collectionRef.doc();
      final medicine = Medicine(
        userID: userID,
        id: docRef.id,
        name: medicineInput.name.trim(),
        frequency: medicineInput.frequency,
        schedules: medicineInput.schedules,
        doseReceiver: medicineInput.doseReceiver,
        memo: medicineInput.memo,
        memoImageURL: medicineInput.memoImageURL,
        beganDateTime: medicineInput.beganDateTime,
      );
      batch.set(docRef, medicine, SetOptions(merge: true));
      medicines.add(medicine);
    }
    await batch.commit();
    return medicines;
  }
}

@Riverpod(dependencies: [currentGroupDatabase, appUserID])
MedicineAdd medicineAdd(MedicineAddRef ref) {
  return MedicineAdd(database: ref.watch(currentGroupDatabaseProvider), userID: ref.watch(appUserIDProvider));
}

class MedicineUpdate {
  final GroupDatabase database;

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

@Riverpod(dependencies: [currentGroupDatabase])
MedicineUpdate medicineUpdate(Ref ref) {
  final database = ref.watch(currentGroupDatabaseProvider);
  return MedicineUpdate(database: database);
}

class MedicineDelete {
  final GroupDatabase database;

  MedicineDelete({required this.database});

  Future<void> call({required String medicineID}) async {
    final docRef = database.medicineReference(medicineID: medicineID);
    await docRef.delete();
  }
}

@Riverpod(dependencies: [currentGroupDatabase])
MedicineDelete medicineDelete(Ref ref) {
  final database = ref.watch(currentGroupDatabaseProvider);
  return MedicineDelete(database: database);
}

// 指定した薬の pausedDateTime のみを更新する。停止時は DateTime.now()、再開時は null を渡す
class MedicineSetPaused {
  final GroupDatabase database;

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

@Riverpod(dependencies: [currentGroupDatabase])
MedicineSetPaused medicineSetPaused(Ref ref) {
  final database = ref.watch(currentGroupDatabaseProvider);
  return MedicineSetPaused(database: database);
}
