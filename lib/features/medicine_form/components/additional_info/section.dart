import 'package:flutter/material.dart';
import 'package:medicalarm/features/medicine_form/components/section_layout.dart';

class MedicineAdditionalInfoSection extends StatelessWidget {
  final ValueNotifier<String> memo;
  final ValueNotifier<String> memoImageURL;
  final ValueNotifier<String> doseReceiverName;
  final ValueNotifier<String> unit;
  final ValueNotifier<int> stock;

  const MedicineAdditionalInfoSection({
    super.key,
    required this.memo,
    required this.memoImageURL,
    required this.doseReceiverName,
    required this.unit,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    return MedicineFormSectionLayout(
      icon: Icons.info,
      text: 'その他',
      children: [
        MedicineMemoRow(memo: memo, memoImageURL: memoImageURL),
        MedicineDoseReceiverNameTextField(doseReceiverName: doseReceiverName),
        MedicineUnitTextField(unit: unit),
        MedicineStockTextField(stock: stock),
      ],
    );
  }
}

class MedicineMemoRow extends StatelessWidget {
  final ValueNotifier<String> memo;
  final ValueNotifier<String> memoImageURL;
  const MedicineMemoRow({
    super.key,
    required this.memo,
    required this.memoImageURL,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: memoImageURL.value.isNotEmpty ? Image.network(memoImageURL.value) : const Icon(Icons.add_a_photo),
          ),
          TextFormField(
            initialValue: memo.value,
            onChanged: (value) {
              memo.value = value;
            },
            decoration: const InputDecoration(
              hintText: 'メモ',
            ),
          ),
        ],
      ),
    );
  }
}
