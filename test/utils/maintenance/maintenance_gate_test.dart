import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:medicalarm/utils/maintenance/maintenance_gate.dart';
import 'package:medicalarm/utils/maintenance/maintenance_state.dart';

/// テストで状態を読む先として渡す URL
final stateURL = Uri.parse('https://service-maintenance.example.workers.dev/snapmon');

/// message と button を持つメンテナンス中の応答 (状態を返す Worker が返す JSON)
const inMaintenanceWithButton = {
  'maintenance': true,
  'message': '復旧までお待ちください',
  'button': {'label': 'お知らせを見る', 'url': 'https://example.com/news'},
  'source': 'owner',
  'changedAt': '2026-11-25T07:00:00.000Z',
};

/// message も button も無いメンテナンス中の応答
const inMaintenanceWithoutButton = {'maintenance': true, 'message': null, 'button': null, 'source': 'cost', 'changedAt': '2026-11-25T07:00:00.000Z'};

/// メンテナンス中でない応答
const notInMaintenance = {'maintenance': false, 'message': null, 'button': null, 'source': 'owner', 'changedAt': '2026-11-25T08:00:00.000Z'};

/// 返す応答を後から差し替えられる HTTP のクライアントの代わり。読まれた URL を requestedURLs に残す。
/// テストが途中で body・statusCode・fail を書き換えて読むため、書き換えられる値を持つ class にした
/// (Dart には、書き換えられる値を持つ物を作る関数の書き方として、TypeScript の object literal に当たるものが無い)
class SwitchableClient {
  /// 最初に返す応答の body から作る
  SwitchableClient(this.body);

  /// 応答の body (JSON にして返す値)
  Object? body;

  /// 応答の HTTP の status
  int statusCode = 200;

  /// true の間、通信の失敗として例外を投げる
  bool fail = false;

  /// 読まれた URL (読まれた順)
  final requestedURLs = <Uri>[];

  /// MaintenanceGate に渡す HTTP のクライアント
  http.Client get client => MockClient((request) async {
    requestedURLs.add(request.url);
    if (fail) throw http.ClientException('connection failed');
    return http.Response.bytes(utf8.encode(jsonEncode(body)), statusCode);
  });
}

/// MaintenanceGate を、アプリの一番外側 (MaterialApp の builder) に置いたアプリを組み、押されたボタンの URL を貯める一覧を返す。
/// [home] は通常の画面。[settle] が false の時は、読み取りが返るのを待たずに戻る (返らない読み取りを試すテストのため)
Future<List<Uri>> pumpApp(WidgetTester tester, http.Client client, {Widget home = const Scaffold(body: Text('通常の画面')), bool settle = true}) async {
  final openedURLs = <Uri>[];
  await tester.pumpWidget(
    MaterialApp(
      builder: (context, child) =>
          MaintenanceGate(stateURL: stateURL, defaultMessage: 'ただいまメンテナンス中です', onOpenURL: openedURLs.add, client: client, child: child!),
      home: home,
    ),
  );
  if (settle) await tester.pumpAndSettle();
  return openedURLs;
}

void main() {
  testWidgets('メンテナンス中は通常の画面の代わりに、状態の文とボタンを出す', (tester) async {
    final switchableClient = SwitchableClient(inMaintenanceWithButton);
    final openedURLs = await pumpApp(tester, switchableClient.client);

    expect(switchableClient.requestedURLs, [stateURL]);
    expect(find.text('復旧までお待ちください'), findsOneWidget);
    expect(find.text('通常の画面'), findsNothing);

    await tester.tap(find.widgetWithText(ElevatedButton, 'お知らせを見る'));
    expect(openedURLs, [Uri.parse('https://example.com/news')]);
  });

  testWidgets('button が null の時はボタンを出さず、message が null の時はサービスの既定の文を出す', (tester) async {
    await pumpApp(tester, SwitchableClient(inMaintenanceWithoutButton).client);

    expect(find.text('ただいまメンテナンス中です'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNothing);
    expect(find.text('通常の画面'), findsNothing);
  });

  testWidgets('メンテナンス中でない時は通常の画面を出す', (tester) async {
    await pumpApp(tester, SwitchableClient(notInMaintenance).client);

    expect(find.text('通常の画面'), findsOneWidget);
    expect(find.byType(MaintenanceScreen), findsNothing);
  });

  testWidgets('状態を読めない時 (通信の失敗) は通常の画面を出す', (tester) async {
    final switchableClient = SwitchableClient(inMaintenanceWithButton)..fail = true;
    await pumpApp(tester, switchableClient.client);

    expect(switchableClient.requestedURLs, hasLength(1));
    expect(find.text('通常の画面'), findsOneWidget);
    expect(find.byType(MaintenanceScreen), findsNothing);
  });

  testWidgets('状態を読めない時 (200 以外の応答・形の違う応答) は通常の画面を出す', (tester) async {
    final switchableClient = SwitchableClient(inMaintenanceWithButton)..statusCode = 500;
    await pumpApp(tester, switchableClient.client);
    expect(find.text('通常の画面'), findsOneWidget);

    switchableClient
      ..statusCode = 200
      ..body = {'maintenance': 'yes'};
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(switchableClient.requestedURLs, hasLength(2));
    expect(find.text('通常の画面'), findsOneWidget);
    expect(find.byType(MaintenanceScreen), findsNothing);
  });

  testWidgets('応答が 2 秒返らない時は待つのをやめ、メンテナンス中の画面から通常の画面に戻す', (tester) async {
    var readCount = 0;
    // 1 回目はメンテナンス中を返し、2 回目からは応答を返さない
    await pumpApp(
      tester,
      MockClient((_) async {
        readCount += 1;
        if (readCount == 1) return http.Response.bytes(utf8.encode(jsonEncode(inMaintenanceWithButton)), 200);
        return Completer<http.Response>().future;
      }),
    );
    expect(find.text('復旧までお待ちください'), findsOneWidget);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump(const Duration(milliseconds: 1999));
    expect(readCount, 2);
    expect(find.text('復旧までお待ちください'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('通常の画面'), findsOneWidget);
    expect(find.byType(MaintenanceScreen), findsNothing);
  });

  testWidgets('既定では 60 秒ごとに読み直し、切り替わった状態で画面を切り替える', (tester) async {
    final switchableClient = SwitchableClient(notInMaintenance);
    await pumpApp(tester, switchableClient.client);
    expect(find.text('通常の画面'), findsOneWidget);

    switchableClient.body = inMaintenanceWithButton;
    await tester.pump(const Duration(seconds: 59));
    await tester.pumpAndSettle();
    expect(switchableClient.requestedURLs, hasLength(1));
    expect(find.text('通常の画面'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(switchableClient.requestedURLs, hasLength(2));
    expect(find.text('復旧までお待ちください'), findsOneWidget);
    expect(find.text('通常の画面'), findsNothing);

    switchableClient.body = notInMaintenance;
    await tester.pump(const Duration(seconds: 60));
    await tester.pumpAndSettle();
    expect(switchableClient.requestedURLs, hasLength(3));
    expect(find.text('通常の画面'), findsOneWidget);
    expect(find.byType(MaintenanceScreen), findsNothing);
  });

  testWidgets('背面にいる間は時間が過ぎても読まず、前面に戻った後はまた間隔ごとに読む', (tester) async {
    final switchableClient = SwitchableClient(notInMaintenance);
    await pumpApp(tester, switchableClient.client);
    expect(switchableClient.requestedURLs, hasLength(1));

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump(const Duration(seconds: 180));
    await tester.pumpAndSettle();
    expect(switchableClient.requestedURLs, hasLength(1));

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(switchableClient.requestedURLs, hasLength(2));

    await tester.pump(const Duration(seconds: 60));
    await tester.pumpAndSettle();
    expect(switchableClient.requestedURLs, hasLength(3));
  });

  testWidgets('背面で作られた時は、前面に出るまで間隔ごとに読まない', (tester) async {
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    final switchableClient = SwitchableClient(notInMaintenance);
    // 背面の間は描画のフレームが予約されないため、背面で作られた状況を作るには、強制のフレームで build させる
    tester.binding.scheduleForcedFrame();
    await pumpApp(tester, switchableClient.client);
    expect(switchableClient.requestedURLs, hasLength(1));

    await tester.pump(const Duration(seconds: 180));
    await tester.pumpAndSettle();
    expect(switchableClient.requestedURLs, hasLength(1));

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 60));
    await tester.pumpAndSettle();
    expect(switchableClient.requestedURLs, hasLength(3));
  });

  testWidgets('メンテナンス中は、隠した通常の画面がフォーカスを持たない', (tester) async {
    final switchableClient = SwitchableClient(notInMaintenance);
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await pumpApp(
      tester,
      switchableClient.client,
      home: Scaffold(body: TextField(focusNode: focusNode, autofocus: true)),
    );
    expect(focusNode.hasFocus, true);

    switchableClient.body = inMaintenanceWithButton;
    await tester.pump(const Duration(seconds: 60));
    await tester.pumpAndSettle();
    expect(focusNode.hasFocus, false);
  });

  testWidgets('前面に戻った時に読み直し、背面に回った時は読まない', (tester) async {
    final switchableClient = SwitchableClient(notInMaintenance);
    await pumpApp(tester, switchableClient.client);

    switchableClient.body = inMaintenanceWithButton;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pumpAndSettle();
    expect(switchableClient.requestedURLs, hasLength(1));

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(switchableClient.requestedURLs, hasLength(2));
    expect(find.text('復旧までお待ちください'), findsOneWidget);
  });

  testWidgets('後から始めた読み取りが先に返った時は、古い読み取りの結果で画面を戻さない', (tester) async {
    final pendingResponses = <Completer<http.Response>>[];
    await pumpApp(
      tester,
      MockClient((_) {
        final pendingResponse = Completer<http.Response>();
        pendingResponses.add(pendingResponse);
        return pendingResponse.future;
      }),
      settle: false,
    );
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(pendingResponses, hasLength(2));

    pendingResponses[1].complete(http.Response.bytes(utf8.encode(jsonEncode(inMaintenanceWithButton)), 200));
    await tester.pumpAndSettle();
    expect(find.text('復旧までお待ちください'), findsOneWidget);

    pendingResponses[0].complete(http.Response.bytes(utf8.encode(jsonEncode(notInMaintenance)), 200));
    await tester.pumpAndSettle();
    expect(find.text('復旧までお待ちください'), findsOneWidget);
    expect(find.text('通常の画面'), findsNothing);
  });

  testWidgets('メンテナンスが終わると、隠していた通常の画面を、入力した内容を保ったまま出す', (tester) async {
    final switchableClient = SwitchableClient(notInMaintenance);
    await pumpApp(tester, switchableClient.client, home: const Scaffold(body: TextField()));
    await tester.enterText(find.byType(TextField), '書きかけの文');

    switchableClient.body = inMaintenanceWithButton;
    await tester.pump(const Duration(seconds: 60));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);

    switchableClient.body = notInMaintenance;
    await tester.pump(const Duration(seconds: 60));
    await tester.pumpAndSettle();
    expect(find.text('書きかけの文'), findsOneWidget);
  });

  testWidgets('読み取りの途中で外された時は、返った結果を反映しようとしない', (tester) async {
    final pendingResponse = Completer<http.Response>();
    await pumpApp(tester, MockClient((_) => pendingResponse.future), settle: false);
    await tester.pumpWidget(const SizedBox());

    pendingResponse.complete(http.Response.bytes(utf8.encode(jsonEncode(inMaintenanceWithButton)), 200));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('メンテナンス中は、隠した通常の画面のアニメーションを止める', (tester) async {
    final switchableClient = SwitchableClient(notInMaintenance);
    await pumpApp(tester, switchableClient.client, home: Builder(builder: (context) => Text('アニメーション: ${TickerMode.valuesOf(context).enabled}')));
    expect(find.text('アニメーション: true'), findsOneWidget);

    switchableClient.body = inMaintenanceWithButton;
    await tester.pump(const Duration(seconds: 60));
    await tester.pumpAndSettle();
    expect(find.text('アニメーション: false', skipOffstage: false), findsOneWidget);
  });

  testWidgets('inactive (前面のまま操作を受けない) の時に作られた時も、間隔ごとに読む', (tester) async {
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    final switchableClient = SwitchableClient(notInMaintenance);
    await pumpApp(tester, switchableClient.client);
    expect(switchableClient.requestedURLs, hasLength(1));

    await tester.pump(const Duration(seconds: 60));
    await tester.pumpAndSettle();
    expect(switchableClient.requestedURLs, hasLength(2));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
  });

  for (final backgroundState in [AppLifecycleState.paused, AppLifecycleState.hidden, AppLifecycleState.detached]) {
    testWidgets('前面から $backgroundState に変わった後は、時間が過ぎても読まない', (tester) async {
      final switchableClient = SwitchableClient(notInMaintenance);
      await pumpApp(tester, switchableClient.client);
      tester.binding.handleAppLifecycleStateChanged(backgroundState);
      await tester.pump(const Duration(seconds: 180));
      await tester.pumpAndSettle();
      expect(switchableClient.requestedURLs, hasLength(1));
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    });
  }

  testWidgets('client を渡さない時は、package:http の既定のクライアントで stateURL を読む', (tester) async {
    final requestedURLs = <Uri>[];
    await http.runWithClient(
      () async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => MaintenanceGate(stateURL: stateURL, defaultMessage: 'ただいまメンテナンス中です', onOpenURL: (_) {}, child: child!),
            home: const Scaffold(body: Text('通常の画面')),
          ),
        );
        await tester.pumpAndSettle();
      },
      () => MockClient((request) async {
        requestedURLs.add(request.url);
        return http.Response.bytes(utf8.encode(jsonEncode(inMaintenanceWithButton)), 200);
      }),
    );
    expect(requestedURLs, [stateURL]);
    expect(find.text('復旧までお待ちください'), findsOneWidget);
  });

  group('MaintenanceState.tryParse', () {
    test('5 つの項目がそろった値を読む', () {
      final maintenanceState = MaintenanceState.tryParse(inMaintenanceWithButton)!;
      expect(maintenanceState.maintenance, true);
      expect(maintenanceState.message, '復旧までお待ちください');
      expect(maintenanceState.button!.label, 'お知らせを見る');
      expect(maintenanceState.button!.url, Uri.parse('https://example.com/news'));
      expect(maintenanceState.source, 'owner');
      expect(maintenanceState.changedAt, '2026-11-25T07:00:00.000Z');
    });

    test('maintenance・source・changedAt の形が違う値は null を返す', () {
      expect(MaintenanceState.tryParse(null), isNull);
      expect(MaintenanceState.tryParse('maintenance'), isNull);
      expect(MaintenanceState.tryParse({...inMaintenanceWithButton, 'maintenance': 'true'}), isNull);
      expect(MaintenanceState.tryParse({...inMaintenanceWithButton, 'source': 'admin'}), isNull);
      expect(MaintenanceState.tryParse({...inMaintenanceWithButton, 'changedAt': 1764054000}), isNull);
    });

    test('source が usage (利用量で切り替わった) の値を読む', () {
      expect(MaintenanceState.tryParse({...inMaintenanceWithButton, 'source': 'usage'})!.source, 'usage');
    });

    test('空文字の message は null にする (画面にはサービスの既定の文を出す)', () {
      expect(MaintenanceState.tryParse({...inMaintenanceWithButton, 'message': ''})!.message, isNull);
    });

    test('開けない url・空の label の button は、メンテナンス中のまま button だけ null にする', () {
      for (final button in [
        {'label': '開く', 'url': 'javascript:alert(1)'},
        {'label': '開く', 'url': 'example.com/news'},
        // authority はあるが scheme が http・https でない
        {'label': '開く', 'url': 'ftp://example.com/'},
        // scheme は https だが authority が無い
        {'label': '開く', 'url': 'https:news'},
        // URL として解析できない
        {'label': '開く', 'url': 'http://[::1'},
        // url が文字列でない
        {'label': '開く', 'url': 1},
        {'label': '', 'url': 'https://example.com/news'},
        {'url': 'https://example.com/news'},
        'https://example.com/news',
      ]) {
        final maintenanceState = MaintenanceState.tryParse({...inMaintenanceWithButton, 'button': button})!;
        expect(maintenanceState.maintenance, true, reason: '$button');
        expect(maintenanceState.button, isNull, reason: '$button');
      }
    });

    test('http の url の button は読む', () {
      expect(
        MaintenanceState.tryParse({
          ...inMaintenanceWithButton,
          'button': {'label': '開く', 'url': 'http://example.com/'},
        })!.button!.url,
        Uri.parse('http://example.com/'),
      );
    });
  });
}
