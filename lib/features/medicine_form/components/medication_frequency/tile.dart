import 'package:flutter/material.dart';
import 'package:medicalarm/components/container/flat_tile.dart';
import 'package:medicalarm/components/sheet/full_screen_modal_bottom_sheet.dart';
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
          // trailing は title より先に幅を取るため、長い値 (Cycle 等) を trailing に置くと title が 1 語より狭くなり
          // 英語のラベルが単語の途中で折り返される。値を title の Row に移し、ラベルの幅を保って値の側を折り返す (#466)
          title: Row(
            children: [
              Text(L.medicationFrequency),
              const SizedBox(width: 16),
              Expanded(child: Text(frequency.value.displayName, textAlign: TextAlign.end)),
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            analytics.logEvent(name: 'medicine_form_freq_tile_tapped');
            showFullScreenModalBottomSheet(
              context: context,
              builder: (context) => MedicationFrequencyFormPage(frequency: frequency),
            );
          },
        ),
      ),
    );
  }
}
