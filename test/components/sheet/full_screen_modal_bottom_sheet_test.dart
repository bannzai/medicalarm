import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/components/sheet/full_screen_modal_bottom_sheet.dart';

/// 端末の safe area (左右とステータスバー) を模した画面でシートを開き、シートの中身の位置を測る。
/// 左右の safe area は iPhone Duo の右端のステータス表示の列を想定する。
void main() {
  const devicePixelRatio = 3.0;
  // iPhone 17 Pro と同じ画面の大きさ。既定のテスト画面 (800×600) は幅が BottomSheet の既定の上限 640 を超え、
  // シートが中央に寄って safe area と無関係に左右が空くため
  const physicalSize = Size(1206, 2622);
  const viewPadding = FakeViewPadding(left: 0, top: 150, right: 180, bottom: 0);

  Future<Rect> pumpAndOpenSheet(WidgetTester tester) async {
    tester.view.devicePixelRatio = devicePixelRatio;
    tester.view.physicalSize = physicalSize;
    tester.view.padding = viewPadding;
    addTearDown(tester.view.reset);

    const sheetKey = Key('sheet');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(),
          // 祖先の Scaffold / SafeArea が safe area を消費した後の context から開く (実際の呼び出し元と同じ条件)
          body: SafeArea(
            child: Builder(
              builder: (context) => TextButton(
                onPressed: () => showFullScreenModalBottomSheet(
                  context: context,
                  builder: (context) => const SizedBox.expand(key: sheetKey),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return tester.getRect(find.byKey(sheetKey));
  }

  testWidgets('シートは左右の safe area を避けず画面の幅いっぱいに広がる', (tester) async {
    final rect = await pumpAndOpenSheet(tester);
    expect(rect.left, 0);
    expect(rect.right, physicalSize.width / devicePixelRatio);
  });

  testWidgets('シートの上端は祖先の SafeArea に関係なくステータスバーの高さだけ空く', (tester) async {
    final rect = await pumpAndOpenSheet(tester);
    expect(rect.top, viewPadding.top / devicePixelRatio);
  });
}
