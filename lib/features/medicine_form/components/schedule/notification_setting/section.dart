import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_form/components/section_layout.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:medicalarm/utils/alarm_kit_service.dart';

class MedicineScheduleNotificationSettingSection extends HookConsumerWidget {
  final ValueNotifier<bool> isReminderEnabled;
  final ValueNotifier<bool> isFollowupEnabled;
  final ValueNotifier<bool> useCriticalAlert;
  final ValueNotifier<double> criticalAlertVolume;
  final ValueNotifier<bool> useAlarmKit;

  const MedicineScheduleNotificationSettingSection({
    super.key,
    required this.isReminderEnabled,
    required this.isFollowupEnabled,
    required this.useCriticalAlert,
    required this.criticalAlertVolume,
    required this.useAlarmKit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 親Componentで値の変化を監視しているので、UIが重くなるので、Internal stateを用意する
    final criticalAlertVolume = useState(this.criticalAlertVolume.value);
    final isAlarmKitAvailable = useFuture(AlarmKitService.isAvailable());

    return MedicineFormSectionLayout(
      icon: Icons.notifications,
      text: L.notificationSetting,
      children: [
        SwitchListTile(
          value: isReminderEnabled.value,
          onChanged: (value) {
            analytics.logEvent(name: 'med_sched_reminder_changed');
            isReminderEnabled.value = value;

            if (!value) {
              isFollowupEnabled.value = false;
            }
          },
          title: Text(L.medicationTime),
          subtitle: Text(L.medicationTimeDescription),
        ),
        SwitchListTile(
          value: isFollowupEnabled.value,
          onChanged: (value) {
            analytics.logEvent(name: 'med_sched_followup_changed');
            if (!isReminderEnabled.value) {
              isFollowupEnabled.value = false;
            } else {
              isFollowupEnabled.value = value;
            }
          },
          title: Text(L.enableFollowupNotification),
          subtitle: Text(L.followupNotificationDescription),
        ),
        SwitchListTile(
          value: useCriticalAlert.value,
          onChanged: (value) async {
            analytics.logEvent(name: 'med_sched_critical_changed');
            final grand = await localNotificationService.requestPermissionWithCriticalAlert();
            if (grand == true) {
              useCriticalAlert.value = value;
            } else {
              useCriticalAlert.value = false;
            }
          },
          title: Text(L.enableNotificationInSilentMode),
          subtitle: Text(L.silentModeNotificationDescription),
        ),
        if (isAlarmKitAvailable.data == true) ...[
          SwitchListTile(
            value: useAlarmKit.value,
            onChanged: (value) async {
              analytics.logEvent(name: 'med_sched_alarmkit_changed');
              if (value) {
                // AlarmKitの権限をリクエスト
                final permission = await AlarmKitService.requestPermission();
                if (permission) {
                  useAlarmKit.value = value;
                } else {
                  useAlarmKit.value = false;
                }
              } else {
                useAlarmKit.value = value;
              }
            },
            title: const Text('アラーム機能'),
            subtitle: const Text('目覚まし同様の通知が鳴ります。サイレントモードや集中モード時でも確実に通知されます'),
          ),
        ],
        const SizedBox(height: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  L.criticalAlertVolume,
                ),
              ),
            ),
            Slider(
              value: criticalAlertVolume.value,
              min: 0,
              max: 1,
              label: criticalAlertVolume.value.toString(),
              onChanged: useCriticalAlert.value
                  ? (value) {
                      criticalAlertVolume.value = value;
                    }
                  : null,
              // onChanged はドラッグ中に連続発火するため、確定タイミングの onChangeEnd でログを送る
              onChangeEnd: useCriticalAlert.value
                  ? (value) {
                      analytics.logEvent(name: 'med_sched_volume_change_ended');
                      this.criticalAlertVolume.value = value;
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}
