import 'dart:async';

import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medications/entity/grouped.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/analytics/error.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:riverpod/riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

// Reminder Notification
const actionIdentifier = 'RECORD_PILL';
const iOSQuickRecordPillCategoryIdentifier = 'PILL_REMINDER';

// Notification ID offset
const fallbackNotificationIdentifier = 1;
const newPillSheetNotificationIdentifier = 2;
const scheduleNotificationIdentifierOffset = 100000;
const reminderNotificationIdentifierOffset = 1000000000;

// NOTE: It can not be use Future.wait(processes) when register notification.
class LocalNotificationService {
  final plugin = FlutterLocalNotificationsPlugin();

  static Future<void> setupTimeZone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));
  }

  Future<void> initialize() async {
    // NOTE: iOSではやっていることが、UNUserNotificationCenter.current().requestAuthorization(options: options)である。なので何度読んでも良い
    await plugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(
          // Alertはdeprecatedなので、banner,listをtrueにしておけばよい。
          // https://developer.apple.com/documentation/usernotifications/unnotificationpresentationoptions/unnotificationpresentationoptionalert
          defaultPresentAlert: false,
          defaultPresentBadge: true,
          defaultPresentSound: true,
          defaultPresentBanner: true,
          defaultPresentList: true,
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          requestProvisionalPermission: false,
          requestCriticalPermission: false,
        ),
      ),
    );
  }

  Future<void> requestPermission() async {
    plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(sound: true, badge: true, alert: true, provisional: true);
  }

  Future<bool?> requestPermissionWithCriticalAlert() async {
    return await plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(sound: true, badge: true, alert: true, provisional: true, critical: true);
  }

  // iOSでは 以下の二つを実行しているだけなので今のところエラーは発生しない
  // center.removePendingNotificationRequests(withIdentifiers: ids), center.removeDeliveredNotifications(withIdentifiers: ids)
  Future<void> cancelNotification({required int localNotificationID}) async {
    await plugin.cancel(localNotificationID);
  }

  Future<void> test() async {
    await plugin.zonedSchedule(
      Random().nextInt(1000000),
      'test title',
      'test body',
      tz.TZDateTime.from(now().add(const Duration(minutes: 1)), tz.local),
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // iOSではgetPendingNotificationRequestsWithCompletionHandlerを実行しているだけなのでおそらくエラーは発生しない
  Future<List<PendingNotificationRequest>> pendingReminderNotifications() async {
    final pendingNotifications = await plugin.pendingNotificationRequests();
    return pendingNotifications.where((element) => element.id - reminderNotificationIdentifierOffset > 0).toList();
  }

  // iOSではgetPendingNotificationRequestsWithCompletionHandlerを実行しているだけなのでおそらくエラーは発生しない
  Future<List<PendingNotificationRequest>> pendingNewPillSheetNotifications() async {
    final pendingNotifications = await plugin.pendingNotificationRequests();
    return pendingNotifications.where((element) => element.id == newPillSheetNotificationIdentifier).toList();
  }
}

// 必要な状態が全て揃ったら(AsyncData)の時のみ値を返す。そうじゃない場合はnullを返す
final registerReminderLocalNotificationProvider = Provider(
  (ref) => RegisterReminderLocalNotification(ref),
);

// Reminder
// 最新の状態を元に更新すれば良いので、更新処理に必要な状態はプロパティで持つ。このプロパティは通常ref.watchにより常に最新に保たれる
// また、状態をcallの引数として受け取らないことで通常はSingle Stateであるものに対して間違った値を受け取れないようにする
// 以下のように行わずに、手続的に必要な箇所でcallを呼ぶ。なぜなら不意にローカル通知の解除や登録が走ってしまうのはアンコントローラブルだから
// - 各アクションと並行して処理を行わない
// - アクションの結果を受け取ってローカル通知の登録の更新をしない
// - 変更を検知してcallを呼ぶ親Widgetを用意して、変更があれば毎回登録しなおす → クイックレコードの場合なども考慮に入れる必要がある。それらの処理でWidgetが起動しているかどうか定かでは無いのでやらない
// NOTE:
// 現状はテストケースが増えること以外は問題点では無いのでこの方式で行くが、他の方法としてiOSはNotification Service App Extensionを使用した方法がある(Silence Push Notifications)
// Doc: https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_usernotifications_filtering#3737535
// Androidの方では元々Kotlinの方で通知のイベントを受け取り出す内容を分けていたので多分同様のことができる(よく調べてない)
// iOSのSilence Push NotificationsやAndroidのKotlin側で受け取り出す方法を使う利点と使わない利点をメモする
// 利点:
// * その時点の状態を元に通知のコンテンツを決定する。という方式を取るためLocal Notificationのスケジュールがシンプルに「毎日 9:00に通知」となる。受け取った通知を元にSwift/Kotlinの方で出すコンテンツを分ける(非表示にもできる)
// * その時点の状態を元に通知のコンテンツを決定する。という方式を取るため、現状の「特定のLocal Notificationに対する変更があった場合にLocal Notificationを更新する」と言ったことを考えなくて良い
// * その時点の状態を元に通知のコンテンツを決定する。という方式を取るため、テストケースがシンプルになる
// 難しい点:
// * Swift/Kotlinのコードが増える。なのでライブリロードも効きづらい
// * iOSのApp Extensionでは別途申請が必要になる。これ自体も手間だが、dev版アプリの審査も通す必要があるのが(手間が2回発生するのを避けてる。やればいいだけ)
//   * Thank you for your interest in the Notification Service Extension Filtering entitlement. This entitlement is intended for certain types of apps — such as messaging apps or location sharing apps — that use notification service extensions to receive push notifications without delivering notifications to the user. If your app needs this entitlement in order to properly function on iOS 13.3 or later, provide the following information.
//   * やれば良いだけだと思ったが、App Store URL等を入力しないとダメだからdev版のアプリ通らない可能性が高い
//   * 追記: そもそもリモートの通知でしかこれは使えないかも: This entitlement allows a notification service extension to receive remote notifications without displaying the notification to the user. To apply for this entitlement, see Request Notification Service Entitlement.
class RegisterReminderLocalNotification {
  final Ref ref;

  RegisterReminderLocalNotification(this.ref);

  static const int registerDays = 5;

  // UseCase:
  // - 薬を追加
  // - 薬を編集
  // - 薬を削除
  // - 服用記録
  // - 服用キャンセル
  // - TODO: クイックレコード
  // - TODO: 通知の文言を変えた時
  // NOTE: 本日分の服用記録がある場合は、本日分の通知はスケジュールしないようになっている
  // 5日間分の通知をスケジュールする
  // 64個までのリミットがあるため
  //   * `There is a limit imposed by iOS where it will only keep 64 notifications that will fire the soonest.`
  //   * ref: https://pub.dev/packages/flutter_local_notifications#-caveats-and-limitations
  Future<void> call() async {
    analytics.debug(name: 'call_register_reminder_notification');
    final cancelReminderLocalNotification = CancelReminderLocalNotification();
    // エンティティの変更があった場合にref.readで最新の状態を取得するために、Future.microtaskで更新を待ってから処理を始める
    // hour,minute を基準にIDを決定しているので、時間変更や番号変更時にそれまで登録されていたIDを特定するのが不可能なので全てキャンセルする
    await (Future.microtask(() => null), cancelReminderLocalNotification()).wait;
    analytics.debug(name: 'cancel_reminder_notification');

    final medicines = ref.read(activeMedicinesProvider).asData?.valueOrNull;
    final medicationHistories = ref.read(medicationHistoriesByDateProvider(today())).asData?.valueOrNull;
    if (medicines == null || medicationHistories == null) {
      return;
    }

    await run(
      medicines: medicines,
      medicationHistories: medicationHistories,
      loopCount: 0,
    );
  }

  // TODO: badgeNumber 対応。Pilllを参考に
  static Future<void> run({
    required List<Medicine> medicines,
    required List<MedicationHistory> medicationHistories,
    // NOTE: [LocalNotificationReminder] 例えば frequency が cycleで、consecutiveDaysよりも後ろで、restDaysの期間にいる場合の再評価が必要になる
    // ループをいっぱい回してfuturesが空にならない場合までを採用する。上限をloopCount==10としている
    required int loopCount,
  }) async {
    if (loopCount > 10) {
      return;
    }

    final List<Future<void>> futures = [];
    final tzNow = tz.TZDateTime.now(tz.local);

    final offset = loopCount * registerDays;
    for (final dayOffset in List.generate(offset, (index) => index)) {
      final date = tzNow.date().addDays(dayOffset);
      final groupedValues = medicationGroups(
        medicines: medicines,
        medicationHistories: medicationHistories,
        date: date,
      );

      for (final (groupIndex, group) in groupedValues.indexed) {
        analytics.debug(name: 'run_register_reminder_notification', parameters: {
          'groupIndex': groupIndex,
          'groupID': group.id,
        });

        // すでに日毎のrowsに服用記録がついている場合はスキップ
        final isTakenAll = group.scheduleRows.every((element) => element.medicationHistory != null);
        if (isTakenAll) {
          continue;
        }

        // 本日服用予定だった、過去のスケジュールはスキップする
        final isPast = group.scheduleTime.hour < tzNow.hour || (group.scheduleTime.hour == tzNow.hour && group.scheduleTime.minute < tzNow.minute);
        if (dayOffset == 0 && isPast) {
          analytics.debug(name: 'rrrn_skip_past_schedule', parameters: {
            'dayOffset': dayOffset,
            'scheduleTimeHour': group.scheduleTime.hour,
            'scheduleTimeMinute': group.scheduleTime.minute,
            'tzNowHour': tzNow.hour,
            'tzNowMinute': tzNow.minute,
          });
          continue;
        }

        final reminderDateTime = date.add(Duration(hours: group.scheduleTime.hour)).add(Duration(minutes: group.scheduleTime.minute));
        if (reminderDateTime.isBefore(tzNow)) {
          analytics.debug(name: 'rrrn_is_before_now', parameters: {
            'dayOffset': dayOffset,
            'tzNow': tzNow,
            'reminderDateTime': reminderDateTime,
            'scheduleHour': group.scheduleTime.hour,
            'scheduleMinute': group.scheduleTime.minute,
          });
          continue;
        }

        // IDの計算には本来のピル番号を使用する。表示用の番号だと今後も設定によりズレる可能性があるため
        // また、_calcLocalNotificationIDの中で、本来のピル番号を使用していることを前提としている(2桁までを想定している)
        final reminderEnabledScheduleRows = group.scheduleRows.where((element) => element.medicationSchedule.notificationSetting.isReminderEnabled);
        if (reminderEnabledScheduleRows.isNotEmpty) {
          var message = '';
          for (final scheduleRow in reminderEnabledScheduleRows) {
            message += '${scheduleRow.medicine.name} ${scheduleRow.medicine.doseReceiver.name} ${scheduleRow.quantityMemo}\n';
          }
          final notificationID = _calcLocalNotificationID(
            groupIndex: groupIndex,
            scheduleTime: group.scheduleTime,
            kind: 1,
          );

          futures.add(
            Future(() async {
              try {
                await localNotificationService.plugin.zonedSchedule(
                  notificationID,
                  'お薬の時間です',
                  message,
                  reminderDateTime.add(const Duration(minutes: 30)),
                  NotificationDetails(
                    iOS: DarwinNotificationDetails(
                      presentBadge: true,
                      presentSound: true,
                      // Alertはdeprecatedなので、banner,listをtrueにしておけばよい。
                      // https://developer.apple.com/documentation/usernotifications/unnotificationpresentationoptions/unnotificationpresentationoptionalert
                      presentAlert: false,
                      presentBanner: true,
                      presentList: true,
                      interruptionLevel: InterruptionLevel.critical,
                      badgeNumber: dayOffset,
                    ),
                  ),
                  uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
                );

                analytics.debug(name: 'rrrn_followup', parameters: {
                  'dayOffset': dayOffset,
                  'notificationID': notificationID,
                  'scheduleTimeHour': group.scheduleTime.hour,
                  'scheduleTimeMinute': group.scheduleTime.minute,
                });
              } catch (e, st) {
                // NOTE: エラーが発生しても他の通知のスケジュールを続ける
                errorLogger.recordError(e, st);

                analytics.debug(name: 'rrrn_e_reminder', parameters: {
                  'dayOffset': dayOffset,
                  'notificationID': notificationID,
                  'scheduleTimeHour': group.scheduleTime.hour,
                  'scheduleTimeMinute': group.scheduleTime.minute,
                });
              }
            }),
          );
        }

        final followUpEnabledScheduleRows = group.scheduleRows.where((element) => element.medicationSchedule.notificationSetting.isFollowupEnabled);
        if (followUpEnabledScheduleRows.isNotEmpty) {
          var message = '';
          for (final scheduleRow in followUpEnabledScheduleRows) {
            message += '${scheduleRow.medicine.name} ${scheduleRow.medicine.doseReceiver.name} ${scheduleRow.quantityMemo}\n';
          }
          final notificationID = _calcLocalNotificationID(
            groupIndex: groupIndex,
            scheduleTime: group.scheduleTime,
            kind: 2,
          );

          futures.add(
            Future(() async {
              try {
                await localNotificationService.plugin.zonedSchedule(
                  notificationID,
                  'お薬の時間から30分過ぎているようです',
                  message,
                  reminderDateTime,
                  NotificationDetails(
                    iOS: DarwinNotificationDetails(
                      presentBadge: true,
                      presentSound: true,
                      // Alertはdeprecatedなので、banner,listをtrueにしておけばよい。
                      // https://developer.apple.com/documentation/usernotifications/unnotificationpresentationoptions/unnotificationpresentationoptionalert
                      presentAlert: false,
                      presentBanner: true,
                      presentList: true,
                      interruptionLevel: InterruptionLevel.critical,
                      badgeNumber: dayOffset,
                    ),
                  ),
                  uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
                );

                analytics.debug(name: 'rrrn_non_premium', parameters: {
                  'dayOffset': dayOffset,
                  'notificationID': notificationID,
                  'scheduleTimeHour': group.scheduleTime.hour,
                  'scheduleTimeMinute': group.scheduleTime.minute,
                });
              } catch (e, st) {
                // NOTE: エラーが発生しても他の通知のスケジュールを続ける
                errorLogger.recordError(e, st);

                analytics.debug(name: 'rrrn_e_non_premium', parameters: {
                  'dayOffset': dayOffset,
                  'notificationID': notificationID,
                  'scheduleTimeHour': group.scheduleTime.hour,
                  'scheduleTimeMinute': group.scheduleTime.minute,
                });
              }
            }),
          );
        }
      }
    }

    if (futures.isEmpty) {
      // NOTE: [LocalNotificationReminder] 例えば frequency が cycleで、consecutiveDaysよりも後ろで、restDaysの期間にいる場合の再評価が必要になる
      run(medicines: medicines, medicationHistories: medicationHistories, loopCount: loopCount + 1);
      return;
    }
    analytics.debug(name: 'rrrn_e_before_run', parameters: {
      'notificationCount': futures.length,
    });

    await Future.wait(futures);

    analytics.debug(name: 'rrrn_e_end_run', parameters: {
      'notificationCount': futures.length,
    });
  }

  // reminder time id is 10{groupIndex:2}{hour:2}{minute:2}{pillNumberInPillSheet:2}
  // for example return value 1002223014 means,  `10` is prefix, gropuIndex: `02` is third pillSheet,`22` is hour, `30` is minute, `14` is pill number into pill sheet
  // 1000000000 = reminderNotificationIdentifierOffset
  //   10000000 = groupIndex
  //     100000 = scheduleTime.hour
  //       1000 = scheduleTime.minute
  //         10 = kind: 1 reminder, kind: 2 followup
  static int _calcLocalNotificationID({
    required int groupIndex,
    required MedicationGroupScheduleTime scheduleTime,
    required int kind,
  }) {
    final groupIndexNumber = (groupIndex + 1) * 10000000;
    final hour = scheduleTime.hour * 100000;
    final minute = scheduleTime.minute * 1000;
    final kindNumber = kind * 10;
    return reminderNotificationIdentifierOffset + groupIndexNumber + hour + minute + kindNumber;
  }
}

final cancelReminderLocalNotificationProvider = Provider((ref) => CancelReminderLocalNotification());

class CancelReminderLocalNotification {
  // Usecase
  // - 服用お休み開始
  // - ピルシートグループを削除された時
  // - 通知をOFFにした時
  // - 退会
  // これら以外はRegisterReminderLocalNotificationで登録し直す。なおRegisterReminderLocalNotification の内部でこの関数を読んでいる
  Future<void> call() async {
    final pendingNotifications = await localNotificationService.pendingReminderNotifications();
    analytics.debug(name: 'cancel_reminder_local_notification', parameters: {
      'length': pendingNotifications.length,
      'ids': pendingNotifications.map((e) => e.id).toList().toString(),
    });
    await Future.wait(pendingNotifications.map((p) => localNotificationService.cancelNotification(localNotificationID: p.id)));
  }
}

var localNotificationService = LocalNotificationService();
