import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

class MedicineScheduleQuantityMemoTextField extends StatelessWidget {
  final MedicationSchedule schedule;
  final ValueNotifier<List<MedicationSchedule>> schedules;
  final int index;
  const MedicineScheduleQuantityMemoTextField({
    super.key,
    required this.schedule,
    required this.schedules,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: schedule.quantityMemo,
      // 改行せずに保存ボタンを押しても入力した容量が保存されるよう、入力のたびに schedules へ反映する (#402)
      onChanged: (value) {
        final copied = [...schedules.value];
        copied[index] = copied[index].copyWith(quantityMemo: value);
        schedules.value = copied;
      },
      onFieldSubmitted: (value) {
        analytics.logEvent(name: 'med_schedule_quantity_submitted');
      },
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        labelText: L.quantity,
        hintText: L.quantityExample,
      ),
    );
  }
}
