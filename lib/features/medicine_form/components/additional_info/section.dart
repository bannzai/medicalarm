import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_form/components/additional_info/dose_receiver.dart';
import 'package:medicalarm/features/medicine_form/components/additional_info/memo.dart';
import 'package:medicalarm/features/medicine_form/components/section_layout.dart';

class MedicineAdditionalInfoSection extends StatelessWidget {
  final ValueNotifier<String> memo;
  final ValueNotifier<String> memoImageURL;
  final ValueNotifier<MedicineDoseReceiver?> doseReceiver;

  const MedicineAdditionalInfoSection({
    super.key,
    required this.memo,
    required this.memoImageURL,
    required this.doseReceiver,
  });

  @override
  Widget build(BuildContext context) {
    return MedicineFormSectionLayout(
      icon: Icons.info,
      text: 'その他',
      children: [
        MedicineMemoRow(memo: memo, memoImageURL: memoImageURL),
        const SizedBox(height: 6),
        MedicineDoseReceiverTile(doseReceiver: doseReceiver),
      ],
    );
  }
}
