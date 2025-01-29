import 'package:flutter/material.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/features/medicine_form/components/additional_info/dose_receiver.dart';
import 'package:medicalarm/features/medicine_form/components/additional_info/memo.dart';
import 'package:medicalarm/features/medicine_form/components/section_layout.dart';
import 'package:medicalarm/features/localization/l.dart';

class MedicineAdditionalInfoSection extends StatelessWidget {
  final ValueNotifier<String> memo;
  final ValueNotifier<String> memoImageURL;
  final ValueNotifier<DoseReceiver?> doseReceiver;

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
      text: L.otherInformation,
      children: [
        MedicineDoseReceiverTile(doseReceiver: doseReceiver),
        const SizedBox(height: 6),
        MedicineMemoRow(memo: memo, memoImageURL: memoImageURL),
      ],
    );
  }
}
