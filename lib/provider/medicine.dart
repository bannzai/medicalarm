import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'medicine.g.dart';

@Riverpod(dependencies: [userDatabase])
Stream<Medicine> medicines(MedicinesRef ref) {
  final database = ref.watch(userDatabaseProvider);
  return database.userReference().snapshots().map((event) => event.data()!);
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
