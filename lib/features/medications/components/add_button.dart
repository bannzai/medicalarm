import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';

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
          if (medicines.length >= Medicine.maxCount(isPremium: customerInfo?.isPremium)) ...[
            Text('お薬は${Medicine.maxCount(isPremium: customerInfo?.isPremium)}つまで登録できます。', style: const TextStyle(color: TextColor.danger)),
            const SizedBox(height: 4),
          ],
          const Row(
            children: [
              Icon(Icons.add),
              Text('お薬を追加'),
            ],
          ),
        ],
      ),
    );
  }
}
