import 'package:flutter/material.dart';
import 'package:medicalarm/components/container/flat_tile.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/features/dose_receiver_form/page.dart';
import 'package:medicalarm/features/resolver/app_resolvers.dart';

class MedicineDoseReceiverTile extends StatelessWidget {
  final ValueNotifier<DoseReceiver?> doseReceiver;
  const MedicineDoseReceiverTile({super.key, required this.doseReceiver});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: FlatTile(
        child: ListTile(
          title: const Text('服用者'),
          trailing: Wrap(
            children: [
              Text(doseReceiver.value?.name ?? 'あなた'),
              const Icon(Icons.chevron_right),
            ],
          ),
          onTap: () {
            showModalBottomSheet(
              context: context,
              useSafeArea: true,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => AppResolvers(
                builder: (context, user) {
                  return DoseReceiverFormPage(
                    doseReceiver: doseReceiver,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
