import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_form/components/section_layout.dart';
import 'package:medicalarm/theme/form.dart';

class ScreenshotMedicineScheduleNotificationFormPage extends HookWidget {
  const ScreenshotMedicineScheduleNotificationFormPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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

MedicationSchedule get schedule => const MedicationSchedule(
      id: '1',
      hour: 10,
      minute: 0,
      quantityMemo: '1錠',
      notificationSetting: MedicineScheduleNotificationSetting(
        isReminderEnabled: true,
        isFollowupEnabled: true,
        useCriticalAlert: true,
        criticalAlertVolume: 0.5,
      ),
      focusConnectSetting: MedicineScheduleFocusConnectSetting(),
    );
ValueNotifier<List<MedicationSchedule>> get schedules => ValueNotifier<List<MedicationSchedule>>([schedule]);
int get index => 0;

class MedicineScheduleNotificationSettingSection extends HookWidget {
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
  Widget build(BuildContext context) {
    final switchListTileThemeTitleTextTheme = ListTileTheme.of(context).titleTextStyle;
    final switchListTileThemeSubtitleTextTheme = ListTileTheme.of(context).subtitleTextStyle;
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
          title: Text(L.enableNotificationInSilentMode,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.solid,
                decorationColor: Colors.red,
                decorationThickness: 2,
              ).merge(switchListTileThemeTitleTextTheme)),
          subtitle: Text(L.silentModeNotificationDescription,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.solid,
                decorationColor: Colors.red,
                decorationThickness: 2,
              ).merge(switchListTileThemeSubtitleTextTheme)),
        ),
      ],
    );
  }
}
