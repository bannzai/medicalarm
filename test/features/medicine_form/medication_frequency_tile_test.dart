import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_form/components/medication_frequency/tile.dart';
import 'package:medicalarm/l10n/app_localizations.dart';

/// 服用頻度を Cycle (21 日服用 / 7 日休薬) にした MedicationFrequencyTile を、端末の文字サイズの倍率 [textScaleFactor] で描画する。
Future<void> _pumpCycleMedicationFrequencyTile(WidgetTester tester, {required double textScaleFactor}) async {
  // テスト用フォント (FlutterTest) は 1 文字が fontSize 四方の幅になり実機のフォントより横に長い。
  // 修正前の実装で実測すると、幅 800 ではラベルが単語の境目で 2 行に折り返すだけで再現せず、
  // 幅 600 で実機 (iPhone 17) と同じく「Med / ica / tio / n Fre / ...」と単語の途中で折り返したため 600 を使う
  tester.view.physicalSize = const Size(600, 400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: const Size(600, 400), textScaler: TextScaler.linear(textScaleFactor)),
        child: Scaffold(body: MedicationFrequencyTile(frequency: ValueNotifier(const MedicationFrequency.cycle(consecutiveDays: 21, restDays: 7)))),
      ),
    ),
  );
}

/// [text] の各行が、[text] を空白で区切った単語だけでできていること (単語の途中で折り返されていないこと) を検証する。
void _expectWrappedAtWordBoundaries(WidgetTester tester, {required String text}) {
  final words = text.split(' ');
  for (final lineText in _lineTexts(tester, text: text)) {
    expect(lineText.trim().split(' ').every(words.contains), isTrue, reason: '「$lineText」の行で単語が途中で折り返されている');
  }
}

/// [text] を表示している Text の、各行の文字列。文字ごとの描画位置の top が変わった所を行の境目とする。
List<String> _lineTexts(WidgetTester tester, {required String text}) {
  final paragraph = tester.renderObject<RenderParagraph>(find.text(text));
  final lineTexts = <String>[];
  double? lineTop;
  for (var index = 0; index < text.length; index++) {
    final boxes = paragraph.getBoxesForSelection(TextSelection(baseOffset: index, extentOffset: index + 1));
    // 行末の空白は幅を持たず box が返らないことがあるため、直前の行に含める
    if (boxes.isEmpty || boxes.first.top == lineTop) {
      lineTexts.last += text[index];
      continue;
    }
    lineTop = boxes.first.top;
    lineTexts.add(text[index]);
  }
  return lineTexts;
}

/// 薬の登録フォームの服用頻度の行で、値が長くてもラベルが単語の途中で折り返されないことを検証する。
/// https://github.com/bannzai/medicalarm/issues/466
void main() {
  tearDown(() {
    L = lookupAppLocalizations(const Locale('ja'));
  });

  testWidgets('英語表示で服用頻度が Cycle の時、ラベルは単語の途中で折り返されず値も表示される', (WidgetTester tester) async {
    L = lookupAppLocalizations(const Locale('en'));
    await _pumpCycleMedicationFrequencyTile(tester, textScaleFactor: 1.0);

    _expectWrappedAtWordBoundaries(tester, text: L.medicationFrequency);
    expect(find.text(L.cycleDaysFormat(21, 7)), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  // iOS のアクセシビリティの文字サイズの最大 (AX5) が本文の約 3 倍のため 3.0 を使う
  testWidgets('英語表示で文字を拡大した時も、ラベルと値は単語の境目で折り返されはみ出さない', (WidgetTester tester) async {
    L = lookupAppLocalizations(const Locale('en'));
    await _pumpCycleMedicationFrequencyTile(tester, textScaleFactor: 3.0);

    expect(tester.takeException(), isNull);
    _expectWrappedAtWordBoundaries(tester, text: L.medicationFrequency);
    _expectWrappedAtWordBoundaries(tester, text: L.cycleDaysFormat(21, 7));
  });

  testWidgets('日本語表示で服用頻度が Cycle の時、ラベルは 1 行で表示され値も表示される', (WidgetTester tester) async {
    await _pumpCycleMedicationFrequencyTile(tester, textScaleFactor: 1.0);

    expect(_lineTexts(tester, text: L.medicationFrequency), [L.medicationFrequency]);
    expect(find.text(L.cycleDaysFormat(21, 7)), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
