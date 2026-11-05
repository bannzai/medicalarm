import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'default_group_update.g.dart';

/// AppUser.defaultGroupID を更新する。グループ切替時に既定グループを付け替える。
class DefaultGroupUpdate {
  final UserDatabase userDatabase;
  DefaultGroupUpdate({required this.userDatabase});

  Future<void> call({required String groupID}) async {
    await userDatabase.userReference().update({'defaultGroupID': groupID});
  }
}

@Riverpod(dependencies: [userDatabase])
DefaultGroupUpdate defaultGroupUpdate(Ref ref) {
  return DefaultGroupUpdate(userDatabase: ref.watch(userDatabaseProvider));
}

/// DEBUG ビルドの動作確認用に、user ドキュメントの defaultGroupID と groupMigratedDateTime を消す。
///
/// グループを持ったまま既定グループを失った利用者 (#514 の起動できなくなった状態) は UI の操作では作れないため、開発者メニューから作る。
class DebugDefaultGroupClear {
  /// 消す対象の user のデータベース。
  final UserDatabase userDatabase;

  DebugDefaultGroupClear({required this.userDatabase});

  /// 2 つのフィールドを user ドキュメントから消す。既に無くても成功する。
  Future<void> call() async {
    await userDatabase.userReference().update({'defaultGroupID': FieldValue.delete(), 'groupMigratedDateTime': FieldValue.delete()});
  }
}

/// 現在のユーザーの [DebugDefaultGroupClear] を返す。
@Riverpod(dependencies: [userDatabase])
DebugDefaultGroupClear debugDefaultGroupClear(Ref ref) {
  return DebugDefaultGroupClear(userDatabase: ref.watch(userDatabaseProvider));
}
