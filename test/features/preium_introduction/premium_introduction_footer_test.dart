import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/preium_introduction/components/premium_introduction_footer.dart';
import 'package:medicalarm/l10n/app_localizations.dart';

void main() {
  /// 指定した言語の L で footer を表示し、注意書きの RichText の全文を返す
  Future<String> pumpFooterText(WidgetTester tester, {required String languageCode}) async {
    L = lookupAppLocalizations(Locale(languageCode));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PremiumIntroductionFotter(isLoading: ValueNotifier(false)),
        ),
      ),
    );
    return tester.widget<RichText>(find.byType(RichText).first).text.toPlainText();
  }

  tearDown(() {
    L = lookupAppLocalizations(const Locale('ja'));
  });

  // issue #498: 特定商取引法のリンクと次の文が空白なしで連結される不具合の回帰テスト
  for (final languageCode in ['en', 'kn', 'gu', 'th']) {
    testWidgets('$languageCode ではリンクと次の文の間に空白が入る', (tester) async {
      // pumpFooterText が L を切り替えた後に contains の中の L を評価させるため、引数の左から順に評価される順序に頼る
      expect(await pumpFooterText(tester, languageCode: languageCode),
          contains('${L.specifiedCommercialTransactionAct} ${L.confirmBeforeRegistration}\n'));
    });
  }

  for (final languageCode in ['ja', 'zh']) {
    testWidgets('$languageCode ではリンクと次の文が空白なしで続く', (tester) async {
      expect(await pumpFooterText(tester, languageCode: languageCode),
          contains('${L.specifiedCommercialTransactionAct}${L.confirmBeforeRegistration}\n'));
    });
  }
}
