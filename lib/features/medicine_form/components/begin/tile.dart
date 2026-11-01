import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/components/container/flat_tile.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/features/localization/l.dart';

class MedicationBeginTile extends StatelessWidget {
  final ValueNotifier<DateTime> begin;
  const MedicationBeginTile({super.key, required this.begin});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: FlatTile(
        child: ListTile(
          // 値を trailing に置くと、文字を拡大した時に trailing が先に幅を取り、英語のラベルが単語の途中で折り返される。
          // 服用頻度の行 (#466) と同じく、ラベルと値を title の Wrap に並べる (#474)。
          // spacing は、値を trailing に置いていた時のラベルとの間隔 (ListTile の horizontalTitleGap の既定 16) に揃える
          title: Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 16,
            children: [Text(L.medicationStartDate), Text(DateFormat('yyyy/MM/dd').format(begin.value))],
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            analytics.logEvent(name: 'medicine_form_begin_tapped');
            final firstDate = today().subtract(const Duration(days: 365));
            final lastDate = today();
            final result = await showDatePicker(context: context, firstDate: firstDate, lastDate: lastDate);
            if (result != null) {
              begin.value = result;
            }
          },
        ),
      ),
    );
  }
}
