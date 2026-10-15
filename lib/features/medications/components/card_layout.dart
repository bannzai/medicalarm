import 'package:flutter/material.dart';
import 'package:medicalarm/style/color.dart';

/// 実際のお薬と未登録のプランに共通する時刻付きカードの外観。
class MedicationCardLayout extends StatelessWidget {
  /// カードの時刻見出し。
  final String time;

  /// 服用者とお薬、または登録案内。
  final Widget child;

  const MedicationCardLayout({super.key, required this.time, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(time, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 4),
            child,
          ],
        ),
      ),
    );
  }
}
