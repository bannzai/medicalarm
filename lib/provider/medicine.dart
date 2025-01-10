import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'medicine.g.dart';

@Riverpod(dependencies: [userDatabase])
Stream<List<Medicine>> medicines(MedicinesRef ref) {
  final database = ref.watch(userDatabaseProvider);
  return database.medicinesReference().snapshots().map((event) => event.docs.map((doc) => doc.data()).toList());
}

class MedicineAdd {
  final UserDatabase database;

  MedicineAdd({required this.database});

  Future<Medicine> call({
    required String name,
    required String memo,
    required String memoImageURL,
    required List<MedicineNotification> notifications,
    required int? stock,
  }) async {
    final collectionRef = database.medicinesReference();
    final docRef = collectionRef.doc();
    final medicine = Medicine(
      id: docRef.id,
      name: name,
      memo: memo,
      memoImageURL: memoImageURL,
      notifications: notifications,
      stock: stock,
    );
    await docRef.set(medicine);
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
    required String memo,
    required String memoImageURL,
    required List<MedicineNotification> notifications,
    required int? stock,
  }) async {
    final docRef = database.medicineReference(medicineID: medicineID);
    final newMedicine = medicine.copyWith(
      name: name,
      memo: memo,
      memoImageURL: memoImageURL,
      notifications: notifications,
      stock: stock,
    );
    await docRef.set(newMedicine);
    return newMedicine;
  }
}

@Riverpod(dependencies: [userDatabase])
MedicineUpdate medicineUpdate(MedicineUpdateRef ref) {
  final database = ref.watch(userDatabaseProvider);
  return MedicineUpdate(database: database);
}
