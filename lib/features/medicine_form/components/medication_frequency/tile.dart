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
          // 英語のラベルが単語の途中で折り返される。ラベルと値を title の Wrap に並べ、1 行に収まらない時は値を次の行へ送る。
          // Wrap は各要素に行の幅を上限として渡すため、文字を拡大してもラベル・値とも単語の境目で折り返し、はみ出さない (#466)
          title: Wrap(alignment: WrapAlignment.spaceBetween, spacing: 16, children: [Text(L.medicationFrequency), Text(frequency.value.displayName)]),
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
