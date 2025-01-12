import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/notification_setting/section.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/theme/form.dart';

class MedicineScheduleFormPage extends HookConsumerWidget {
  final MedicationSchedule schedule;
  const MedicineScheduleFormPage({super.key, required this.schedule});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReminderEnabled = useState(schedule.notificationSetting.isReminderEnabled);
    final isFollowupEnabled = useState(schedule.notificationSetting.isFollowupEnabled);
    final useCriticalAlert = useState(schedule.notificationSetting.useCriticalAlert);
    final quantityMemo = useState(schedule.quantityMemo);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return FormTheme(
      child: Scaffold(
        appBar: AppBar(
          title: Text('服用時刻設定', style: TextStyle(color: primaryColor)),
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
                MedicineScheduleQuantityMemoTextField(quantityMemo: quantityMemo),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MedicineScheduleQuantityMemoTextField extends HookConsumerWidget {
  final ValueNotifier<String> quantityMemo;
  const MedicineScheduleQuantityMemoTextField({super.key, required this.quantityMemo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: TextEditingController(text: quantityMemo.value),
          onChanged: (value) {
            quantityMemo.value = value;
          },
          decoration: const InputDecoration(
            labelText: '容量',
          ),
        ),
        const SizedBox(height: 4),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '容量を入力してください。(例: 1錠、100mg)。 容量は通知に表示されます。',
            style: TextStyle(color: TextColor.gray, fontSize: 10.0),
          ),
        ),
      ],
    );
  }
}
