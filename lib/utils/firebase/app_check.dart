import 'package:firebase_app_check/firebase_app_check.dart';

/// 初期化済みの Firebase アプリに、ビルド種別に応じた端末認証を設定する。
Future<void> activateFirebaseAppCheck({required bool isDebugMode}) async {
  await FirebaseAppCheck.instance.activate(
    // Simulator での検証を可能にし、本番では App Attest 非対応端末も認証するため。
    appleProvider: isDebugMode ? AppleProvider.debug : AppleProvider.appAttestWithDeviceCheckFallback,
    androidProvider: isDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
  );
}
