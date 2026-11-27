import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/focus_connect/section.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../../support/app_links.dart';
import '../../../support/url_launcher.dart';

void main() {
  const medicationSchedule = MedicationSchedule(
    id: 'schedule-1',
    hour: 9,
    minute: 0,
    quantityMemo: '',
    notificationSetting: MedicineScheduleNotificationSetting(isReminderEnabled: true, isFollowupEnabled: false, useCriticalAlert: false),
    focusConnectSetting: null,
  );

  late void Function(String uri) openAppLink;
  late RecordingUrlLauncherPlatform urlLauncherPlatform;

  setUp(() {
    openAppLink = mockAppLinksEventChannel();
    final originalUrlLauncherPlatform = UrlLauncherPlatform.instance;
    urlLauncherPlatform = RecordingUrlLauncherPlatform();
    UrlLauncherPlatform.instance = urlLauncherPlatform;
    addTearDown(() => UrlLauncherPlatform.instance = originalUrlLauncherPlatform);
  });

  /// 通知設定の画面の Focus Connect の項目を描き、タップして Focus を開いた URL から authCode を返す。
  /// [focusConnectScheduleID] は連携の ID の状態で、戻りを受けた結果がここに入る
  Future<String?> pumpSectionAndOpenFocus(WidgetTester tester, {required ValueNotifier<String?> focusConnectScheduleID}) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: MedicineScheduleFocusConnectSettingSection(schedule: medicationSchedule, focusConnectScheduleID: focusConnectScheduleID),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();
    return Uri.parse(urlLauncherPlatform.launchedURLs.single).queryParameters['authCode'];
  }

  /// アプリが [uri] で開かれた時と同じく戻りを届け、画面の処理を終えるまで進める。
  /// EventChannel のメッセージは fake async の pump だけでは届かないため、実時間を少し進める
  Future<void> openAppLinkAndSettle(WidgetTester tester, String uri) async {
    openAppLink(uri);
    // 届くまでに要るのはイベントループの数回分で、余裕を見て 50ms 待つ
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();
  }

  testWidgets('連携が作られた戻り (connected=true) で、返った ID を入れる', (tester) async {
    final focusConnectScheduleID = ValueNotifier<String?>(null);
    final authCode = await pumpSectionAndOpenFocus(tester, focusConnectScheduleID: focusConnectScheduleID);

    await openAppLinkAndSettle(
      tester,
      'medicalarm:///focus-connect/schedule?connected=true&authCode=$authCode&focusConnectScheduleID=focus-schedule-1',
    );

    expect(focusConnectScheduleID.value, 'focus-schedule-1');
  });

  testWidgets('削除の完了の戻り (connected=false) で ID を消す', (tester) async {
    final focusConnectScheduleID = ValueNotifier<String?>('focus-schedule-1');
    final authCode = await pumpSectionAndOpenFocus(tester, focusConnectScheduleID: focusConnectScheduleID);

    await openAppLinkAndSettle(
      tester,
      'medicalarm:///focus-connect/schedule?connected=false&authCode=$authCode&focusConnectScheduleID=focus-schedule-1',
    );

    expect(focusConnectScheduleID.value, isNull);
  });

  testWidgets('上限に達した戻り (reason=limit-reached) では ID を変えない', (tester) async {
    final focusConnectScheduleID = ValueNotifier<String?>('focus-schedule-1');
    final authCode = await pumpSectionAndOpenFocus(tester, focusConnectScheduleID: focusConnectScheduleID);

    await openAppLinkAndSettle(tester, 'medicalarm:///focus-connect/schedule?connected=false&reason=limit-reached&authCode=$authCode');

    expect(focusConnectScheduleID.value, 'focus-schedule-1');
  });

  testWidgets('authCode が一致しない戻りでは ID を変えない', (tester) async {
    final focusConnectScheduleID = ValueNotifier<String?>('focus-schedule-1');
    await pumpSectionAndOpenFocus(tester, focusConnectScheduleID: focusConnectScheduleID);

    await openAppLinkAndSettle(tester, 'medicalarm:///focus-connect/schedule?connected=false&authCode=other&focusConnectScheduleID=focus-schedule-1');

    expect(focusConnectScheduleID.value, 'focus-schedule-1');
  });

  testWidgets('画面を閉じた後に届いた戻りでは ID を変えない (購読を解除している)', (tester) async {
    final focusConnectScheduleID = ValueNotifier<String?>('focus-schedule-1');
    final authCode = await pumpSectionAndOpenFocus(tester, focusConnectScheduleID: focusConnectScheduleID);

    await tester.pumpWidget(const SizedBox());
    await openAppLinkAndSettle(
      tester,
      'medicalarm:///focus-connect/schedule?connected=false&authCode=$authCode&focusConnectScheduleID=focus-schedule-1',
    );

    expect(focusConnectScheduleID.value, 'focus-schedule-1');
  });
}
