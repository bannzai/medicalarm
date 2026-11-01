import 'package:flutter/material.dart';
import 'package:medicalarm/components/container/flat_tile.dart';
import 'package:medicalarm/components/sheet/full_screen_modal_bottom_sheet.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/features/dose_receiver_form/page.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

class MedicineDoseReceiverTile extends StatelessWidget {
  final ValueNotifier<DoseReceiver?> doseReceiver;
  const MedicineDoseReceiverTile({super.key, required this.doseReceiver});

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
            children: [Text(L.doseReceiver), Text(doseReceiver.value?.name ?? L.defaultDoseReceiver)],
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            analytics.logEvent(name: 'medicine_form_dose_rcvr_tapped');
            showFullScreenModalBottomSheet(
              context: context,
              builder: (context) => DoseReceiverFormPage(
                doseReceiver: doseReceiver,
              ),
            );
          },
        ),
      ),
    );
  }
}
