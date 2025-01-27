import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class AnnualPurchaseButton extends StatelessWidget {
  final Package annualPackage;
  final Function(Package) onTap;

  const AnnualPurchaseButton({
    super.key,
    required this.annualPackage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(annualPackage);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          border: Border.all(
            width: 2,
            color: Colors.grey.shade500,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '年額プラン',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              annualPackage.storeProduct.priceString,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
