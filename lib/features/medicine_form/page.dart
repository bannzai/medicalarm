import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_form/components/notification_setting/section.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/section.dart';
import 'package:medicalarm/features/medicine_form/components/section.dart';
import 'package:medicalarm/theme/form.dart';

class MedicineFormPage extends HookConsumerWidget {
  final Medicine? medicine;

  const MedicineFormPage({super.key, required this.medicine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = useState(medicine?.name ?? '');
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                        child: TextFormField(
                          initialValue: name.value,
                          onChanged: (value) {
                            name.value = value;
                          },
                          decoration: const InputDecoration(
                            hintText: '薬の名前',
                          ),
                        ),
                      ),
                      Section(
                        icon: Icons.schedule,
                        text: '服用時刻',
                        children: [
                          MedicineScheduleSection(schedules: schedules),
                        ],
                      ),
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
