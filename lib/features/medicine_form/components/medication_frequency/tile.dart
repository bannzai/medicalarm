import 'package:flutter/material.dart';
import 'package:medicalarm/components/container/flat_tile.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/features/medication_frequency_form/page.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

class MedicationFrequencyTile extends StatelessWidget {
  final ValueNotifier<MedicationFrequency> frequency;
  const MedicationFrequencyTile({super.key, required this.frequency});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: FlatTile(
        child: ListTile(
          title: Text(L.medicationFrequency),
          trailing: Wrap(
            children: [
              Text(frequency.value.displayName),
              const Icon(Icons.chevron_right),
            ],
          ),
          onTap: () {
            analytics.logEvent(name: 'med_form_freq_tile_tap');
            showModalBottomSheet(
              context: context,
              useSafeArea: true,
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
