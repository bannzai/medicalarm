import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_form/page.dart';
import 'package:medicalarm/features/preium_introduction/premium_introduction_sheet.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';
import 'package:medicalarm/features/localization/l.dart';

class MedicalAddFloatingActionButtonChild extends HookConsumerWidget {
  const MedicalAddFloatingActionButtonChild({
    super.key,
    required this.medicines,
  });

  final List<Medicine> medicines;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerInfo = ref.watch(customerInfoProvider).asData?.value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          if (medicines.length >= Medicine.maxCount(hasPremiumEntitlement: customerInfo?.hasPremiumEntitlement)) ...[
            Text(L.medicineMaxCount(Medicine.maxCount(hasPremiumEntitlement: customerInfo?.hasPremiumEntitlement)),
                style: const TextStyle(color: TextColor.danger)),
            const SizedBox(height: 4),
            if (customerInfo?.hasPremiumEntitlement == false) ...[
              TextButton(
                onPressed: () {
                  showPremiumIntroductionSheet(context);
                },
                child: Text(
                  L.increaseMedicineLimitWithPremium(Medicine.maxCount(hasPremiumEntitlement: true)),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ],
          ElevatedButton.icon(
            onPressed: medicines.length < Medicine.maxCount(hasPremiumEntitlement: customerInfo?.hasPremiumEntitlement)
                ? () {
                    showMedicineForm(context, null);
                  }
                : null,
            icon: const Icon(Icons.add),
            label: Text(L.addMedicine),
          ),
        ],
      ),
    );
  }
}
