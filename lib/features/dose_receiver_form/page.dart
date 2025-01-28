import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/features/preium_introduction/premium_introduction_sheet.dart';
import 'package:medicalarm/provider/dose_receiver.dart';
import 'package:medicalarm/style/button.dart';
import 'package:medicalarm/theme/form.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';
import 'package:medicalarm/features/localization/l.dart';

class DoseReceiverFormPage extends HookConsumerWidget {
  final ValueNotifier<DoseReceiver?> doseReceiver;

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
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: FormTheme(
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(L.doseReceiver, style: TextStyle(color: primaryColor)),
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
  final ValueNotifier<DoseReceiver?> selectedDoseReceiver;
  const DoseReceiverTextField({
    super.key,
    required this.doseReceiver,
    required this.selectedDoseReceiver,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = useState(doseReceiver.name);
    final doseReceiverUpdate = ref.watch(doseReceiverUpdateProvider);
    return Row(
      children: [
        Transform.scale(
          scale: 1.5,
          child: Radio<String?>(
            value: doseReceiver.id,
            groupValue: selectedDoseReceiver.value?.id,
            onChanged: (value) {
              if (value != null) {
                selectedDoseReceiver.value = doseReceiver;
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
    final customerInfo = ref.watch(customerInfoProvider).asData?.value;
    return Column(
      children: [
        if (doseReceivers.length >= DoseReceiver.maxCount(isPremium: customerInfo?.isPremium)) ...[
          Text(
            L.doseReceiverMaxCount(DoseReceiver.maxCount(isPremium: customerInfo?.isPremium)),
            style: const TextStyle(color: Colors.red)
          ),
          if (customerInfo?.isPremium == false) ...[
            TextButton(
              onPressed: () {
                showPremiumIntroductionSheet(context);
              },
              child: Text(
                L.increaseLimitWithPremium(DoseReceiver.maxCount(isPremium: true)),
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ],
        TextButton.icon(
          onPressed: doseReceivers.length < DoseReceiver.maxCount(isPremium: customerInfo?.isPremium)
              ? () {
                  doseReceiverAdd.call(name: L.newDoseReceiver);
                }
              : null,
          icon: const Icon(Icons.add),
          label: Text(L.addDoseReceiver, style: const TextStyle(fontWeight: FontWeight.bold)),
          style: capsuleTextButtonStyle(context),
        ),
      ],
    );
  }
}
