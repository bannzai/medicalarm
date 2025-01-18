import 'package:async_value_group/async_value_group.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/checkbox/app_checkbox.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicines/components/add_button.dart';
import 'package:medicalarm/features/medicines/entity/grouped.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/style/color.dart';

class MedicinesPage extends HookConsumerWidget {
  const MedicinesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicines = ref.watch(activeMedicinesProvider);
    final medicationHistories = ref.watch(medicationHistoriesProvider);

    return Retry(
      retry: () => ref.invalidate(activeMedicinesProvider),
      child: AsyncValueGroup.group2(medicines, medicationHistories).when(
        data: (data) => MedicinesPageBody(medicines: data.$1, medicationHistories: data.$2),
        error: (error, stackTrace) => RetryPage(exception: error),
        loading: () => const IndicatorPage(),
      ),
    );
  }
}

class MedicinesPageBody extends HookConsumerWidget {
  final List<Medicine> medicines;
  final List<MedicationHistory> medicationHistories;

  const MedicinesPageBody({
    super.key,
    required this.medicines,
    required this.medicationHistories,
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
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (final tileValue in _tileValues()) ...[
                    MedicineTile(tileValue: tileValue),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: const MedicalAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  List<MedicineTileValue> _tileValues() {
    final tileValues = <MedicineTileValue>[];
    // scheduleTimeとdoseReceiverごとのtileValuesを構築する
    for (final medicine in medicines) {
      final doseReceiver = medicine.doseReceiver;

      for (final schedule in medicine.schedules) {
        final scheduleTime = ScheduleTime(hour: schedule.hour, minute: schedule.minute);
        tileValues.add(MedicineTileValue(scheduleTime: scheduleTime, doseReceiver: doseReceiver, dosingRows: []));
      }
    }

    // dosingRowsを構築する
    for (final medicine in medicines) {
      final doseReceiver = medicine.doseReceiver;

      for (final schedule in medicine.schedules) {
        final scheduleTime = ScheduleTime(hour: schedule.hour, minute: schedule.minute);

        final tileIndex = tileValues.indexWhere(
          (tile) => tile.scheduleTime == scheduleTime && tile.doseReceiver == doseReceiver,
        );
        final tile = tileValues[tileIndex];

        final dosingRows = [...tile.dosingRows];
        final medicationHistory = medicationHistories.firstWhereOrNull(
          (history) => history.medicine.id == medicine.id && history.action.medicationSchedule.id == schedule.id,
        );
        final row = MedicineDosingRowValue(
          medicationHistory: medicationHistory,
          medicineName: medicine.name,
          quantityMemo: schedule.quantityMemo,
        );

        dosingRows.add(row);
        tileValues[tileIndex] = tile.copyWith(dosingRows: [...dosingRows]);
      }
    }

    return tileValues;
  }
}

class MedicineTile extends HookConsumerWidget {
  final MedicineTileValue tileValue;
  const MedicineTile({super.key, required this.tileValue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tileValue.scheduleTime.toTimeString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              tileValue.doseReceiver.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            for (final dosingRow in tileValue.dosingRows) ...[
              MedicineTileRow(dosingRow: dosingRow),
            ],
          ],
        ),
      ),
    );
  }
}

class MedicineTileRow extends HookConsumerWidget {
  const MedicineTileRow({
    super.key,
    required this.dosingRow,
  });

  final MedicineDosingRowValue dosingRow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isChecked = useState(false);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppCheckbox(
          value: isChecked.value,
          onChanged: (value) {
            isChecked.value = value;
          },
        ),
        Text(dosingRow.medicineName, style: const TextStyle(fontSize: 16)),
        const Spacer(),
        Text(dosingRow.quantityMemo),
      ],
    );
  }
}
