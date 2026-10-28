import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/group_user_profile.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_user_profile.g.dart';

/// 指定グループの全メンバーの表示名プロファイルを購読する。記録者表示・メンバー一覧で使う。
@Riverpod(dependencies: [groupDatabase])
Stream<List<GroupUserProfile>> groupUserProfiles(Ref ref, {required String groupID}) {
  final database = ref.watch(groupDatabaseProvider(groupID: groupID));
  return database.userProfilesReference().snapshots().map((event) => event.docs.map((doc) => doc.data()).toList());
}

/// グループ内での自分の表示名を更新する。存在しなければ作成する。
class GroupUserProfileUpdate {
  final GroupDatabase database;

  GroupUserProfileUpdate({required this.database});

  Future<void> call({
    required String userID,
    required String? displayName,
  }) async {
    final docRef = database.userProfileReference(userID: userID);
    if ((await docRef.get()).exists) {
      await docRef.update({
        'displayName': displayName,
        'updatedDateTime': FieldValue.serverTimestamp(),
        'serverUpdatedDateTime': FieldValue.serverTimestamp(),
      });
    } else {
      await docRef.set(
        GroupUserProfile(
          id: GroupUserProfile.documentID(groupID: database.groupID, userID: userID),
          groupID: database.groupID,
          userID: userID,
          displayName: displayName,
        ),
        SetOptions(merge: true),
      );
    }
  }
}

@Riverpod(dependencies: [groupDatabase])
GroupUserProfileUpdate groupUserProfileUpdate(Ref ref, {required String groupID}) {
  return GroupUserProfileUpdate(database: ref.watch(groupDatabaseProvider(groupID: groupID)));
}
