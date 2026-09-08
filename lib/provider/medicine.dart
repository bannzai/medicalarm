import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/onboarding_medication_plan.dart';
import 'package:medicalarm/utils/analytics/error.dart';
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

  /// 書き込み成功後に同じユーザー・グループの仮設定を削除する。
  /// Firestore の書き込み先を固定したまま端末の状態を更新するため処理を注入する。
  final Future<void> Function() removeOnboardingMedicationPlan;

  MedicineAdd({required this.database, required this.userID, required this.removeOnboardingMedicationPlan});

  Future<Medicine> call({
    required String name,
    required MedicationFrequency frequency,
    required List<MedicationSchedule> schedules,
    required DoseReceiver doseReceiver,
    required String memo,
    required String memoImageURL,
    required int? minimumDoseIntervalHours,
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
      minimumDoseIntervalHours: minimumDoseIntervalHours,
      beganDateTime: beganDateTime,
    );
    await docRef.set(medicine, SetOptions(merge: true));
    try {
      await removeOnboardingMedicationPlan();
    } catch (error, stackTrace) {
      // 薬の保存は成功済み。端末の通知解除失敗を登録失敗とすると再試行で薬が重複する。
      // ホーム画面の薬の存在監視でも仮設定の削除を再試行する。
      errorLogger.recordError(error, stackTrace);
    }
    return medicine;
  }
}

@Riverpod(dependencies: [currentGroupDatabase, appUserID, OnboardingMedicationPlanStore])
MedicineAdd medicineAdd(MedicineAddRef ref) {
  final database = ref.watch(currentGroupDatabaseProvider);
  final userID = ref.watch(appUserIDProvider);
  return MedicineAdd(
    database: database,
    userID: userID,
    removeOnboardingMedicationPlan: () =>
        ref.read(onboardingMedicationPlanStoreProvider(userID: userID, groupID: database.groupID).notifier).remove(),
  );
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
    required int? minimumDoseIntervalHours,
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
      minimumDoseIntervalHours: minimumDoseIntervalHours,
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
