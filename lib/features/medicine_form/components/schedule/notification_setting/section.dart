import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_form/components/section_layout.dart';
import 'package:medicalarm/utils/local_notification/client.dart';

class MedicineScheduleNotificationSettingSection extends HookConsumerWidget {
  final ValueNotifier<bool> isReminderEnabled;
  final ValueNotifier<bool> isFollowupEnabled;
  final ValueNotifier<bool> useCriticalAlert;
  final ValueNotifier<double> criticalAlertVolume;

  const MedicineScheduleNotificationSettingSection({
    super.key,
    required this.isReminderEnabled,
    required this.isFollowupEnabled,
    required this.useCriticalAlert,
    required this.criticalAlertVolume,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MedicineFormSectionLayout(
      icon: Icons.notifications,
      text: L.notificationSetting,
      children: [
        SwitchListTile(
          value: isReminderEnabled.value,
          onChanged: (value) {
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
                      // set criticalAlertVolume onChangedEnd
                    }
                  : null,
              onChangeEnd: useCriticalAlert.value
                  ? (value) {
                      criticalAlertVolume.value = value;
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}
