import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/utils/firebase/app_check.dart';

/// ネイティブ SDK に渡るプロバイダと非同期初期化を検証する。
/// firebase_app_check 0.4.8 はネイティブ呼び出しが pigeon の BasicMessageChannel になり、
/// activate の引数は [appName, androidProvider, appleProvider, debugToken, recaptchaSiteKey] の配列で届く。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  final activateCalls = <List<Object?>>[];
  const pigeonChannelPrefix = 'dev.flutter.pigeon.firebase_app_check_platform_interface.FirebaseAppCheckHostApi';
  // activate の引数は文字列と null だけなので、pigeon 専用 codec の拡張 (int・トークン結果) を使わず標準の codec で読める
  const activateChannel = BasicMessageChannel<Object?>('$pigeonChannelPrefix.activate', StandardMessageCodec());
  const registerTokenListenerChannel = BasicMessageChannel<Object?>('$pigeonChannelPrefix.registerTokenListener', StandardMessageCodec());

  setUpAll(() async {
    await Firebase.initializeApp();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(activateChannel, (message) async {
      activateCalls.add((message! as List<Object?>));
      // pigeon の void の返り値は [null] の配列
      return <Object?>[null];
    });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(registerTokenListenerChannel,
        (message) async {
      return <Object?>['app-check-test-events'];
    });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('app-check-test-events'),
      (call) async => null,
    );
  });

  setUp(activateCalls.clear);

  test('デバッグビルドでは Apple と Android のデバッグプロバイダを使う', () async {
    await activateFirebaseAppCheck(isDebugMode: true);

    // テストは kDebugMode のため Android と Apple の両方のプロバイダが渡る。debug token と reCAPTCHA の site key は使わない
    expect(activateCalls.single, ['[DEFAULT]', 'debug', 'debug', null, null]);
  });

  test('本番と profile では端末認証を使い、再設定しても設定は変わらない', () async {
    await activateFirebaseAppCheck(isDebugMode: false);
    await activateFirebaseAppCheck(isDebugMode: false);

    expect(activateCalls, hasLength(2));
    for (final arguments in activateCalls) {
      expect(arguments, ['[DEFAULT]', 'playIntegrity', 'appAttestWithDeviceCheckFallback', null, null]);
    }
  });
}
