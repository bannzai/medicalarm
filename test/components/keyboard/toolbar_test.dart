import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/components/keyboard/toolbar.dart';

/// [viewInsetsBottom] をキーボードの高さとして渡した MediaQuery の下に KeyboardToolbar を置く。
Widget keyboardToolbarApp({required double viewInsetsBottom}) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(viewInsets: EdgeInsets.only(bottom: viewInsetsBottom)),
      // 日記の投稿画面 (lib/features/diary_post/page.dart) と同じく、Scaffold が body の viewInsets を取り除かない設定にする
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            const Expanded(child: SizedBox.shrink()),
            KeyboardToolbar(
              doneButton: TextButton(onPressed: () {}, child: const Text('done')),
            ),
          ],
        ),
      ),
    ),
  );
}

void main() {
  group('KeyboardToolbar', () {
    testWidgets('キーボードを閉じる途中で viewInsets.bottom が負になっても例外を出さず、下の余白を 0 にする', (tester) async {
      // nightly E2E の run 44148328382 で、日記の保存でキーボードを閉じる間に h=-179.8 の SizedBox への更新が起き、
      // BoxConstraints の負の高さの例外から `_dependents.isEmpty` の赤画面に至った (#387)。同じ更新の経路を通すため 2 回 pump する
      await tester.pumpWidget(keyboardToolbarApp(viewInsetsBottom: 0));
      await tester.pumpWidget(keyboardToolbarApp(viewInsetsBottom: -179.8));

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(KeyboardToolbar)).height, keyboardToolbarHeight);
    });

    testWidgets('キーボードが出ていない時 (viewInsets.bottom が 0) は toolbar の高さだけになる', (tester) async {
      await tester.pumpWidget(keyboardToolbarApp(viewInsetsBottom: 0));

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(KeyboardToolbar)).height, keyboardToolbarHeight);
    });

    testWidgets('キーボードが出ている時は toolbar の下にキーボードの高さの余白を取る', (tester) async {
      await tester.pumpWidget(keyboardToolbarApp(viewInsetsBottom: 336));

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(KeyboardToolbar)).height, keyboardToolbarHeight + 336);
    });
  });
}
