import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

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
    final quantityMemo = useState(schedule.quantityMemo);

    return TextFormField(
      onChanged: (value) {
        quantityMemo.value = value;
      },
      onFieldSubmitted: (value) {
        analytics.logEvent(name: 'med_schedule_quantity_submitted');
        final copied = [...schedules.value];
        copied[index] = copied[index].copyWith(quantityMemo: value);
        schedules.value = copied;
      },
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        labelText: L.quantity,
        hintText: L.quantityExample,
      ),
    );
  }
}
