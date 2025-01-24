import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/root/page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/config/remote_config.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await (
      MobileAds.instance.initialize(),
      Firebase.initializeApp(),
    ).wait;

    // ignore: prefer_typing_uninitialized_variables
    final (_, _, _) = await (
      LocalNotificationService.setupTimeZone(),
      SharedPreferences.getInstance(),
      setupRemoteConfig(),
    ).wait;

    // AppLocalizationsの初期化を待つ
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await localNotificationService.initialize();
    });

    // MEMO: FirebaseCrashlytics#recordFlutterError called dumpErrorToConsole in function.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(const ProviderScope(child: App()));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
    );

    return MaterialApp(
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
      home: const RootPage(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
