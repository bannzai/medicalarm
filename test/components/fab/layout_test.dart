import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/components/fab/layout.dart';

// #288: 画面下部のボタン列を Scaffold の背景色で塗った不透明な帯として本文の下に置き、
// 背景を持たない上限メッセージが本文と重なって読めなくなる回帰、および帯の裏に本文の末尾が隠れる回帰を検出するためのテスト
void main() {
  // Scaffold の背景色が帯へ反映されることを確認する番兵色。AppColors の実値と無関係な値にする
  const sentinelScaffoldBackground = Color(0xFF123456);
  const bodyKey = Key('body');
  const fabChildKey = Key('fab-child');

  Widget buildSubject() {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: sentinelScaffoldBackground, useMaterial3: false),
      home: Scaffold(
        body: FloatingActionButtonLayout(
          scaffoldBody: const SizedBox.expand(key: bodyKey),
          floatingActionButton: const Text('上限メッセージ', key: fabChildKey),
        ),
      ),
    );
  }

  /// ボタン列の子を包む、Scaffold の背景色で塗られた不透明な帯
  Finder opaqueBackdropFinder() {
    return find.ancestor(
      of: find.byKey(fabChildKey),
      matching: find.byWidgetPredicate((widget) => widget is Container && widget.color == sentinelScaffoldBackground),
    );
  }

  testWidgets('ボタン列の子は Scaffold の背景色で塗られた不透明な帯の上に置かれる', (tester) async {
    await tester.pumpWidget(buildSubject());

    expect(opaqueBackdropFinder(), findsOneWidget);
  });

  testWidgets('帯は画面下端に置かれ、本文は帯と重ならずその上に収まる', (tester) async {
    await tester.pumpWidget(buildSubject());

    final backdropRect = tester.getRect(opaqueBackdropFinder());
    final bodyRect = tester.getRect(find.byKey(bodyKey));
    final screenRect = tester.getRect(find.byType(Scaffold));

    expect(backdropRect.bottom, screenRect.bottom);
    expect(backdropRect.width, screenRect.width);
    // 帯が本文に重なると、帯の高さ (上限メッセージの有無で変わる) の分だけ本文の末尾がスクロールしても隠れる
    expect(bodyRect.bottom, lessThanOrEqualTo(backdropRect.top));
    // 本文が帯の高さ以上に縮められていないこと (旧実装の Spacer のように帯が全高へ広がる回帰)
    expect(backdropRect.height, lessThan(screenRect.height / 2));
  });
}
