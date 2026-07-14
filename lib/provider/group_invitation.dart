import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/utils/functions/firebase_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_invitation.g.dart';

/// 招待コードを発行する。オーナー/メンバーがグループ設定画面から呼び出す。
class CreateGroupInvitation {
  Future<({String invitationCode, DateTime expiresDateTime})> call({required String groupID}) {
    return functions.createGroupInvitation(groupID: groupID);
  }
}

@riverpod
CreateGroupInvitation createGroupInvitation(Ref ref) {
  return CreateGroupInvitation();
}

/// 招待コードを使ってグループに参加し、参加先を既定グループに切り替える。
class AcceptGroupInvitation {
  final UserDatabase userDatabase;

  AcceptGroupInvitation({required this.userDatabase});

  Future<String> call({required String invitationCode}) async {
    final groupID = await functions.acceptGroupInvitation(invitationCode: invitationCode);
    await userDatabase.userReference().update({
      'defaultGroupID': groupID,
      'updatedDateTime': FieldValue.serverTimestamp(),
    });
    return groupID;
  }
}

@Riverpod(dependencies: [userDatabase])
AcceptGroupInvitation acceptGroupInvitation(Ref ref) {
  return AcceptGroupInvitation(userDatabase: ref.watch(userDatabaseProvider));
}
