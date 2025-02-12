import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/notification_setting/section.dart';
import 'package:medicalarm/features/medicine_form/components/section_layout.dart';
import 'package:medicalarm/theme/form.dart';

class MedicineScheduleNotificationFormPage extends HookConsumerWidget {
  final MedicationSchedule schedule;
  final ValueNotifier<List<MedicationSchedule>> schedules;
  final int index;
  const MedicineScheduleNotificationFormPage({
    super.key,
    required this.schedule,
    required this.schedules,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReminderEnabled = useState(schedule.notificationSetting.isReminderEnabled);
    final isFollowupEnabled = useState(schedule.notificationSetting.isFollowupEnabled);
    final useCriticalAlert = useState(schedule.notificationSetting.useCriticalAlert);
    final primaryColor = Theme.of(context).colorScheme.primary;
    isReminderEnabled.addListener(() {
      final copied = [...schedules.value];
      copied[index] = copied[index].copyWith(
        notificationSetting: copied[index].notificationSetting.copyWith(
              isReminderEnabled: isReminderEnabled.value,
            ),
      );
      schedules.value = copied;
    });
    isFollowupEnabled.addListener(() {
      final copied = [...schedules.value];
      copied[index] =
          copied[index].copyWith(notificationSetting: copied[index].notificationSetting.copyWith(isFollowupEnabled: isFollowupEnabled.value));
      schedules.value = copied;
    });
    useCriticalAlert.addListener(() {
      final copied = [...schedules.value];
      copied[index] =
          copied[index].copyWith(notificationSetting: copied[index].notificationSetting.copyWith(useCriticalAlert: useCriticalAlert.value));
      schedules.value = copied;
    });

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: FormTheme(
        child: Scaffold(
          appBar: AppBar(
            title: Text(L.medicationScheduleNotificationSetting, style: TextStyle(color: primaryColor)),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MedicineScheduleNotificationSettingSection(
                    isReminderEnabled: isReminderEnabled,
                    isFollowupEnabled: isFollowupEnabled,
                    useCriticalAlert: useCriticalAlert,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MedicineScheduleNotificationSettingSection extends HookConsumerWidget {
  final ValueNotifier<bool> isReminderEnabled;
  final ValueNotifier<bool> isFollowupEnabled;
  final ValueNotifier<bool> useCriticalAlert;

  const MedicineScheduleNotificationSettingSection({
    super.key,
    required this.isReminderEnabled,
    required this.isFollowupEnabled,
    required this.useCriticalAlert,
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
          onChanged: (value) async {},
          title: Text(L.enableNotificationInSilentMode),
          subtitle: Text(L.silentModeNotificationDescription),
        ),
      ],
    );
  }
}
