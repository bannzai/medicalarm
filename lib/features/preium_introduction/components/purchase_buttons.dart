import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/preium_introduction/components/annual_purchase_button.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/features/preium_introduction/components/discount_badge.dart';
import 'package:medicalarm/features/preium_introduction/components/monthly_purchase_button.dart';
import 'package:medicalarm/features/preium_introduction/premium_complete_dialog.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';

class PurchaseButtons extends HookConsumerWidget {
  final OfferingType offeringType;
  final Package monthlyPackage;
  final Package annualPackage;
  final ValueNotifier<bool> isLoading;

  const PurchaseButtons({
    super.key,
    required this.offeringType,
    required this.monthlyPackage,
    required this.annualPackage,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchase = ref.watch(purchaseProvider);
    final annualhDiscountBadgePercent = ((1 - (annualPackage.storeProduct.price / (monthlyPackage.storeProduct.price * 12))) * 100).toInt();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: MonthlyPurchaseButton(
            monthlyPackage: monthlyPackage,
            onTap: (monthlyPackage) async {
              analytics.logEvent(name: "pressed_monthly_purchase_button");
              await _purchase(context, monthlyPackage, purchase);
            },
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnnualPurchaseButton(
                annualPackage: annualPackage,
                onTap: (annualPackage) async {
                  analytics.logEvent(name: "pressed_annual_purchase_button");
                  await _purchase(context, monthlyPackage, purchase);
                },
              ),
              Positioned(
                top: -6,
                right: 8,
                child: DiscountBadge(
                  text: "月額より$annualhDiscountBadgePercent%OFF",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _purchase(BuildContext context, Package package, Purchase purchase) async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;
    try {
      final shouldShowCompleteDialog = await purchase(package);
      if (shouldShowCompleteDialog) {
        if (context.mounted) {
          showDialog(
              context: context,
              builder: (_) {
                return PremiumCompleteDialog(onClose: () {
                  Navigator.of(context).pop();
                });
              });
        }
      }
    } catch (error) {
      debugPrint("caused purchase error for $error");
      if (context.mounted) showErrorAlert(context, error);
    } finally {
      isLoading.value = false;
    }
  }
}
