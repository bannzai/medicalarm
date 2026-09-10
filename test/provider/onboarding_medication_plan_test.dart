import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/onboarding_medication_plan.dart';
import 'package:medicalarm/provider/onboarding_medication_plan.dart';
import 'package:medicalarm/provider/shared_preferences.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;

/// OS 通知の登録完了を制御し、削除との競合を再現する。
class _NotificationService extends LocalNotificationService {
  /// 現在 OS に登録された仮設定。
  OnboardingMedicationPlan? registeredPlan;

  /// 通知登録処理が開始されたことを知らせる。
  Completer<void>? registrationStarted;

  /// 通知登録を保留するための制御点。
  Completer<void>? registrationRelease;

  @override
  Future<void> cancelOnboardingMedicationPlanNotifications() async {
    registeredPlan = null;
  }

  @override
  Future<void> registerOnboardingMedicationPlanNotifications({required OnboardingMedicationPlan plan}) async {
    registrationStarted?.complete();
    await registrationRelease?.future;
    registeredPlan = plan;
  }
}

/// 保存・アカウント境界・通知の非同期競合を検証する。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences preferences;
  late ProviderContainer container;
  late _NotificationService notificationService;
  late LocalNotificationService originalNotificationService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    originalNotificationService = localNotificationService;
    notificationService = _NotificationService();
    localNotificationService = notificationService;
    await cancelOnboardingMedicationPlanNotifications();
    container = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(preferences)]);
  });

  tearDown(() async {
    await cancelOnboardingMedicationPlanNotifications();
    container.dispose();
    localNotificationService = originalNotificationService;
  });

  for (final (count, hours) in [
    (1, [8]),
    (2, [8, 19]),
    (3, [8, 12, 19])
  ]) {
    test('$count 回の時刻を保存し通常通知だけを設定する', () async {
      final provider = onboardingMedicationPlanStoreProvider(userID: 'user-a', groupID: 'group-a');
      final plan = await container.read(provider.notifier).create(dailyDoseCount: count, hasMedicines: false);
      expect(plan!.schedules.map((schedule) => schedule.hour), hours);
      expect(plan.schedules.every((schedule) => schedule.minute == 0), isTrue);
      expect(plan.schedules.every((schedule) => !schedule.notificationSetting.useCriticalAlert && !schedule.notificationSetting.useAlarmKit), isTrue);
      expect(plan.schedules.every((schedule) => schedule.notificationSetting.criticalAlertVolume == 0.5), isTrue);
      expect(plan.doseReceiverID, DoseReceiver.firstUserID);
      expect(notificationService.registeredPlan, plan);
      final restoredContainer = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(preferences)]);
      addTearDown(restoredContainer.dispose);
      expect(restoredContainer.read(provider), plan);
      expect(OnboardingMedicationPlan.fromJson(plan.toJson()), plan);
      expect((await container.read(provider.notifier).create(dailyDoseCount: count, hasMedicines: false))!.createdDateTime, plan.createdDateTime);
    });
  }

  test('薬が登録されたら永続データと通知を削除し再起動後も復活しない', () async {
    final provider = onboardingMedicationPlanStoreProvider(userID: 'user-a', groupID: 'group-a');
    await container.read(provider.notifier).create(dailyDoseCount: 2, hasMedicines: false);
    await container.read(provider.notifier).synchronizeNotifications(hasMedicines: true);
    expect(container.read(provider), isNull);
    expect(notificationService.registeredPlan, isNull);
    expect(preferences.getKeys(), isEmpty);
    expect(await container.read(provider.notifier).create(dailyDoseCount: 2, hasMedicines: true), isNull);
  });

  test('1枚を削除すると他の時刻と通知が残り再起動後も2枚を復元する', () async {
    final provider = onboardingMedicationPlanStoreProvider(userID: 'user-a', groupID: 'group-a');
    await container.read(provider.notifier).create(dailyDoseCount: 3, hasMedicines: false);
    await container.read(provider.notifier).removeSchedule(scheduleID: 'onboarding-12');
    expect(container.read(provider)!.schedules.map((schedule) => schedule.hour), [8, 19]);
    expect(notificationService.registeredPlan!.schedules.map((schedule) => schedule.hour), [8, 19]);
    final restoredContainer = ProviderContainer(overrides: [sharedPreferencesProvider.overrideWithValue(preferences)]);
    addTearDown(restoredContainer.dispose);
    expect(restoredContainer.read(provider), container.read(provider));
  });

  test('時刻を連続削除すると最後の1枚の削除で永続データと通知が空になる', () async {
    final provider = onboardingMedicationPlanStoreProvider(userID: 'user-a', groupID: 'group-a');
    await container.read(provider.notifier).create(dailyDoseCount: 2, hasMedicines: false);
    await Future.wait([
      container.read(provider.notifier).removeSchedule(scheduleID: 'onboarding-8'),
      container.read(provider.notifier).removeSchedule(scheduleID: 'onboarding-19'),
    ]);
    expect(container.read(provider), isNull);
    expect(notificationService.registeredPlan, isNull);
    expect(preferences.getKeys(), isEmpty);
  });

  test('別グループの時刻を削除しても現在のグループの通知は保持する', () async {
    final first = onboardingMedicationPlanStoreProvider(userID: 'user-a', groupID: 'group-a');
    final second = onboardingMedicationPlanStoreProvider(userID: 'user-a', groupID: 'group-b');
    await container.read(first.notifier).create(dailyDoseCount: 3, hasMedicines: false);
    await container.read(second.notifier).create(dailyDoseCount: 1, hasMedicines: false);
    await container.read(first.notifier).removeSchedule(scheduleID: 'onboarding-12');
    expect(container.read(first)!.schedules.map((schedule) => schedule.hour), [8, 19]);
    expect(notificationService.registeredPlan, container.read(second));
  });

  test('別ユーザーと別グループでは設定を共有せず古いグループの削除は現在の通知に触れない', () async {
    final first = onboardingMedicationPlanStoreProvider(userID: 'user-a', groupID: 'group-a');
    final second = onboardingMedicationPlanStoreProvider(userID: 'user-a', groupID: 'group-b');
    final third = onboardingMedicationPlanStoreProvider(userID: 'user-b', groupID: 'group-a');
    await container.read(first.notifier).create(dailyDoseCount: 1, hasMedicines: false);
    expect(container.read(second), isNull);
    expect(container.read(third), isNull);
    await container.read(second.notifier).create(dailyDoseCount: 2, hasMedicines: false);
    await container.read(first.notifier).remove();
    expect(notificationService.registeredPlan, container.read(second));
  });

  test('通知の登録処理中に削除しても登録完了後に解除される', () async {
    final provider = onboardingMedicationPlanStoreProvider(userID: 'user-a', groupID: 'group-a');
    notificationService.registrationStarted = Completer<void>();
    notificationService.registrationRelease = Completer<void>();
    final creation = container.read(provider.notifier).create(dailyDoseCount: 1, hasMedicines: false);
    await notificationService.registrationStarted!.future;
    final removal = container.read(provider.notifier).remove();
    notificationService.registrationRelease!.complete();
    await Future.wait([creation, removal]);
    expect(notificationService.registeredPlan, isNull);
    expect(container.read(provider), isNull);
  });

  test('作成直後のログアウトで遅延登録されず保存済みの設定だけが残る', () async {
    final provider = onboardingMedicationPlanStoreProvider(userID: 'user-a', groupID: 'group-a');
    await Future.wait([
      container.read(provider.notifier).create(dailyDoseCount: 1, hasMedicines: false),
      cancelOnboardingMedicationPlanNotifications(),
    ]);
    expect(notificationService.registeredPlan, isNull);
    expect(container.read(provider), isNotNull);
  });

  test('削除と再作成を連続で呼ぶと最後の設定の通知が残る', () async {
    final provider = onboardingMedicationPlanStoreProvider(userID: 'user-a', groupID: 'group-a');
    await container.read(provider.notifier).create(dailyDoseCount: 1, hasMedicines: false);
    await Future.wait([
      container.read(provider.notifier).remove(),
      container.read(provider.notifier).create(dailyDoseCount: 3, hasMedicines: false),
    ]);
    expect(notificationService.registeredPlan!.schedules.length, 3);
    expect(container.read(provider)!.schedules.length, 3);
  });

  test('iOSには毎日繰り返す通常通知を送り既存服薬通知の取消対象から除外する', () async {
    final calls = <MethodCall>[];
    const channel = MethodChannel('dexterous.com/flutter/local_notifications');
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() {
      debugDefaultTargetPlatformOverride = null;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
    });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      if (call.method == 'pendingNotificationRequests') {
        return [
          {'id': onboardingMedicationPlanNotificationIDs.first, 'title': '', 'body': '', 'payload': ''},
          {'id': reminderNotificationIdentifierOffset + 1, 'title': '', 'body': '', 'payload': ''},
        ];
      }
      return true;
    });
    tz_data.initializeTimeZones();
    IOSFlutterLocalNotificationsPlugin.registerWith();
    final service = LocalNotificationService();
    await service.initialize();
    final plan = await container
        .read(onboardingMedicationPlanStoreProvider(userID: 'user-a', groupID: 'group-a').notifier)
        .create(dailyDoseCount: 3, hasMedicines: false);
    await service.registerOnboardingMedicationPlanNotifications(plan: plan!);
    expect(calls.where((call) => call.method == 'zonedSchedule').length, 3);
    for (final call in calls.where((call) => call.method == 'zonedSchedule')) {
      expect(call.arguments['matchDateTimeComponents'], DateTimeComponents.time.index);
      expect(call.arguments['platformSpecifics']['interruptionLevel'], InterruptionLevel.active.index);
      expect(call.arguments['platformSpecifics']['categoryIdentifier'], isNull);
      expect(call.arguments['payload'], isEmpty);
    }
    expect((await service.pendingReminderNotifications()).map((notification) => notification.id), [reminderNotificationIdentifierOffset + 1]);
    await service.cancelOnboardingMedicationPlanNotifications();
    expect(calls.where((call) => call.method == 'cancel').map((call) => call.arguments), onboardingMedicationPlanNotificationIDs);
  });
}
