import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/components/picker/number.dart';
import 'package:medicalarm/components/picker/toolbar.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/l10n/app_localizations.dart';

/// 文字を最大にした時の倍率。iOS のアクセシビリティの文字サイズの最大 (AX5) が本文の約 3 倍のため 3.0 を使う
const _largestTextScaleFactor = 3.0;

/// ピッカーを開いた時に選択中にする数字。服用間隔の初期値 8 時間に合わせる
const _initialNumber = 8;

/// 実機 (iPhone 17) の論理幅
const _deviceWidth = 402.0;

/// 英語表示で描画する幅。テスト用フォント (FlutterTest) の 1 文字は fontSize 四方の幅になり、ラテン文字では実機のフォントより横に長い。
/// 実機の幅 402 では倍率 3.0 の Cancel・Done が横にはみ出すため 600 にする
const _latinTextSurfaceWidth = 600.0;

/// [AppNumberPicker] を、幅 [width]・端末の文字サイズの倍率 [textScaleFactor] で画面の下端に描画する。
Future<void> _pumpNumberPicker(WidgetTester tester, {required double width, required double textScaleFactor}) async {
  // 実機 (iPhone 17) の論理高さ
  final size = Size(width, 874);
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: size, textScaler: TextScaler.linear(textScaleFactor)),
        child: const Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: AppNumberPicker(initialNumber: _initialNumber),
          ),
        ),
      ),
    ),
  );
}

/// [text] の文字を 1 行で描くのに要る高さ。親が高さを固定すると文字の描画領域はその高さに縮められて切れるため、
/// 描画後の矩形ではなく文字そのものの高さ (intrinsic height) を使う。
double _textIntrinsicHeight(WidgetTester tester, {required String text}) {
  return tester.renderObject<RenderParagraph>(find.text(text)).getMaxIntrinsicHeight(double.infinity);
}

/// [text] の文字が縦に切れず、[PickerToolbar] の矩形に収まっていることを検証する。
void _expectTextInsideToolbar(WidgetTester tester, {required String text}) {
  final toolbarRect = tester.getRect(find.byType(PickerToolbar));
  final textRect = tester.getRect(find.text(text));
  expect(textRect.height, greaterThanOrEqualTo(_textIntrinsicHeight(tester, text: text)), reason: '$text の文字の上下が切れている');
  expect(
    textRect.top >= toolbarRect.top && textRect.bottom <= toolbarRect.bottom,
    isTrue,
    reason: '$text の文字 $textRect が PickerToolbar $toolbarRect からはみ出している',
  );
}

/// 数字のピッカーの数字と PickerToolbar の Cancel・Done の文字が、文字を拡大しても切れないことを検証する。
/// https://github.com/bannzai/medicalarm/issues/522
void main() {
  tearDown(() {
    L = lookupAppLocalizations(const Locale('ja'));
  });

  group('英語表示・文字の倍率 3.0 の時', () {
    setUp(() {
      L = lookupAppLocalizations(const Locale('en'));
    });

    testWidgets('数字のピッカーの項目の高さは選択中の数字の高さより小さくならない', (WidgetTester tester) async {
      await _pumpNumberPicker(tester, width: _latinTextSurfaceWidth, textScaleFactor: _largestTextScaleFactor);

      expect(tester.takeException(), isNull);
      expect(
        tester.widget<CupertinoPicker>(find.byType(CupertinoPicker)).itemExtent,
        greaterThanOrEqualTo(_textIntrinsicHeight(tester, text: '$_initialNumber')),
      );
    });

    testWidgets('PickerToolbar の Cancel・Done の文字は行からはみ出さない', (WidgetTester tester) async {
      await _pumpNumberPicker(tester, width: _latinTextSurfaceWidth, textScaleFactor: _largestTextScaleFactor);

      expect(tester.takeException(), isNull);
      _expectTextInsideToolbar(tester, text: L.cancel);
      _expectTextInsideToolbar(tester, text: L.completed);
    });
  });

  // 日本語の文字はテスト用フォントでも実機でも 1 文字がほぼ fontSize 四方の幅になるため、実機の幅で描画する
  group('日本語表示・文字の倍率 3.0・実機の幅の時', () {
    setUp(() {
      L = lookupAppLocalizations(const Locale('ja'));
    });

    testWidgets('PickerToolbar のキャンセル・完了の文字は横にも縦にもはみ出さない', (WidgetTester tester) async {
      await _pumpNumberPicker(tester, width: _deviceWidth, textScaleFactor: _largestTextScaleFactor);

      expect(tester.takeException(), isNull);
      _expectTextInsideToolbar(tester, text: L.cancel);
      _expectTextInsideToolbar(tester, text: L.completed);
    });
  });

  group('英語表示・既定の文字サイズの時', () {
    setUp(() {
      L = lookupAppLocalizations(const Locale('en'));
    });

    testWidgets('数字のピッカーの項目の高さは 30、PickerToolbar の高さは 44 のまま', (WidgetTester tester) async {
      await _pumpNumberPicker(tester, width: _deviceWidth, textScaleFactor: 1.0);

      expect(tester.takeException(), isNull);
      expect(tester.widget<CupertinoPicker>(find.byType(CupertinoPicker)).itemExtent, 30);
      expect(tester.getSize(find.byType(PickerToolbar)).height, 44);
      _expectTextInsideToolbar(tester, text: L.cancel);
      _expectTextInsideToolbar(tester, text: L.completed);
    });
  });
}
