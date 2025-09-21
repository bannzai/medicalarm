import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/focus_connect/section.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/notification_setting/section.dart';
import 'package:medicalarm/theme/form.dart';

class MedicineScheduleSettingFormPage extends HookConsumerWidget {
  final MedicationSchedule schedule;
  final ValueNotifier<List<MedicationSchedule>> schedules;
  final int index;
  const MedicineScheduleSettingFormPage({
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
    final criticalAlertVolume = useState(schedule.notificationSetting.criticalAlertVolume);
    final useAlarmKit = useState(schedule.notificationSetting.useAlarmKit);
    final focusConnectScheduleID = useState(schedule.focusConnectSetting?.focusConnectScheduleID);
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
      copied[index] = copied[index].copyWith(
        notificationSetting: copied[index].notificationSetting.copyWith(useCriticalAlert: useCriticalAlert.value),
      );
      schedules.value = copied;
    });
    criticalAlertVolume.addListener(() {
      final copied = [...schedules.value];
      copied[index] = copied[index].copyWith(
        notificationSetting: copied[index].notificationSetting.copyWith(criticalAlertVolume: criticalAlertVolume.value),
      );
      schedules.value = copied;
    });
    useAlarmKit.addListener(() {
      final copied = [...schedules.value];
      copied[index] = copied[index].copyWith(
        notificationSetting: copied[index].notificationSetting.copyWith(useAlarmKit: useAlarmKit.value),
      );
      schedules.value = copied;
    });
    focusConnectScheduleID.addListener(() {
      final copied = [...schedules.value];
      final focusConnectSetting = copied[index].focusConnectSetting;
      if (focusConnectSetting == null) {
        copied[index] =
            copied[index].copyWith(focusConnectSetting: MedicineScheduleFocusConnectSetting(focusConnectScheduleID: focusConnectScheduleID.value));
      } else {
        copied[index] =
            copied[index].copyWith(focusConnectSetting: focusConnectSetting.copyWith(focusConnectScheduleID: focusConnectScheduleID.value));
      }
      schedules.value = copied;
    });
    final primaryColor = Theme.of(context).colorScheme.primary;

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
                    criticalAlertVolume: criticalAlertVolume,
                    useAlarmKit: useAlarmKit,
                  ),
                  MedicineScheduleFocusConnectSettingSection(
                    schedule: schedule,
                    focusConnectScheduleID: focusConnectScheduleID,
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
