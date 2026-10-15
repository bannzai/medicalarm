import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// 撮影した PNG の出力先ディレクトリ。`flutter drive --dart-define=SCREENSHOT_OUTPUT_DIR=...` で上書きする。
/// 既定値は scripts/translation/ui_test_env.sh の GENERATE_SCREENSHOT_ARTIFACT と同じ場所で、
/// iPhone Duo 版 (scripts/translation/generate_duo_screenshots.sh) は姿勢ごとに別の場所を渡す。
const String screenshotOutputDirectory = String.fromEnvironment('SCREENSHOT_OUTPUT_DIR', defaultValue: 'artifacts/screenshots');

/// 撮影するロケールの言語コード (カンマ区切り)。`--dart-define=SCREENSHOT_LANGUAGE_CODES=ja,en` で指定し、
/// 空なら全ロケールを撮る (既定)。ストアに載せる言語だけに絞って撮影時間を減らす用途。
const String screenshotLanguageCodes = String.fromEnvironment('SCREENSHOT_LANGUAGE_CODES');

/// true なら iOS の integration_test plugin ではなく Flutter の描画ツリーから PNG を作る。
/// plugin は UIScreen.mainScreen.bounds の大きさで描くため、iPhone Duo を開いて内側ディスプレイに移った後も
/// 外側 (1398×2034) の大きさに切り取られる (packages/integration_test/ios/.../IntegrationTestPlugin.m の
/// capturePngScreenshot。内側で撮ると右と下が欠けた 1398×2034 になることを実測)。
/// 描画ツリーから作ると Flutter の view の大きさ × devicePixelRatio (内側は 2853×2007) になる。
const bool screenshotRendersFromFlutterView = bool.fromEnvironment('SCREENSHOT_RENDER_FROM_FLUTTER_VIEW');

/// [locale] を撮影対象にするか。[screenshotLanguageCodes] が空なら常に true。
bool isScreenshotTargetLocale(Locale locale) {
  if (screenshotLanguageCodes.isEmpty) {
    return true;
  }
  return screenshotLanguageCodes.split(',').contains(locale.languageCode);
}

/// [screenshotName] のパスへ保存する PNG を撮る。
/// [screenshotRendersFromFlutterView] が false なら integration_test plugin に任せ、true なら
/// [boundaryKey] の RepaintBoundary を devicePixelRatio で描画し、plugin と同じ reportData の `screenshots` に積む
/// (test_driver/screenshot_test.dart の onScreenshot がテスト終了時にまとめてファイルへ書く)。
Future<void> takeScreenshotForStore({
  required IntegrationTestWidgetsFlutterBinding binding,
  required WidgetTester tester,
  required GlobalKey boundaryKey,
  required String screenshotName,
}) async {
  if (!screenshotRendersFromFlutterView) {
    await binding.takeScreenshot(screenshotName);
    return;
  }
  // toImage と toByteData は実時間の非同期処理のため、FakeAsync の外で動かす
  final bytes = await tester.runAsync(() async {
    final image = await (boundaryKey.currentContext!.findRenderObject()! as RenderRepaintBoundary).toImage(pixelRatio: tester.view.devicePixelRatio);
    // toByteData は native の画像を解放しないため、ロケールごとの撮影で内側 (2853×2007) の画像が GC まで残らないよう自分で解放する
    try {
      return (await image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  });
  binding.reportData ??= <String, dynamic>{};
  binding.reportData!['screenshots'] ??= <dynamic>[];
  (binding.reportData!['screenshots']! as List<dynamic>).add(<String, dynamic>{'screenshotName': screenshotName, 'bytes': bytes});
}
