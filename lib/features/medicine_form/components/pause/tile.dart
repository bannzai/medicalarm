import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/container/flat_tile.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/local_notification/client.dart';

class MedicinePauseTile extends HookConsumerWidget {
  final Medicine medicine;
  const MedicinePauseTile({super.key, required this.medicine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: FlatTile(
        child: SwitchListTile(
          title: Text(L.medicationPause),
          subtitle: Text(L.medicationPauseDescription),
          value: medicine.pausedDateTime == null,
          onChanged: (value) async {
            analytics.logEvent(name: 'medicine_form_pause_changed');
            try {
              await ref.read(medicineSetPausedProvider).call(
                    medicineID: medicine.id,
                    medicine: medicine,
                    pausedDateTime: value ? null : DateTime.now(),
                  );
              unawaited(ref.read(registerReminderLocalNotificationProvider).call());
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(value ? L.medicineResumedSnackbar : L.medicinePausedSnackbar)),
                );
              }
            } catch (e) {
              if (context.mounted) {
                showErrorAlert(context, e.toString());
              }
            }
          },
        ),
      ),
    );
  }
}
