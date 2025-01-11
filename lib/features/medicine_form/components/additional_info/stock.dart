import 'package:flutter/material.dart';
import 'package:medicalarm/components/picker/number.dart';

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
