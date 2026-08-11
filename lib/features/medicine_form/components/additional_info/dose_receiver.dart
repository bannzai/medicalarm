import 'package:flutter/material.dart';
import 'package:medicalarm/components/container/flat_tile.dart';
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
          title: Text(L.doseReceiver),
          trailing: Wrap(
            children: [
              Text(doseReceiver.value?.name ?? L.defaultDoseReceiver),
              const Icon(Icons.chevron_right),
            ],
          ),
          onTap: () {
            analytics.logEvent(name: 'medicine_form_dose_rcvr_tapped');
            showModalBottomSheet(
              context: context,
              useSafeArea: true,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
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
