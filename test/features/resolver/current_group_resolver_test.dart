import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/entity/app_user.dart';
import 'package:medicalarm/entity/group.dart';
import 'package:medicalarm/features/resolver/current_group.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/group_create.dart';
import 'package:medicalarm/provider/user_groups.dart';
import 'package:medicalarm/utils/analytics/error.dart';

/// 呼び出し回数を数える CreateGroup。Cloud Functions を呼ばずに作成した ID を返す。
class _CountingCreateGroup implements CreateGroup {
  /// call が呼ばれた回数。ソログループを作った回数を表す。
  int callCount = 0;

  @override
  Future<String> call({required String? name, required bool setAsDefault, required String iconName}) async {
    callCount++;
    return 'recreated-solo';
  }
}

/// 1 回目の呼び出しだけ失敗する CreateGroup。オフライン・Cloud Functions のエラーからの回復を表す。
class _FailingOnceCreateGroup implements CreateGroup {
  /// call が呼ばれた回数。失敗した呼び出しも数える。
  int callCount = 0;

  @override
  Future<String> call({required String? name, required bool setAsDefault, required String iconName}) async {
    callCount++;
    if (callCount == 1) {
      throw Exception('createGroup failed');
    }
    return 'recreated-solo';
  }
}

/// Firestore を読まずに [serverAppUser] をサーバーの user ドキュメントとして返す ServerAppUserFetch。
class _FakeServerAppUserFetch extends ServerAppUserFetch {
  /// サーバーにある user ドキュメントとして返す値。
  final AppUser serverAppUser;

  /// call を失敗させる残りの回数。オフライン等でサーバーから取得できない状態を表す。
  int remainingFailureCount;

  _FakeServerAppUserFetch({required this.serverAppUser, this.remainingFailureCount = 0}) : super(database: UserDatabase(userID: 'test-user'));

  @override
  Future<AppUser?> call() async {
    if (remainingFailureCount > 0) {
      remainingFailureCount--;
      throw Exception('serverAppUserFetch failed');
    }
    return serverAppUser;
  }
}

/// Crashlytics を呼ばない ErrorLogger。テストでは Firebase を初期化しないため差し替える。
class _NoopErrorLogger extends ErrorLogger {
  @override
  void recordError(dynamic exception, StackTrace? stack) {}
}

/// 移行済みのユーザー。[defaultGroupID] が null ならソログループを持たない状態を表す。
AppUser _migratedAppUser({required String? defaultGroupID}) =>
    AppUser(id: 'test-user', defaultGroupID: defaultGroupID, groupMigratedDateTime: DateTime(2026, 10, 30));

/// [appUserStream] をリスナーの user、[serverAppUser] をサーバーの user として CurrentGroupResolver を描画する。
Future<void> _pumpCurrentGroupResolver(
  WidgetTester tester, {
  required Stream<AppUser> appUserStream,
  required AppUser serverAppUser,
  required CreateGroup createGroup,
  int serverAppUserFetchFailureCount = 0,
}) {
  final serverAppUserFetch = _FakeServerAppUserFetch(serverAppUser: serverAppUser, remainingFailureCount: serverAppUserFetchFailureCount);
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        appUserProvider.overrideWith((ref) => appUserStream),
        serverAppUserFetchProvider.overrideWith((ref) => serverAppUserFetch),
        createGroupProvider.overrideWith((ref) => createGroup),
        userGroupsProvider.overrideWith((ref) => const Stream<List<Group>>.empty()),
      ],
      child: MaterialApp(home: CurrentGroupResolver(builder: (context) => const SizedBox.shrink())),
    ),
  );
}

void main() {
  // ソログループの作り直しは、サーバーで移行済みかつ defaultGroupID が null のユーザーにだけ行う (#465)。
  group('CurrentGroupResolver のソログループの作り直し', () {
    testWidgets('リスナーが移行の完了マーカーを defaultGroupID より先に流しても、サーバーに defaultGroupID があれば作り直さない', (tester) async {
      final appUserController = StreamController<AppUser>();
      addTearDown(appUserController.close);
      final createGroup = _CountingCreateGroup();
      await _pumpCurrentGroupResolver(
        tester,
        appUserStream: appUserController.stream,
        serverAppUser: _migratedAppUser(defaultGroupID: 'solo'),
        createGroup: createGroup,
      );

      // 初回起動の移行で、クライアントの groupMigratedDateTime の書き込みだけが反映された状態
      appUserController.add(_migratedAppUser(defaultGroupID: null));
      await tester.pump();
      await tester.pump();
      // 遅れてサーバーが書いた defaultGroupID を受け取った状態
      appUserController.add(_migratedAppUser(defaultGroupID: 'solo'));
      await tester.pump();
      await tester.pump();

      expect(createGroup.callCount, 0);
    });

    testWidgets('サーバーでも移行済みで defaultGroupID が null なら、ソログループを 1 回だけ作り直す', (tester) async {
      final appUserController = StreamController<AppUser>();
      addTearDown(appUserController.close);
      final createGroup = _CountingCreateGroup();
      await _pumpCurrentGroupResolver(
        tester,
        appUserStream: appUserController.stream,
        serverAppUser: _migratedAppUser(defaultGroupID: null),
        createGroup: createGroup,
      );

      // removeGroupMember 等でソログループを失った状態
      appUserController.add(_migratedAppUser(defaultGroupID: null));
      await tester.pump();
      await tester.pump();

      expect(createGroup.callCount, 1);
    });
  });

  // 作り直しに失敗しても、再試行の導線から読み込み中の画面を抜けられる (#470)。
  group('CurrentGroupResolver のソログループの作り直しの失敗', () {
    setUp(() {
      final originalErrorLogger = errorLogger;
      errorLogger = _NoopErrorLogger();
      addTearDown(() => errorLogger = originalErrorLogger);
    });

    testWidgets('createGroup が失敗したら再試行の導線を出し、押すと作り直しをもう一度呼ぶ', (tester) async {
      final appUserController = StreamController<AppUser>();
      addTearDown(appUserController.close);
      final createGroup = _FailingOnceCreateGroup();
      await _pumpCurrentGroupResolver(
        tester,
        appUserStream: appUserController.stream,
        serverAppUser: _migratedAppUser(defaultGroupID: null),
        createGroup: createGroup,
      );

      appUserController.add(_migratedAppUser(defaultGroupID: null));
      await tester.pump();
      await tester.pump();

      expect(createGroup.callCount, 1);
      expect(find.byType(RetryPage), findsOneWidget);

      await tester.tap(find.text(L.retry));
      await tester.pump();
      await tester.pump();

      expect(createGroup.callCount, 2);
    });

    testWidgets('サーバーからの user ドキュメントの取得が失敗したら再試行の導線を出し、押すと作り直しをもう一度呼ぶ', (tester) async {
      final appUserController = StreamController<AppUser>();
      addTearDown(appUserController.close);
      final createGroup = _CountingCreateGroup();
      await _pumpCurrentGroupResolver(
        tester,
        appUserStream: appUserController.stream,
        serverAppUser: _migratedAppUser(defaultGroupID: null),
        createGroup: createGroup,
        serverAppUserFetchFailureCount: 1,
      );

      appUserController.add(_migratedAppUser(defaultGroupID: null));
      await tester.pump();
      await tester.pump();

      expect(createGroup.callCount, 0);
      expect(find.byType(RetryPage), findsOneWidget);

      await tester.tap(find.text(L.retry));
      await tester.pump();
      await tester.pump();

      expect(createGroup.callCount, 1);
    });
  });
}
