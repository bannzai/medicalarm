import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/utils/firebase/app_check.dart';

/// ネイティブ SDK に渡るプロバイダと非同期初期化を検証する。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  final calls = <MethodCall>[];

  setUpAll(() async {
    await Firebase.initializeApp();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/firebase_app_check'),
      (call) async {
        if (call.method == 'FirebaseAppCheck#registerTokenListener') {
          return 'app-check-test-events';
        }
        calls.add(call);
        return null;
      },
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('app-check-test-events'),
      (call) async => null,
    );
  });

  setUp(calls.clear);

  test('デバッグビルドでは Apple と Android のデバッグプロバイダを使う', () async {
    await activateFirebaseAppCheck(isDebugMode: true);

    expect(calls.single.method, 'FirebaseAppCheck#activate');
    expect(calls.single.arguments, {
      'appName': '[DEFAULT]',
      'appleProvider': 'debug',
      'androidProvider': 'debug',
    });
  });

  test('本番と profile では端末認証を使い、再設定しても設定は変わらない', () async {
    await activateFirebaseAppCheck(isDebugMode: false);
    await activateFirebaseAppCheck(isDebugMode: false);

    expect(calls, hasLength(2));
    for (final call in calls) {
      expect(call.method, 'FirebaseAppCheck#activate');
      expect(call.arguments, {
        'appName': '[DEFAULT]',
        'appleProvider': 'appAttestWithDeviceCheckFallback',
        'androidProvider': 'playIntegrity',
      });
    }
  });
}
