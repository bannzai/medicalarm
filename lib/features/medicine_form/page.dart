import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_form/components/section.dart';

class MedicineFormPage extends HookConsumerWidget {
  final Medicine? medicine;

  const MedicineFormPage({super.key, required this.medicine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicine = useState(this.medicine);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Form'),
      ),
      body: Column(
        children: [
          TextFormField(
            initialValue: medicine.value?.name,
            onChanged: (value) {
              medicine.value = medicine.value?.copyWith(name: value);
            },
          ),
          SectionTitle(
            icon: const Icon(Icons.medical_information),
            text: '服用時刻',
            children: [
              for (var notificationSetting in medicine.value?.notificationSettings ?? [])
                TextFormField(
                  initialValue: notificationSetting.reminderTime.toTimeString(),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
