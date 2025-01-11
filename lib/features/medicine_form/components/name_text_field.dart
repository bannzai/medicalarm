import 'package:flutter/material.dart';

class MedicineFormNameTextField extends StatelessWidget {
  const MedicineFormNameTextField({
    super.key,
    required this.name,
  });

  final ValueNotifier<String> name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      child: TextFormField(
        initialValue: name.value,
        onChanged: (value) {
          name.value = value;
        },
        decoration: const InputDecoration(
          hintText: '薬の名前',
        ),
      ),
    );
  }
}
