import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/theme/form.dart';

class MedicationFrequencyFormPage extends StatelessWidget {
  final ValueNotifier<MedicationFrequency> frequency;
  const MedicationFrequencyFormPage({super.key, required this.frequency});

  @override
  Widget build(BuildContext context) {
    return FormTheme(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('頻度'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              ListTile(
                title: const Text('毎日'),
                trailing: frequency.value is DailyMedicationFrequency ? const Icon(Icons.check) : null,
              ),
              ListTile(
                title: const Text('X日ごと'),
                trailing: frequency.value is EveryXDaysMedicationFrequency ? const Icon(Icons.check) : null,
              ),
              ListTile(
                title: const Text('特定の曜日'),
                trailing: frequency.value is SpecificDayOfWeekMedicationFrequency ? const Icon(Icons.check) : null,
              ),
              ListTile(
                title: const Text('月の特定日'),
                trailing: frequency.value is SpecificDayOfMonthMedicationFrequency ? const Icon(Icons.check) : null,
              ),
              ListTile(
                title: const Text('奇数日/偶数日'),
                trailing: frequency.value is OddOrEvenDayMedicationFrequency ? const Icon(Icons.check) : null,
              ),
              ListTile(
                title: const Text('周期'),
                trailing: frequency.value is CycleMedicationFrequency ? const Icon(Icons.check) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
