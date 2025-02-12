import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/shared_preferences.dart';
import 'package:medicalarm/style/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lib/screenshot/screenshot_medications.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    final locales = AppLocalizations.supportedLocales;
    for (final locale in locales) {
      testWidgets('screenshot medications $locale', (tester) async {
        final sharedPreferences = await SharedPreferences.getInstance();
        L = lookupAppLocalizations(locale);

        final colorScheme = ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        );
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
            ],
            child: MaterialApp(
              theme: ThemeData(
                colorScheme: colorScheme,
                dividerColor: Colors.black,
                bottomSheetTheme: const BottomSheetThemeData(
                  backgroundColor: AppColors.formBackground,
                ),
                textSelectionTheme: const TextSelectionThemeData(
                  cursorColor: AppColors.primary,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                ),
                appBarTheme: const AppBarTheme(
                  elevation: 1,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    minimumSize: const Size(double.infinity, 48.0),
                    textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    disabledBackgroundColor: AppColors.disabled,
                  ),
                ),
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  extendedTextStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                outlinedButtonTheme: OutlinedButtonThemeData(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(),
                  ),
                ),
                useMaterial3: false,
              ),
              debugShowCheckedModeBanner: false,
              locale: locale,
              home: const ScreenshotMedicationsPage(),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );

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
