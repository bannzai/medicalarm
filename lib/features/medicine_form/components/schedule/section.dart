import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/add_button.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/delete_button.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/label.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/notification_setting_button.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/quantity_memo_text_field.dart';
import 'package:medicalarm/features/medicine_form/components/section_layout.dart';

class MedicineScheduleSection extends StatelessWidget {
  final ValueNotifier<List<MedicationSchedule>> schedules;
  const MedicineScheduleSection({super.key, required this.schedules});

  @override
  Widget build(BuildContext context) {
    return MedicineFormSectionLayout(
      icon: Icons.schedule,
      text: '服用スケジュール',
      children: [
        const SizedBox(height: 10),
        for (final (index, schedule) in schedules.value.indexed) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                MedicineScheduleReminderTime(
                  schedule: schedule,
                  schedules: schedules,
                  index: index,
                ),
                HookConsumer(builder: (context, ref, child) {
                  return MedicineScheduleQuantityMemoTextField(schedule: schedule, schedules: schedules, index: index);
                }),
                MedicineScheduleNotificationSettingButton(schedule: schedule, schedules: schedules, index: index),
                MedicineScheduleDeleteButton(schedule: schedule, schedules: schedules),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        Center(
          child: MedicineScheduleAddButton(schedules: schedules),
        ),
      ],
    );
  }
}
