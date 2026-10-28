import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/utils/local_notification/client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('dexterous.com/flutter/local_notifications');

  // OS の requestPermissions は通知全体の許可を返すため、通常の通知が許可済みなら Critical Alert を拒否しても true になる (#427)
  void mockPermissions({required bool isCriticalEnabled}) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'requestPermissions':
          return true;
        case 'checkPermissions':
          return {
            'isEnabled': true,
            'isAlertEnabled': true,
            'isBadgeEnabled': true,
            'isSoundEnabled': true,
            'isProvisionalEnabled': false,
            'isCriticalEnabled': isCriticalEnabled,
          };
      }
      return null;
    });
  }

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    FlutterLocalNotificationsPlatform.instance = IOSFlutterLocalNotificationsPlugin();
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('通知は許可済みで Critical Alert を拒否した時は false を返す', () async {
    mockPermissions(isCriticalEnabled: false);
    expect(await LocalNotificationService().requestPermissionWithCriticalAlert(), false);
  });

  test('Critical Alert を許可した時は true を返す', () async {
    mockPermissions(isCriticalEnabled: true);
    expect(await LocalNotificationService().requestPermissionWithCriticalAlert(), true);
  });
}
