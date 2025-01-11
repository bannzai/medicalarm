import 'package:flutter/material.dart';
import 'package:medicalarm/components/picker/number.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/dose_receiver_form/page.dart';
import 'package:medicalarm/features/medicine_form/components/section_layout.dart';

class MedicineAdditionalInfoSection extends StatelessWidget {
  final ValueNotifier<String> memo;
  final ValueNotifier<String> memoImageURL;
  final ValueNotifier<MedicineDoseReceiver> doseReceiver;
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
        MedicineMemoRow(memo: memo, memoImageURL: memoImageURL),
        MedicineDoseReceiverTile(doseReceiver: doseReceiver),
        MedicineUnitTextField(unit: unit),
        MedicineStockTile(unit: unit.value, stock: stock),
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

class MedicineDoseReceiverTile extends StatelessWidget {
  final ValueNotifier<MedicineDoseReceiver> doseReceiver;
  const MedicineDoseReceiverTile({super.key, required this.doseReceiver});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      child: ListTile(
        title: const Text('服用者'),
        trailing: Wrap(
          children: [
            Text(doseReceiver.value.name),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoseReceiverFormPage(
                doseReceiver: doseReceiver,
              ),
            ),
          );
        },
      ),
    );
  }
}

class MedicineUnitTextField extends StatelessWidget {
  final ValueNotifier<String> unit;
  const MedicineUnitTextField({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: unit.value,
      onChanged: (value) {
        unit.value = value;
      },
      decoration: const InputDecoration(
        hintText: '単位',
      ),
    );
  }
}

class MedicineStockTile extends StatelessWidget {
  final String unit;
  final ValueNotifier<int> stock;
  const MedicineStockTile({super.key, required this.unit, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      child: ListTile(
        title: unit.isEmpty ? const Text('在庫') : Text('在庫($unit)'),
        trailing: Wrap(
          children: [
            Text(stock.value.toString()),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () async {
          final result = await showAppNumberPicker(context, initialNumber: stock.value);
          if (result != null) {
            stock.value = result;
          }
        },
      ),
    );
  }
}
