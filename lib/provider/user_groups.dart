import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicalarm/entity/group.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_groups.g.dart';

/// 自分が所属する全グループ。memberUserIDs に自分の uid を含むグループを購読する。
@Riverpod(dependencies: [userDatabase])
Stream<List<Group>> userGroups(Ref ref) {
  final database = ref.watch(userDatabaseProvider);
  return FirebaseFirestore.instance
      .collection('/groups')
      .where('memberUserIDs', arrayContains: database.userID)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Group.fromJson(doc.data()..['id'] = doc.id)).toList());
}

/// 自分が所属する全グループをサーバーから取得する。
///
/// ソログループを作る直前の判定に使うため、端末のキャッシュを使わない。サーバーに届かない時 (オフライン等) は例外を投げる。
/// Firestore の操作は `call` を持つ class を Provider から返す、というこのリポジトリの規約 (CLAUDE.md) に合わせて class にしている。
class ServerUserGroupsFetch {
  /// 取得するグループのメンバーである user のデータベース。
  final UserDatabase database;

  ServerUserGroupsFetch({required this.database});

  /// 自分が所属する全グループを返す。
  Future<List<Group>> call() async {
    return (await FirebaseFirestore.instance
            .collection('/groups')
            .where('memberUserIDs', arrayContains: database.userID)
            .get(const GetOptions(source: Source.server)))
        .docs
        .map((doc) => Group.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }
}

/// 現在のユーザーの所属グループをサーバーから取得する [ServerUserGroupsFetch] を返す。
@Riverpod(dependencies: [userDatabase])
ServerUserGroupsFetch serverUserGroupsFetch(Ref ref) {
  return ServerUserGroupsFetch(database: ref.watch(userDatabaseProvider));
}
