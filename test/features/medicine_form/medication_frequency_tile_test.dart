import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_form/components/medication_frequency/tile.dart';
import 'package:medicalarm/l10n/app_localizations.dart';

import 'text_lines.dart';

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

/// 薬の登録フォームの服用頻度の行で、値が長くてもラベルが単語の途中で折り返されないことを検証する。
/// https://github.com/bannzai/medicalarm/issues/466
void main() {
  tearDown(() {
    L = lookupAppLocalizations(const Locale('ja'));
  });

  testWidgets('英語表示で服用頻度が Cycle の時、ラベルは単語の途中で折り返されず値も表示される', (WidgetTester tester) async {
    L = lookupAppLocalizations(const Locale('en'));
    await _pumpCycleMedicationFrequencyTile(tester, textScaleFactor: 1.0);

    expectWrappedAtWordBoundaries(tester, text: L.medicationFrequency);
    expect(find.text(L.cycleDaysFormat(21, 7)), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  // iOS のアクセシビリティの文字サイズの最大 (AX5) が本文の約 3 倍のため 3.0 を使う
  testWidgets('英語表示で文字を拡大した時も、ラベルと値は単語の境目で折り返されはみ出さない', (WidgetTester tester) async {
    L = lookupAppLocalizations(const Locale('en'));
    await _pumpCycleMedicationFrequencyTile(tester, textScaleFactor: 3.0);

    expect(tester.takeException(), isNull);
    expectWrappedAtWordBoundaries(tester, text: L.medicationFrequency);
    expectWrappedAtWordBoundaries(tester, text: L.cycleDaysFormat(21, 7));
  });

  testWidgets('日本語表示で服用頻度が Cycle の時、ラベルは 1 行で表示され値も表示される', (WidgetTester tester) async {
    await _pumpCycleMedicationFrequencyTile(tester, textScaleFactor: 1.0);

    expect(lineTexts(tester, text: L.medicationFrequency), [L.medicationFrequency]);
    expect(find.text(L.cycleDaysFormat(21, 7)), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
