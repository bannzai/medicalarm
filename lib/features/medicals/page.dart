import 'package:flutter/material.dart';

class MedicalsPage extends StatelessWidget {
  const MedicalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('お薬'),
      ),
      body: const Text('Medical'),
    );
  }
}
