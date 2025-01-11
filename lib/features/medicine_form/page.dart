import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_form/components/medication_frequency/tile.dart';
import 'package:medicalarm/features/medicine_form/components/name_text_field.dart';
import 'package:medicalarm/features/medicine_form/components/notification_setting/section.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/section.dart';
import 'package:medicalarm/theme/form.dart';

class MedicineFormPage extends HookConsumerWidget {
  final Medicine? medicine;

  const MedicineFormPage({super.key, required this.medicine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = useState(medicine?.name ?? '');
    final frequency = useState(medicine?.frequency ?? const MedicationFrequency.daily());
    final schedules = useState(medicine?.schedules ?? []);
    final primaryColor = Theme.of(context).colorScheme.primary;

    final isReminderEnabled = useState(medicine?.notificationSetting.isReminderEnabled ?? true);
    final isFollowupEnabled = useState(medicine?.notificationSetting.isFollowupEnabled ?? true);
    final useCriticalAlert = useState(medicine?.notificationSetting.useCriticalAlert ?? false);

    return DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.8,
        builder: (context, scrollController) {
          return FormTheme(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Medicine Form', style: TextStyle(color: primaryColor)),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MedicineFormNameTextField(name: name),
                      MedicationFrequencyTile(frequency: frequency),
                      MedicineScheduleSection(schedules: schedules),
                      if (schedules.value.isNotEmpty) ...[
                        MedicineNotificationSettingSection(
                          isReminderEnabled: isReminderEnabled,
                          isFollowupEnabled: isFollowupEnabled,
                          useCriticalAlert: useCriticalAlert,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
