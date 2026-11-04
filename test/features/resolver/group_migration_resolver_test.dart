import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/app_user.dart';
import 'package:medicalarm/entity/group.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/features/resolver/group_migration.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/default_group_update.dart';
import 'package:medicalarm/provider/group_create.dart';
import 'package:medicalarm/provider/user_groups.dart';
import 'package:medicalarm/utils/analytics/error.dart';

/// 呼び出し回数を数える CreateGroup。無料プランの上限 (2 件) を超えた呼び出しは Cloud Functions と同じく例外にする。
class _CountingCreateGroup implements CreateGroup {
  /// 作成に成功した呼び出しの回数。ソログループを作った回数を表す。
  int callCount = 0;

  /// サーバーに既にあるオーナーのグループの件数。
  final int ownedGroupCount;

  _CountingCreateGroup({required this.ownedGroupCount});

  @override
  Future<String> call({required String? name, required bool setAsDefault, required String iconName}) async {
    if (ownedGroupCount >= 2) {
      throw Exception('無料プランの上限');
    }
    callCount++;
    return 'created-solo';
  }
}

/// Firestore を読まずに [serverAppUser] をサーバーの user ドキュメントとして返す ServerAppUserFetch。
class _FakeServerAppUserFetch extends ServerAppUserFetch {
  /// サーバーにある user ドキュメントとして返す値。
  final AppUser? serverAppUser;

  _FakeServerAppUserFetch({required this.serverAppUser}) : super(database: UserDatabase(userID: 'test-user'));

  @override
  Future<AppUser?> call() async => serverAppUser;
}

/// Firestore を読まずに [groups] をサーバーの所属グループとして返す ServerUserGroupsFetch。
class _FakeServerUserGroupsFetch extends ServerUserGroupsFetch {
  /// サーバーにある所属グループとして返す値。
  final List<Group> groups;

  _FakeServerUserGroupsFetch({required this.groups}) : super(database: UserDatabase(userID: 'test-user'));

  @override
  Future<List<Group>> call() async => groups;
}

/// Firestore に書かず、既定にしたグループの ID を記録する DefaultGroupUpdate。
class _RecordingDefaultGroupUpdate extends DefaultGroupUpdate {
  /// call に渡されたグループの ID。呼ばれていなければ null。
  String? updatedGroupID;

  _RecordingDefaultGroupUpdate() : super(userDatabase: UserDatabase(userID: 'test-user'));

  @override
  Future<void> call({required String groupID}) async {
    updatedGroupID = groupID;
  }
}

/// Crashlytics を呼ばない ErrorLogger。テストでは Firebase を初期化しないため差し替える。
class _NoopErrorLogger extends ErrorLogger {
  @override
  void recordError(dynamic exception, StackTrace? stack) {}
}

/// 移行前のユーザーがリスナーに流れた状態で GroupMigrationResolver を描画する。
///
/// 移行本体は Firebase を初期化していないテストでは失敗するが、この手前のソログループの判定だけを確かめるため無視する。
Future<void> _pumpGroupMigrationResolver(
  WidgetTester tester, {
  required AppUser? serverAppUser,
  required List<Group> serverUserGroups,
  required CreateGroup createGroup,
  required DefaultGroupUpdate defaultGroupUpdate,
}) async {
  final appUserController = StreamController<AppUser>();
  addTearDown(appUserController.close);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userDatabaseProvider.overrideWith((ref) => UserDatabase(userID: 'test-user')),
        appUserProvider.overrideWith((ref) => appUserController.stream),
        serverAppUserFetchProvider.overrideWith((ref) => _FakeServerAppUserFetch(serverAppUser: serverAppUser)),
        serverUserGroupsFetchProvider.overrideWith((ref) => _FakeServerUserGroupsFetch(groups: serverUserGroups)),
        defaultGroupUpdateProvider.overrideWith((ref) => defaultGroupUpdate),
        createGroupProvider.overrideWith((ref) => createGroup),
      ],
      child: MaterialApp(home: GroupMigrationResolver(builder: (context) => const SizedBox.shrink())),
    ),
  );
  appUserController.add(const AppUser(id: 'test-user'));
  await tester.pump();
  await tester.pump();
}

/// [id] のオーナーのグループ。
Group _ownedGroup({required String id, required DateTime createdDateTime}) {
  return Group(id: id, memberUserIDs: const ['test-user'], name: null, ownerUserID: 'test-user', createdDateTime: createdDateTime);
}

void main() {
  group('GroupMigrationResolver のソログループの用意', () {
    setUp(() {
      final originalErrorLogger = errorLogger;
      errorLogger = _NoopErrorLogger();
      addTearDown(() => errorLogger = originalErrorLogger);
    });

    testWidgets('グループを持たない新しいユーザーにはソログループを 1 つ作る', (tester) async {
      final createGroup = _CountingCreateGroup(ownedGroupCount: 0);
      final defaultGroupUpdate = _RecordingDefaultGroupUpdate();
      await _pumpGroupMigrationResolver(
        tester,
        serverAppUser: const AppUser(id: 'test-user'),
        serverUserGroups: const [],
        createGroup: createGroup,
        defaultGroupUpdate: defaultGroupUpdate,
      );

      expect(createGroup.callCount, 1);
      expect(defaultGroupUpdate.updatedGroupID, isNull);
    });

    testWidgets('リスナーの値に defaultGroupID が無くてもサーバーにあれば作らない', (tester) async {
      final createGroup = _CountingCreateGroup(ownedGroupCount: 1);
      final defaultGroupUpdate = _RecordingDefaultGroupUpdate();
      await _pumpGroupMigrationResolver(
        tester,
        serverAppUser: const AppUser(id: 'test-user', defaultGroupID: 'solo'),
        serverUserGroups: [_ownedGroup(id: 'solo', createdDateTime: DateTime(2026, 11, 4))],
        createGroup: createGroup,
        defaultGroupUpdate: defaultGroupUpdate,
      );

      expect(createGroup.callCount, 0);
      expect(defaultGroupUpdate.updatedGroupID, isNull);
    });

    testWidgets('上限までグループを持ち defaultGroupID を失ったユーザーは、作らず最も古いグループを既定にする', (tester) async {
      final createGroup = _CountingCreateGroup(ownedGroupCount: 2);
      final defaultGroupUpdate = _RecordingDefaultGroupUpdate();
      await _pumpGroupMigrationResolver(
        tester,
        serverAppUser: const AppUser(id: 'test-user'),
        serverUserGroups: [
          _ownedGroup(id: 'second', createdDateTime: DateTime(2026, 11, 4, 12)),
          _ownedGroup(id: 'first', createdDateTime: DateTime(2026, 11, 4, 11)),
        ],
        createGroup: createGroup,
        defaultGroupUpdate: defaultGroupUpdate,
      );

      expect(createGroup.callCount, 0);
      expect(defaultGroupUpdate.updatedGroupID, 'first');
    });
  });
}
