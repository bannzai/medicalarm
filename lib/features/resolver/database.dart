// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicalarm/entity/app_user.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/resolver/auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medicalarm/entity/medication_history.dart';

part 'database.g.dart';

abstract class _CollectionPath {
  static const String users = "/users";
  static String medicines(String userID) => "/users/$userID/medicines";
  static String doseReceivers(String userID) => "/users/$userID/doseReceivers";
  static String medicationHistories(String userID) => "/users/$userID/medicationHistories";
  static String diaries(String userID) => "/users/$userID/diaries";

// [DiarySetting:WIP] 服用者ごとのタグをどういう風に管理するのが良いかわかなかったのでファーストリリースから外す
  // static String diarySettings(String userID) => "/users/$userID/diarySettings";
}

@Riverpod(keepAlive: true, dependencies: [])
UserDatabase userDatabase(UserDatabaseRef ref) {
  throw UnimplementedError("userDatabase is not implemented");
}

class UserDatabase {
  final String userID;
  UserDatabase({required this.userID});

  final FromFirestore<AppUser> _userFromFirestore = (snapshot, options) => AppUser.fromJson(snapshot.data()!..["id"] = snapshot.id);
  final ToFirestore<AppUser> _userToFirestore = (user, options) => user.toJson();
  DocumentReference<AppUser> userReference() => FirebaseFirestore.instance.collection(_CollectionPath.users).doc(userID).withConverter(
        fromFirestore: _userFromFirestore,
        toFirestore: _userToFirestore,
      );

  final FromFirestore<Medicine> _medicineFromFirestore = (snapshot, options) => Medicine.fromJson(snapshot.data()!..["id"] = snapshot.id);
  final ToFirestore<Medicine> _medicineToFirestore = (medicine, options) => medicine.toJson();
  CollectionReference<Medicine> medicinesReference() => FirebaseFirestore.instance.collection(_CollectionPath.medicines(userID)).withConverter(
        fromFirestore: _medicineFromFirestore,
        toFirestore: _medicineToFirestore,
      );
  DocumentReference<Medicine> medicineReference({required String medicineID}) =>
      FirebaseFirestore.instance.collection(_CollectionPath.medicines(userID)).doc(medicineID).withConverter(
            fromFirestore: _medicineFromFirestore,
            toFirestore: _medicineToFirestore,
          );

  final FromFirestore<DoseReceiver> _doseReceiverFromFirestore = (snapshot, options) => DoseReceiver.fromJson(snapshot.data()!..["id"] = snapshot.id);
  final ToFirestore<DoseReceiver> _doseReceiverToFirestore = (doseReceiver, options) => doseReceiver.toJson();
  CollectionReference<DoseReceiver> doseReceiversReference() =>
      FirebaseFirestore.instance.collection(_CollectionPath.doseReceivers(userID)).withConverter(
            fromFirestore: _doseReceiverFromFirestore,
            toFirestore: _doseReceiverToFirestore,
          );
  DocumentReference<DoseReceiver> doseReceiverReference({required String doseReceiverID}) =>
      FirebaseFirestore.instance.collection(_CollectionPath.doseReceivers(userID)).doc(doseReceiverID).withConverter(
            fromFirestore: _doseReceiverFromFirestore,
            toFirestore: _doseReceiverToFirestore,
          );

  final FromFirestore<MedicationHistory> _medicationHistoryFromFirestore =
      (snapshot, options) => MedicationHistory.fromJson(snapshot.data()!..["id"] = snapshot.id);
  final ToFirestore<MedicationHistory> _medicationHistoryToFirestore = (medicationHistory, options) => medicationHistory.toJson();
  CollectionReference<MedicationHistory> medicationHistoriesReference() =>
      FirebaseFirestore.instance.collection(_CollectionPath.medicationHistories(userID)).withConverter(
            fromFirestore: _medicationHistoryFromFirestore,
            toFirestore: _medicationHistoryToFirestore,
          );
  final FromFirestore<Diary> _diaryFromFirestore = (snapshot, options) => Diary.fromJson(snapshot.data()!..["id"] = snapshot.id);
  final ToFirestore<Diary> _diaryToFirestore = (diary, options) => diary.toJson();
  CollectionReference<Diary> diariesReference() => FirebaseFirestore.instance.collection(_CollectionPath.diaries(userID)).withConverter(
        fromFirestore: _diaryFromFirestore,
        toFirestore: _diaryToFirestore,
      );
  DocumentReference<Diary> diaryReference({required String? diaryID}) =>
      FirebaseFirestore.instance.collection(_CollectionPath.diaries(userID)).doc(diaryID).withConverter(
            fromFirestore: _diaryFromFirestore,
            toFirestore: _diaryToFirestore,
          );

// [DiarySetting:WIP] 服用者ごとのタグをどういう風に管理するのが良いかわかなかったのでファーストリリースから外す
  // final FromFirestore<DiarySetting> _diarySettingFromFirestore = (snapshot, options) => DiarySetting.fromJson(snapshot.data()!..["id"] = snapshot.id);
  // final ToFirestore<DiarySetting> _diarySettingToFirestore = (diarySetting, options) => diarySetting.toJson();
  // DocumentReference<DiarySetting> diarySettingReference() =>
  // FirebaseFirestore.instance.collection(_CollectionPath.diarySettings(userID)).doc('main').withConverter(
  // fromFirestore: _diarySettingFromFirestore,
  // toFirestore: _diarySettingToFirestore,
  // );
}

class UserDatabaseResolver extends HookConsumerWidget {
  final Widget Function(BuildContext) builder;

  const UserDatabaseResolver({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(firebaseUserChangesProvider).asData?.value;

    useEffect(() {
      if (user == null) {
        ref.invalidate(userDatabaseProvider);
      }
      return null;
    }, [user]);

    if (user != null) {
      return ProviderScope(
        overrides: [userDatabaseProvider.overrideWith((ref) => UserDatabase(userID: user.uid))],
        child: Consumer(
          builder: ((context, ref, child) => builder(context)),
        ),
      );
    } else {
      return const IndicatorPage();
    }
  }
}
