import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/provider/dose_receiver.dart';
import 'package:medicalarm/style/button.dart';
import 'package:medicalarm/theme/form.dart';

class DoseReceiverFormPage extends HookConsumerWidget {
  final ValueNotifier<MedicineDoseReceiver?> doseReceiver;

  const DoseReceiverFormPage({
    super.key,
    required this.doseReceiver,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final doseReceivers = ref.watch(doseReceiversProvider);
    final selectedDoseReceiver = useState(doseReceiver.value);
    selectedDoseReceiver.addListener(() {
      doseReceiver.value = selectedDoseReceiver.value;
    });

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.8,
      builder: (context, scrollController) {
        return Retry(
          retry: () => ref.invalidate(doseReceiversProvider),
          child: doseReceivers.when(
            data: (doseReceivers) {
              return FormTheme(
                child: Scaffold(
                  appBar: AppBar(
                    title: Text('服用者', style: TextStyle(color: primaryColor)),
                  ),
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                        child: Column(
                          children: [
                            for (final doseReceiver in doseReceivers) ...[
                              DoseReceiverTextField(
                                key: ValueKey(doseReceiver.id),
                                doseReceiver: doseReceiver,
                                selectedDoseReceiver: selectedDoseReceiver,
                              ),
                              const SizedBox(height: 6),
                            ],
                            const SizedBox(height: 10),
                            DoseReceiverAddButton(doseReceivers: doseReceivers),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            error: (error, stackTrace) {
              return RetryPage(exception: error);
            },
            loading: () {
              return const CircularProgressIndicator();
            },
          ),
        );
      },
    );
  }
}

class DoseReceiverTextField extends HookConsumerWidget {
  final DoseReceiver doseReceiver;
  final ValueNotifier<MedicineDoseReceiver?> selectedDoseReceiver;
  const DoseReceiverTextField({
    super.key,
    required this.doseReceiver,
    required this.selectedDoseReceiver,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = useState(doseReceiver.name);
    final doseReceiverUpdate = ref.watch(doseReceiverUpdateProvider);
    final doseReceiverDelete = ref.watch(doseReceiverDeleteProvider);
    return Row(
      children: [
        Transform.scale(
          scale: 1.5,
          child: Radio<String?>(
            value: doseReceiver.id,
            groupValue: selectedDoseReceiver.value?.id,
            onChanged: (value) {
              if (value != null) {
                selectedDoseReceiver.value = MedicineDoseReceiver(id: doseReceiver.id, name: doseReceiver.name);
              }
            },
          ),
        ),
        Expanded(
          child: TextFormField(
            initialValue: doseReceiver.name,
            onChanged: (value) {
              name.value = value;
            },
            onFieldSubmitted: (value) {
              doseReceiverUpdate.call(doseReceiver: doseReceiver, name: value);
            },
          ),
        ),
        IconButton(
          onPressed: () {
            doseReceiverDelete.call(doseReceiver: doseReceiver);
          },
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }
}

class DoseReceiverAddButton extends HookConsumerWidget {
  final List<DoseReceiver> doseReceivers;
  const DoseReceiverAddButton({
    super.key,
    required this.doseReceivers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doseReceiverAdd = ref.watch(doseReceiverAddProvider);
    return TextButton.icon(
      onPressed: doseReceivers.any((e) => e.name.isEmpty)
          ? null
          : () {
              doseReceiverAdd.call(name: '');
            },
      icon: const Icon(Icons.add),
      label: const Text('服用者を追加', style: TextStyle(fontWeight: FontWeight.bold)),
      style: secondaryButtonStyle.merge(capsuleButtonStyle),
    );
  }
}
