import 'package:flutter/material.dart';

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
