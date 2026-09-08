import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/components/fab/layout.dart';

// #288: 画面下部に重ねるボタン列の領域に Scaffold の背景色で不透明な下地を敷き、
// 背景を持たない上限メッセージが下の本文と重なって読めなくなる回帰を検出するためのテスト
void main() {
  // Scaffold の背景色が下地へ反映されることを確認する番兵色。AppColors の実値と無関係な値にする
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

  /// ボタン列の子を包む、Scaffold の背景色で塗られた不透明な下地
  Finder opaqueBackdropFinder() {
    return find.ancestor(
      of: find.byKey(fabChildKey),
      matching: find.byWidgetPredicate((widget) => widget is Container && widget.color == sentinelScaffoldBackground),
    );
  }

  testWidgets('ボタン列の子は Scaffold の背景色で塗られた不透明な下地の上に置かれる', (tester) async {
    await tester.pumpWidget(buildSubject());

    expect(opaqueBackdropFinder(), findsOneWidget);
  });

  testWidgets('下地は画面下部のボタン列の高さに収まり、本文全体を覆わない', (tester) async {
    await tester.pumpWidget(buildSubject());

    final backdropRect = tester.getRect(opaqueBackdropFinder());
    final bodyRect = tester.getRect(find.byKey(bodyKey));

    // Column が Stack の全高へ広がると下地が本文全体を覆う (Spacer を使っていた旧実装の回帰)
    expect(backdropRect.height, lessThan(bodyRect.height / 2));
    expect(backdropRect.bottom, bodyRect.bottom);
    expect(backdropRect.width, bodyRect.width);
  });
}
