import 'package:flutter/material.dart';
import 'package:medicalarm/components/container/flat_tile.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/features/medication_frequency_form/page.dart';

class MedicationFrequencyTile extends StatelessWidget {
  final ValueNotifier<MedicationFrequency> frequency;
  const MedicationFrequencyTile({super.key, required this.frequency});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: FlatTile(
        child: ListTile(
          title: const Text('飲む頻度'),
          trailing: Wrap(
            children: [
              Text(frequency.value.displayName),
              const Icon(Icons.chevron_right),
            ],
          ),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => MedicationFrequencyFormPage(frequency: frequency),
            );
          },
        ),
      ),
    );
  }
}
