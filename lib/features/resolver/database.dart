// ignore_for_file: prefer_function_declarations_over_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicalarm/entity/app_user.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/group.dart';
import 'package:medicalarm/entity/group_member_notification_settings.dart';
import 'package:medicalarm/entity/group_user_profile.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/resolver/auth.dart';
import 'package:medicalarm/provider/current_group_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medicalarm/entity/medication_history.dart';

part 'database.g.dart';

abstract class _CollectionPath {
  static const String users = '/users';
  static String userPrivates(String userID) => '$users/$userID/privates';
  static String medicines(String userID) => '/users/$userID/medicines';
  static String doseReceivers(String userID) => '/users/$userID/doseReceivers';
  static String medicationHistories(String userID) => '/users/$userID/medicationHistories';
  static String diaries(String userID) => '/users/$userID/diaries';

  static const String groups = '/groups';
  static String groupMedicines(String groupID) => '/groups/$groupID/medicines';
  static String groupDoseReceivers(String groupID) => '/groups/$groupID/doseReceivers';
  static String groupMedicationHistories(String groupID) => '/groups/$groupID/medicationHistories';
  static String groupDiaries(String groupID) => '/groups/$groupID/diaries';
  static String groupUserProfiles(String groupID) => '/groups/$groupID/userProfiles';
  static String groupMemberNotificationSettings(String groupID) => '/groups/$groupID/memberNotificationSettings';

// [DiarySetting:WIP] 服用者ごとのタグをどういう風に管理するのが良いかわかなかったのでファーストリリースから外す
  // static String diarySettings(String userID) => "/users/$userID/diarySettings";
}

@Riverpod(keepAlive: true, dependencies: [firebaseUserChanges])
UserDatabase userDatabase(UserDatabaseRef ref) {
  final stream = ref.watch(firebaseUserChangesProvider);
  final uid = stream.asData?.value?.uid ?? FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    throw Exception('User ID is not found');
  }
  return UserDatabase(userID: uid);
}

class UserDatabase {
  final String userID;
  UserDatabase({required this.userID});

  final FromFirestore<AppUser> _userFromFirestore = (snapshot, options) => AppUser.fromJson(snapshot.data()!..['id'] = snapshot.id);
  final ToFirestore<AppUser> _userToFirestore = (user, options) => user.toJson();
  DocumentReference<AppUser> userReference() => FirebaseFirestore.instance.collection(_CollectionPath.users).doc(userID).withConverter(
        fromFirestore: _userFromFirestore,
        toFirestore: _userToFirestore,
      );
  DocumentReference userPrivateRawReference() => FirebaseFirestore.instance.collection(_CollectionPath.userPrivates(userID)).doc(userID);

  final FromFirestore<Medicine> _medicineFromFirestore = (snapshot, options) => Medicine.fromJson(snapshot.data()!..['id'] = snapshot.id);
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

  final FromFirestore<DoseReceiver> _doseReceiverFromFirestore = (snapshot, options) => DoseReceiver.fromJson(snapshot.data()!..['id'] = snapshot.id);
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
      (snapshot, options) => MedicationHistory.fromJson(snapshot.data()!..['id'] = snapshot.id);
  final ToFirestore<MedicationHistory> _medicationHistoryToFirestore = (medicationHistory, options) => medicationHistory.toJson();
  CollectionReference<MedicationHistory> medicationHistoriesReference() =>
      FirebaseFirestore.instance.collection(_CollectionPath.medicationHistories(userID)).withConverter(
            fromFirestore: _medicationHistoryFromFirestore,
            toFirestore: _medicationHistoryToFirestore,
          );
  final FromFirestore<Diary> _diaryFromFirestore = (snapshot, options) => Diary.fromJson(snapshot.data()!..['id'] = snapshot.id);
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

// 表示中グループ(currentGroupID)のデータベース。medicine / doseReceiver / medicationHistory / diary の各 provider は
// これを参照することで、呼び出し側(Page)を変更せずにグループスコープでの読み書きへ切り替わる。
@Riverpod(dependencies: [])
GroupDatabase currentGroupDatabase(Ref ref) {
  final groupID = ref.watch(currentGroupIDProvider);
  // CurrentGroupResolver が非 null を保証してから子を描画するため、ここに到達する時点では groupID は非 null。
  if (groupID == null) {
    throw Exception('currentGroupID is null');
  }
  return GroupDatabase(groupID: groupID);
}

// 任意のグループ ID を指定して参照するためのファミリー版。グループ一覧・設定など特定グループを名指しする用途で使う。
@Riverpod(keepAlive: true, dependencies: [])
GroupDatabase groupDatabase(Ref ref, {required String groupID}) {
  return GroupDatabase(groupID: groupID);
}

class GroupDatabase {
  final String groupID;
  GroupDatabase({required this.groupID});

  final FromFirestore<Group> _groupFromFirestore = (snapshot, options) => Group.fromJson(snapshot.data()!..['id'] = snapshot.id);
  final ToFirestore<Group> _groupToFirestore = (group, options) => group.toJson();
  DocumentReference<Group> groupReference() => FirebaseFirestore.instance.collection(_CollectionPath.groups).doc(groupID).withConverter(
        fromFirestore: _groupFromFirestore,
        toFirestore: _groupToFirestore,
      );

  final FromFirestore<Medicine> _medicineFromFirestore = (snapshot, options) => Medicine.fromJson(snapshot.data()!..['id'] = snapshot.id);
  final ToFirestore<Medicine> _medicineToFirestore = (medicine, options) => medicine.toJson();
  CollectionReference<Medicine> medicinesReference() => FirebaseFirestore.instance.collection(_CollectionPath.groupMedicines(groupID)).withConverter(
        fromFirestore: _medicineFromFirestore,
        toFirestore: _medicineToFirestore,
      );
  DocumentReference<Medicine> medicineReference({required String medicineID}) =>
      FirebaseFirestore.instance.collection(_CollectionPath.groupMedicines(groupID)).doc(medicineID).withConverter(
            fromFirestore: _medicineFromFirestore,
            toFirestore: _medicineToFirestore,
          );

  final FromFirestore<DoseReceiver> _doseReceiverFromFirestore = (snapshot, options) => DoseReceiver.fromJson(snapshot.data()!..['id'] = snapshot.id);
  final ToFirestore<DoseReceiver> _doseReceiverToFirestore = (doseReceiver, options) => doseReceiver.toJson();
  CollectionReference<DoseReceiver> doseReceiversReference() =>
      FirebaseFirestore.instance.collection(_CollectionPath.groupDoseReceivers(groupID)).withConverter(
            fromFirestore: _doseReceiverFromFirestore,
            toFirestore: _doseReceiverToFirestore,
          );
  DocumentReference<DoseReceiver> doseReceiverReference({required String doseReceiverID}) =>
      FirebaseFirestore.instance.collection(_CollectionPath.groupDoseReceivers(groupID)).doc(doseReceiverID).withConverter(
            fromFirestore: _doseReceiverFromFirestore,
            toFirestore: _doseReceiverToFirestore,
          );

  final FromFirestore<MedicationHistory> _medicationHistoryFromFirestore =
      (snapshot, options) => MedicationHistory.fromJson(snapshot.data()!..['id'] = snapshot.id);
  final ToFirestore<MedicationHistory> _medicationHistoryToFirestore = (medicationHistory, options) => medicationHistory.toJson();
  CollectionReference<MedicationHistory> medicationHistoriesReference() =>
      FirebaseFirestore.instance.collection(_CollectionPath.groupMedicationHistories(groupID)).withConverter(
            fromFirestore: _medicationHistoryFromFirestore,
            toFirestore: _medicationHistoryToFirestore,
          );

  final FromFirestore<Diary> _diaryFromFirestore = (snapshot, options) => Diary.fromJson(snapshot.data()!..['id'] = snapshot.id);
  final ToFirestore<Diary> _diaryToFirestore = (diary, options) => diary.toJson();
  CollectionReference<Diary> diariesReference() => FirebaseFirestore.instance.collection(_CollectionPath.groupDiaries(groupID)).withConverter(
        fromFirestore: _diaryFromFirestore,
        toFirestore: _diaryToFirestore,
      );
  DocumentReference<Diary> diaryReference({required String? diaryID}) =>
      FirebaseFirestore.instance.collection(_CollectionPath.groupDiaries(groupID)).doc(diaryID).withConverter(
            fromFirestore: _diaryFromFirestore,
            toFirestore: _diaryToFirestore,
          );

  final FromFirestore<GroupUserProfile> _userProfileFromFirestore =
      (snapshot, options) => GroupUserProfile.fromJson(snapshot.data()!..['id'] = snapshot.id);
  final ToFirestore<GroupUserProfile> _userProfileToFirestore = (userProfile, options) => userProfile.toJson();
  CollectionReference<GroupUserProfile> userProfilesReference() =>
      FirebaseFirestore.instance.collection(_CollectionPath.groupUserProfiles(groupID)).withConverter(
            fromFirestore: _userProfileFromFirestore,
            toFirestore: _userProfileToFirestore,
          );
  DocumentReference<GroupUserProfile> userProfileReference({required String userID}) => FirebaseFirestore.instance
      .collection(_CollectionPath.groupUserProfiles(groupID))
      .doc(GroupUserProfile.documentID(groupID: groupID, userID: userID))
      .withConverter(
        fromFirestore: _userProfileFromFirestore,
        toFirestore: _userProfileToFirestore,
      );

  final FromFirestore<GroupMemberNotificationSettings> _memberNotificationSettingsFromFirestore =
      (snapshot, options) => GroupMemberNotificationSettings.fromJson(snapshot.data()!..['id'] = snapshot.id);
  final ToFirestore<GroupMemberNotificationSettings> _memberNotificationSettingsToFirestore = (settings, options) => settings.toJson();
  DocumentReference<GroupMemberNotificationSettings> memberNotificationSettingsReference({required String userID}) =>
      FirebaseFirestore.instance.collection(_CollectionPath.groupMemberNotificationSettings(groupID)).doc(userID).withConverter(
            fromFirestore: _memberNotificationSettingsFromFirestore,
            toFirestore: _memberNotificationSettingsToFirestore,
          );
}

class UserDatabaseResolver extends HookConsumerWidget {
  final User user;
  final Widget Function(BuildContext) builder;

  const UserDatabaseResolver({super.key, required this.user, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [userDatabaseProvider.overrideWith((ref) => UserDatabase(userID: user.uid))],
      child: builder(context),
    );
  }
}
