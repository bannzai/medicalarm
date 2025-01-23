import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_form/page.dart';
import 'package:medicalarm/style/button.dart';
import 'package:medicalarm/style/color.dart';

class MedicalAddButton extends HookConsumerWidget {
  const MedicalAddButton({
    super.key,
    required this.medicines,
  });

  final List<Medicine> medicines;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          if (medicines.length >= Medicine.maxCount) ...[
            const Text('お薬は${Medicine.maxCount}つまで登録できます。', style: TextStyle(color: TextColor.danger)),
            const SizedBox(height: 4),
          ],
          ElevatedButton.icon(
            onPressed: medicines.length >= Medicine.maxCount
                ? null
                : () {
                    showMedicineForm(context, null);
                  },
            icon: const Icon(Icons.add),
            label: const Text('お薬を追加'),
            style: filledWidthButtonStyle,
          ),
        ],
      ),
    );
  }
}
