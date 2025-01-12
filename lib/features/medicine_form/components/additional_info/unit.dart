import 'package:flutter/material.dart';

class MedicineUnitTextField extends StatelessWidget {
  final ValueNotifier<String> unit;
  const MedicineUnitTextField({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextFormField(
        initialValue: unit.value,
        onChanged: (value) {
          unit.value = value;
        },
        decoration: const InputDecoration(
          hintText: '錠,ml,gなど',
          labelText: '単位',
        ),
      ),
    );
  }
}
