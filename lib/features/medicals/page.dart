import 'package:flutter/material.dart';
import 'package:medicalarm/features/medicals/components/add_button.dart';

class MedicalsPage extends StatelessWidget {
  const MedicalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('お薬'),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MedicalAddButton(),
        ],
      ),
    );
  }
}
