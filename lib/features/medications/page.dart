import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/provider/medicine.dart';

class MedicationsPage extends HookConsumerWidget {
  const MedicationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicines = ref.watch(activeMedicinesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('服薬'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('服薬'),
            ],
          ),
        ),
      ),
    );
  }
}
