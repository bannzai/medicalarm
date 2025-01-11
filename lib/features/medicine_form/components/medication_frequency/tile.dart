import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/style/color.dart';

class MedicationFrequencyTile extends StatelessWidget {
  final ValueNotifier<MedicationFrequency> frequency;
  const MedicationFrequencyTile({super.key, required this.frequency});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: ListTile(
          title: const Text('頻度'),
          trailing: Wrap(
            children: [
              Text(frequency.value.displayName),
              const Icon(Icons.chevron_right),
            ],
          ),
          onTap: () {
            showModalBottomSheet(context: context, builder: (context) => MedicationFrequencyFormPage(frequency: frequency));
          },
        ),
      ),
    );
  }
}
