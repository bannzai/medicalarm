import 'package:flutter/material.dart';

class DiscountBadge extends StatelessWidget {
  final String text;

  const DiscountBadge({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.pinkAccent),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 10,
          color: Colors.white,
        ),
      ),
    );
  }
}
