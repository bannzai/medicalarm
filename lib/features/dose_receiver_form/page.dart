import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/provider/dose_receiver.dart';
import 'package:medicalarm/style/button.dart';
import 'package:medicalarm/theme/form.dart';

class DoseReceiverFormPage extends HookConsumerWidget {
  final ValueNotifier<MedicineDoseReceiver> doseReceiver;

  const DoseReceiverFormPage({
    super.key,
    required this.doseReceiver,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doseReceivers = ref.watch(doseReceiversProvider);

    return FormTheme(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              TextField(
                controller: TextEditingController(text: doseReceiver.value.name),
                onChanged: (value) {
                  doseReceiver.value = doseReceiver.value.copyWith(name: value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DoseReceiverAddButton extends HookConsumerWidget {
  const DoseReceiverAddButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doseReceiverAdd = ref.watch(doseReceiverAddProvider);
    return TextButton.icon(
      onPressed: () {
        doseReceiverAdd.call(name: '');
      },
      icon: const Icon(Icons.add),
      label: const Text('服用者を追加', style: TextStyle(fontWeight: FontWeight.bold)),
      style: secondaryButtonStyle.merge(capsuleButtonStyle),
    );
  }
}
