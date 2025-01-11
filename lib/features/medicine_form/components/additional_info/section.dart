import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_form/components/additional_info/dose_receiver.dart';
import 'package:medicalarm/features/medicine_form/components/additional_info/stock.dart';
import 'package:medicalarm/features/medicine_form/components/additional_info/unit.dart';
import 'package:medicalarm/features/medicine_form/components/section_layout.dart';

class MedicineAdditionalInfoSection extends StatelessWidget {
  final ValueNotifier<String> memo;
  final ValueNotifier<String> memoImageURL;
  final ValueNotifier<MedicineDoseReceiver?> doseReceiver;
  final ValueNotifier<String> unit;
  final ValueNotifier<int> stock;

  const MedicineAdditionalInfoSection({
    super.key,
    required this.memo,
    required this.memoImageURL,
    required this.doseReceiver,
    required this.unit,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    return MedicineFormSectionLayout(
      icon: Icons.info,
      text: 'その他',
      children: [
        // MedicineMemoRow(memo: memo, memoImageURL: memoImageURL),
        const SizedBox(height: 12),
        MedicineDoseReceiverTile(doseReceiver: doseReceiver),
        const SizedBox(height: 12),
        MedicineUnitTextField(unit: unit),
        const SizedBox(height: 12),
        MedicineStockTile(unit: unit.value, stock: stock),
      ],
    );
  }
}
