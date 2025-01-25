import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/fab/layout.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medications/components/add_button.dart';
import 'package:medicalarm/features/medicine_form/page.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/style/color.dart';

class MedicinesPage extends HookConsumerWidget {
  const MedicinesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicines = ref.watch(activeMedicinesProvider);

    return Retry(
      retry: () => ref.invalidate(activeMedicinesProvider),
      child: medicines.when(
        data: (medicines) => MedicinesPageBody(medicines: medicines),
        error: (error, stackTrace) => RetryPage(exception: error),
        loading: () => const IndicatorPage(),
      ),
    );
  }
}

class MedicinesPageBody extends HookConsumerWidget {
  final List<Medicine> medicines;
  const MedicinesPageBody({super.key, required this.medicines});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('お薬一覧'),
      ),
      body: FloatingActionButtonLayout(
        scaffoldBody: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          children: medicines
              .map((medicine) => Column(
                    children: [
                      MedicinesPageSection(medicine: medicine),
                      const SizedBox(height: 10),
                    ],
                  ))
              .toList(),
        ),
        floatingActionButton: MedicalAddFloatingActionButtonChild(
          medicines: medicines,
        ),
      ),
    );
  }
}

class MedicinesPageSection extends StatelessWidget {
  final Medicine medicine;
  const MedicinesPageSection({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // 影の位置を調整
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  medicine.doseReceiver.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                for (final schedule in medicine.schedules) ...[
                  MedicinesPageMedicationScheduleRow(schedule: schedule),
                ],
                if (medicine.memo.isNotEmpty) ...[
                  Text(medicine.memo),
                ]
              ],
            ),
          ),
        ),
        Positioned(
          right: 12,
          top: 0,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              showMedicineForm(context, medicine);
            },
            icon: const Icon(Icons.edit, size: 20),
          ),
        ),
      ],
    );
  }
}

class MedicinesPageMedicationScheduleRow extends StatelessWidget {
  final MedicationSchedule schedule;
  const MedicinesPageMedicationScheduleRow({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          schedule.toTimeString(),
          style: const TextStyle(fontSize: 16),
        ),
        const Spacer(),
        if (schedule.quantityMemo.isNotEmpty) ...[
          Text(schedule.quantityMemo),
        ],
      ],
    );
  }
}
