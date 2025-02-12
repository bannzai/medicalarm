import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicalarm/features/localization/l.dart';

import 'screenshot_medications.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    final locales = AppLocalizations.supportedLocales;
    for (final locale in locales) {
      testWidgets('screenshot medications $locale', (tester) async {
        L = lookupAppLocalizations(locale);

        await tester.pumpWidget(MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: false,
            scaffoldBackgroundColor: Colors.white,
          ),
          debugShowCheckedModeBanner: false,
          locale: locale,
          home: const ScreenshotMedicationsPage(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ));

        await tester.pumpAndSettle();
        // 画像読み込みに時間がかかる
        await tester.pumpAndSettle(const Duration(seconds: 3));
        await binding.convertFlutterSurfaceToImage();
        await tester.pumpAndSettle();
        await binding.takeScreenshot('artifacts/screenshots/screenshot_medications--${locale.languageCode}.png');
      });
    }
  });
}
