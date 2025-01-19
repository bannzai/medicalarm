import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/provider/medication_history.dart';

class MedicationHistoriesPage extends HookConsumerWidget {
  const MedicationHistoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationHistories = ref.watch(medicationHistoriesProvider);

    return Retry(
      retry: () => ref.invalidate(medicationHistoriesProvider),
      child: medicationHistories.when(
        data: (histories) => MedicationsHistoryPageBody(histories: histories),
        error: (error, stackTrace) => RetryPage(exception: error),
        loading: () => const IndicatorPage(),
      ),
    );
  }
}

class MedicationsHistoryPageBody extends StatelessWidget {
  final List<MedicationHistory> histories;
  const MedicationsHistoryPageBody({
    super.key,
    required this.histories,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('服薬履歴'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: histories.length,
          itemBuilder: (context, index) {
            final history = histories[index];
            final medicine = history.medicine;
            final schedule = history.action.medicationSchedule;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(medicine.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      const Text('時間:'),
                      Text(history.createdDateTime?.toString() ?? 'No Date'),
                    ],
                  ),
                  Text(schedule.quantityMemo, style: const TextStyle(fontSize: 12)),
                  Text(medicine.doseReceiver.name),
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
