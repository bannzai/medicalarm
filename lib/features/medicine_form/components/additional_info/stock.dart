import 'package:flutter/material.dart';
import 'package:medicalarm/components/container/flat_tile.dart';
import 'package:medicalarm/components/picker/number.dart';

class MedicineStockTile extends StatelessWidget {
  final String unit;
  final ValueNotifier<int> stock;
  const MedicineStockTile({super.key, required this.unit, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: FlatTile(
        child: ListTile(
          title: unit.isEmpty ? const Text('在庫') : Text('在庫($unit)'),
          trailing: Wrap(
            spacing: 4,
            children: [
              Text(stock.value.toString()),
              const Icon(Icons.chevron_right),
            ],
          ),
          onTap: () async {
            final result = await showAppNumberPicker(
              context,
              initialNumber: stock.value,
            );
            if (result != null) {
              stock.value = result;
            }
          },
        ),
      ),
    );
  }
}
