import 'package:medicalarm/entity/group.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/default_group_update.dart';
import 'package:medicalarm/provider/user_groups.dart';
import 'package:medicalarm/utils/functions/firebase_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_create.g.dart';

/// サーバー側で作成数上限チェックを行った上でグループを作成する。
class CreateGroup {
  /// [iconName] は home / family / hospital / medication / elderly / favorite のいずれか。
  /// 戻り値は作成されたグループの ID。
  Future<String> call({
    required String? name,
    required bool setAsDefault,
    required String iconName,
  }) {
    return functions.createGroup(name: name, setAsDefault: setAsDefault, iconName: iconName);
  }
}

@riverpod
CreateGroup createGroup(Ref ref) {
  return CreateGroup();
}

/// [groups] のうち [ownerUserID] がオーナーで最も古いグループの ID を返す。無ければ null。
///
/// 最も古いものを選ぶのは、自動で作られたソログループを指し、removeGroupMember の付け替え先の決め方とも揃うため。
/// createdDateTime が無い既存のドキュメントは、作成順を判定できないため後ろに回す。
String? oldestOwnedGroupID({required List<Group> groups, required String ownerUserID}) {
  final ownedGroups = groups.where((group) => group.ownerUserID == ownerUserID).toList();
  ownedGroups.sort((a, b) {
    final aCreatedDateTime = a.createdDateTime;
    final bCreatedDateTime = b.createdDateTime;
    if (aCreatedDateTime == null) return bCreatedDateTime == null ? 0 : 1;
    if (bCreatedDateTime == null) return -1;
    return aCreatedDateTime.compareTo(bCreatedDateTime);
  });
  return ownedGroups.isEmpty ? null : ownedGroups.first.id;
}

/// defaultGroupID を持たないユーザーの既定グループを用意する。
///
/// createGroup は呼び出しごとに新しいグループを作り、無料プランでは 2 件で上限の例外を返すため、
/// 自分がオーナーのグループが既にあれば作らず、それを既定にする (#514)。
class SoloGroupPrepare {
  /// 既定グループを用意するユーザーの uid。
  final String userID;

  /// 所属グループをサーバーから取得する。
  final ServerUserGroupsFetch serverUserGroupsFetch;

  /// 既存のグループを既定にする。
  final DefaultGroupUpdate defaultGroupUpdate;

  /// 自分がオーナーのグループが無い時にソログループを作る。
  final CreateGroup createGroup;

  SoloGroupPrepare({required this.userID, required this.serverUserGroupsFetch, required this.defaultGroupUpdate, required this.createGroup});

  /// 既定になったグループの ID を返す。サーバーに届かない時は、重複を避けるため何も作らず例外を投げる。
  Future<String> call() async {
    final ownedGroupID = oldestOwnedGroupID(groups: await serverUserGroupsFetch(), ownerUserID: userID);
    if (ownedGroupID == null) {
      return createGroup.call(name: null, setAsDefault: true, iconName: 'home');
    }
    await defaultGroupUpdate(groupID: ownedGroupID);
    return ownedGroupID;
  }
}

/// 現在のユーザーの [SoloGroupPrepare] を返す。
@Riverpod(dependencies: [userDatabase, serverUserGroupsFetch, defaultGroupUpdate])
SoloGroupPrepare soloGroupPrepare(Ref ref) {
  return SoloGroupPrepare(
    userID: ref.watch(userDatabaseProvider).userID,
    serverUserGroupsFetch: ref.watch(serverUserGroupsFetchProvider),
    defaultGroupUpdate: ref.watch(defaultGroupUpdateProvider),
    createGroup: ref.watch(createGroupProvider),
  );
}
