import 'package:flutter/material.dart';
import 'package:medicalarm/features/medicines/components/add_button.dart';

class MedicinesPage extends StatelessWidget {
  const MedicinesPage({super.key});

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
