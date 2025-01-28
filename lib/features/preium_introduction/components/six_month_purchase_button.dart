import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';
import 'package:medicalarm/features/localization/l.dart';

class SixMonthPurchaseButton extends StatelessWidget {
  final Package sixMonthPackage;
  final OfferingType offeringType;
  final Function(Package) onTap;

  const SixMonthPurchaseButton({
    super.key,
    required this.sixMonthPackage,
    required this.offeringType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final monthlyPrice = sixMonthPackage.storeProduct.price / 6;
    Locale locale = Localizations.localeOf(context);
    final monthlyPriceString = NumberFormat.simpleCurrency(locale: locale.toString(), decimalDigits: 0).format(monthlyPrice);

    return GestureDetector(
      onTap: () {
        onTap(sixMonthPackage);
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
            Text(
              L.sixMonthPlan,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Column(
              children: [
                Text(
                  sixMonthPackage.storeProduct.priceString,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  L.premiumPricePerMonth(monthlyPriceString),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
