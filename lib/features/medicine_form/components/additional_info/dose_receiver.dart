import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/dose_receiver_form/page.dart';

class MedicineDoseReceiverTile extends StatelessWidget {
  final ValueNotifier<MedicineDoseReceiver> doseReceiver;
  const MedicineDoseReceiverTile({super.key, required this.doseReceiver});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      child: ListTile(
        title: const Text('服用者'),
        trailing: Wrap(
          children: [
            Text(doseReceiver.value.name),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoseReceiverFormPage(
                doseReceiver: doseReceiver,
              ),
            ),
          );
        },
      ),
    );
  }
}
