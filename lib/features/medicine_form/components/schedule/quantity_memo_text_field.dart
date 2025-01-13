import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/style/color.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: TextField(
            controller: TextEditingController(text: schedule.quantityMemo),
            onChanged: (value) {
              final copied = [...schedules.value];
              copied[index] = copied[index].copyWith(quantityMemo: value);
              schedules.value = copied;
            },
            decoration: const InputDecoration(
              labelText: '容量',
            ),
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
