import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';

class MedicineScheduleQuantityMemoTextField extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: TextEditingController(text: schedule.quantityMemo),
      onChanged: (value) {
        final copied = [...schedules.value];
        copied[index] = copied[index].copyWith(quantityMemo: value);
        schedules.value = copied;
      },
      style: const TextStyle(fontSize: 12),
      decoration: const InputDecoration(
        labelText: '容量',
        hintText: '例: 1錠、100mg',
      ),
    );
  }
}
