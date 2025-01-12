import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicines/components/add_button.dart';
import 'package:medicalarm/provider/medicine.dart';

class MedicinesPage extends HookConsumerWidget {
  const MedicinesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicines = ref.watch(medicinesProvider);

    return Retry(
      retry: () => ref.invalidate(medicinesProvider),
      child: medicines.when(
        data: (medicines) => MedicinesPageBody(medicines: medicines),
        error: (error, stackTrace) => RetryPage(exception: error),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class MedicinesPageBody extends HookConsumerWidget {
  final List<Medicine> medicines;
  const MedicinesPageBody({
    super.key,
    required this.medicines,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('お薬'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (final medicine in medicines) ...[
                  MedicineTile(medicine: medicine),
                ],
                const MedicalAddButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MedicineTile extends HookConsumerWidget {
  final Medicine medicine;
  const MedicineTile({super.key, required this.medicine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isChecked = useState(false);
    return Row(
      children: [
        Checkbox(
          value: isChecked.value,
          onChanged: (value) {
            isChecked.value = value ?? false;
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(medicine.schedules.first.toTimeString()),
            Text(medicine.name),
          ],
        ),
      ],
    );
  }
}
