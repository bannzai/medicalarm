import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/medicine_form/page.dart';
import 'package:medicalarm/features/resolver/app_resolvers.dart';
import 'package:medicalarm/style/button.dart';

class MedicalAddButton extends HookConsumerWidget {
  const MedicalAddButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextButton.icon(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => AppResolvers(
              builder: (context, user) {
                return const MedicineFormPage(medicine: null);
              },
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('お薬を追加'),
        style: textButtonStyle,
      ),
    );
  }
}
