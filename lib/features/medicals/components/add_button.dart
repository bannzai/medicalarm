import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/style/button.dart';
import 'package:medicalarm/style/color.dart';

class MedicalAddButton extends HookConsumerWidget {
  const MedicalAddButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('お薬を追加'),
        style: textButtonStyle,
      ),
    );
  }
}
