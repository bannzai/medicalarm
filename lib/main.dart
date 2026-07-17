import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/features/root/page.dart';
import 'package:medicalarm/l10n/app_localizations.dart';
import 'package:medicalarm/provider/shared_preferences.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/config/remote_config.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';
import 'package:medicalarm/utils/push_notification/fcm_notification.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    Intl.defaultLocale = 'ja';

    await (
      MobileAds.instance.initialize(),
      // emulator 接続時は本番プロジェクト(GoogleService-Info.plist)に触れないよう demo プロジェクト ID で初期化する。
      // demo-* プレフィックスは Firebase Emulator の完全オフラインモードで、非エミュレート API への到達を Emulator 側が遮断する。
      const bool.fromEnvironment('USE_FIREBASE_EMULATOR')
          ? Firebase.initializeApp(
              options: const FirebaseOptions(
                // FIRInstallations が API キーの形式(AIza 開頭 39 文字)を検証しクラッシュするため、形式だけ満たすダミー値にする
                apiKey: 'AIzaSyDUMMYKEYFORDEMOEMULATOR0123456789',
                appId: '1:123456789012:ios:1234567890abcdef',
                messagingSenderId: '123456789012',
                projectId: 'demo-medicalarm',
              ),
            )
          : Firebase.initializeApp(),
    ).wait;

    // ローカルの Firebase Emulator に接続する開発用ゲート。
    // `--dart-define=USE_FIREBASE_EMULATOR=true` を付けたビルドのみ有効で、デフォルト(未指定)では本番に接続する。
    // Cloud Functions は instanceFor(region:) が (app, region) 単位でインスタンスをキャッシュするため、
    // ここで接続したインスタンスは utils/functions/firebase_functions.dart のグローバル functions と同一で、そちらにも効く。
    if (const bool.fromEnvironment('USE_FIREBASE_EMULATOR')) {
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      FirebaseFunctions.instanceFor(region: 'asia-northeast1').useFunctionsEmulator('localhost', 5001);
    }
    FirebaseAuth.instance.setSettings(userAccessGroup: 'TQPN82UBBY.com.bannzai.medicalarm');

    // google_sign_in v7 は利用前に一度だけ initialize() が必要。
    // GoogleService-Info.plist の CLIENT_ID / GIDClientID 未設定の環境でもアプリ起動を妨げないよう握りつぶす
    // (Google リンク実行時に authenticate() 側で改めてエラー表示される)。
    try {
      await GoogleSignIn.instance.initialize();
    } catch (e) {
      debugPrint('GoogleSignIn.initialize failed: $e');
    }

    // フォアグラウンドでの FCM 受信(服薬記録 push 等)を SnackBar 表示するハンドラを起動する
    fcmNotificationHandler.initialize();

    // ignore: prefer_typing_uninitialized_variables
    final (_, sharedPreferences, _) = await (
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

    runApp(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
        // emulator 環境では RevenueCat の実キー(lib/secret/secret.dart)が無くても動かせるよう、
        // customerInfo に無課金状態の fake を流す。実キー無しだと customerInfo が永遠に emit されず
        // MedicationsPage(group2 で customerInfo を待つ)が表示できないため。
        if (const bool.fromEnvironment('USE_FIREBASE_EMULATOR'))
          customerInfoProvider.overrideWith(
            (ref) => Stream.value(CustomerInfo.fromJson({
              'entitlements': {'all': <String, dynamic>{}, 'active': <String, dynamic>{}, 'verification': 'FAILED'},
              'allPurchaseDates': <String, dynamic>{},
              'activeSubscriptions': <String>[],
              'allPurchasedProductIdentifiers': <String>[],
              'nonSubscriptionTransactions': <dynamic>[],
              'firstSeen': '2026-01-01T00:00:00Z',
              'originalAppUserId': 'emulator_user',
              'allExpirationDates': <String, dynamic>{},
              'requestDate': '2026-01-01T00:00:00Z',
            })),
          ),
      ],
      child: const App(),
    ));
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
      scaffoldMessengerKey: scaffoldMessengerKey,
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
        sliderTheme: const SliderThemeData(
          thumbColor: AppColors.primary,
          overlayColor: AppColors.primary,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
        ),
        useMaterial3: false,
      ),
      home: const RootPage(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
