import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/features/preium_introduction/premium_introduction_sheet.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/dose_receiver.dart';
import 'package:medicalarm/style/button.dart';
import 'package:medicalarm/theme/form.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/billing/created_count.dart';
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
                          child: RadioGroup<String?>(
                            groupValue: selectedDoseReceiver.value?.id,
                            onChanged: (value) {
                              analytics.logEvent(name: 'dose_rcvr_radio_selected');
                              final tappedDoseReceiver = doseReceivers.firstWhereOrNull((doseReceiver) => doseReceiver.id == value);
                              if (tappedDoseReceiver != null) {
                                selectedDoseReceiver.value = tappedDoseReceiver;
                              }
                            },
                            child: Column(
                              children: [
                                for (final doseReceiver in doseReceivers) ...[
                                  DoseReceiverTextField(
                                    key: ValueKey(doseReceiver.id),
                                    doseReceiver: doseReceiver,
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
  const DoseReceiverTextField({
    super.key,
    required this.doseReceiver,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = useState(doseReceiver.name);
    final doseReceiverUpdate = ref.watch(doseReceiverUpdateProvider);
    return Row(
      children: [
        Transform.scale(
          scale: 1.5,
          // 選択状態と選択時の処理は祖先の RadioGroup が担う
          child: Radio<String?>(
            value: doseReceiver.id,
          ),
        ),
        Expanded(
          child: TextFormField(
            initialValue: doseReceiver.name,
            onChanged: (value) {
              name.value = value;
            },
            onFieldSubmitted: (value) {
              analytics.logEvent(name: 'dose_rcvr_name_submitted');
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
    final appUserID = ref.watch(appUserIDProvider);
    final createdDoseReceiversCount =
        countCreatedByUser(items: doseReceivers, userID: appUserID, creatorUserID: (doseReceiver) => doseReceiver.userID);
    return Column(
      children: [
        if (createdDoseReceiversCount >= DoseReceiver.maxCount(hasPremiumEntitlement: customerInfo?.hasPremiumEntitlement)) ...[
          Text(L.doseReceiverMaxCount(DoseReceiver.maxCount(hasPremiumEntitlement: customerInfo?.hasPremiumEntitlement)),
              style: const TextStyle(color: Colors.red)),
          if (customerInfo?.hasPremiumEntitlement == false) ...[
            TextButton(
              onPressed: () {
                analytics.logEvent(name: 'dose_rcvr_premium_pressed');
                showPremiumIntroductionSheet(context);
              },
              child: Text(
                L.increaseLimitWithPremium(DoseReceiver.maxCount(hasPremiumEntitlement: true)),
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
          onPressed: createdDoseReceiversCount < DoseReceiver.maxCount(hasPremiumEntitlement: customerInfo?.hasPremiumEntitlement)
              ? () {
                  analytics.logEvent(name: 'dose_rcvr_add_pressed');
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
