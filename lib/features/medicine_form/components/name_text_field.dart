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
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: TextFormField(
        maxLines: 2,
        maxLength: 50,
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
