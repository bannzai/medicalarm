import 'dart:math';

import 'package:flutter/material.dart';

const double keyboardToolbarHeight = 44;

class KeyboardToolbar extends StatelessWidget {
  final Widget doneButton;
  const KeyboardToolbar({super.key, required this.doneButton});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: keyboardToolbarHeight,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              const Spacer(),
              doneButton,
              const SizedBox(width: 10),
            ],
          ),
        ),
        // キーボードを閉じる途中に viewInsets.bottom が負の値で届くことがあり (nightly E2E の run 44148328382 で h=-179.8 を観測)、
        // 負の高さの SizedBox は debug で例外になって `_dependents.isEmpty` の赤画面に至るため 0 で止める (#387)。
        // 負になる原因は iOS の engine のキーボードのアニメーションの補間と考えているが未確認
        SizedBox(height: max(0.0, MediaQuery.of(context).viewInsets.bottom)),
      ],
    );
  }
}
