import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medication_history.dart';

class MedicationsPage extends HookConsumerWidget {
  const MedicationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationHistories = ref.watch(medicationHistoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('服薬履歴'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: medicationHistories.length,
          itemBuilder: (context, index) {
            final history = medicationHistories[index];
            final medicine = history.medicine;
            final schedule = history.action.medicationSchedule;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(medicine.name),
                  Text(schedule.quantityMemo),
                  Text(medicine.doseReceiver?.name ?? 'Default Receiver'),
                  Text(history.createdDateTime?.toString() ?? 'No Date'),
                  Text('${schedule.hour}:${schedule.minute}'),
                  Text(history.memo),
                  if (history.actionKind == MedicationHistoryActionKind.take)
                    const Text('Action: Take')
                  else if (history.actionKind == MedicationHistoryActionKind.revert)
                    const Text('Action: Revert')
                  else if (history.actionKind == MedicationHistoryActionKind.skip)
                    const Text('Action: Skip'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
