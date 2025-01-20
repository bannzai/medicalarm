import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/style/color.dart';

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
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          itemCount: histories.length,
          itemBuilder: (context, index) {
            final history = histories[index];
            final medicine = history.medicine;
            final schedule = history.action.medicationSchedule;
            return MedicationHistoryTile(medicine: medicine, history: history, schedule: schedule);
          },
        ),
      ),
    );
  }
}

class MedicationHistoryTile extends StatelessWidget {
  const MedicationHistoryTile({
    super.key,
    required this.medicine,
    required this.history,
    required this.schedule,
  });

  final Medicine medicine;
  final MedicationHistory history;
  final MedicationSchedule schedule;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
      ),
    );
  }
}
