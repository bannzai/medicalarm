import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/features/preium_introduction/components/discount_badge.dart';
import 'package:medicalarm/features/preium_introduction/components/six_month_purchase_button.dart';
import 'package:medicalarm/features/preium_introduction/components/monthly_purchase_button.dart';
import 'package:medicalarm/features/preium_introduction/components/weekly_purchase_button.dart';
import 'package:medicalarm/features/preium_introduction/premium_complete_dialog.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';

class PurchaseButtons extends HookConsumerWidget {
  final OfferingType offeringType;
  final Package weeklyPackage;
  final Package monthlyPackage;
  final Package sixMonthPackage;
  final ValueNotifier<bool> isLoading;

  const PurchaseButtons({
    super.key,
    required this.offeringType,
    required this.weeklyPackage,
    required this.monthlyPackage,
    required this.sixMonthPackage,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchase = ref.watch(purchaseProvider);
    final maxMonthlyDiscountBadgePercent = ((1 - (monthlyPackage.storeProduct.price / (weeklyPackage.storeProduct.price * 5))) * 100).toInt();
    final sixMonthDiscountBadgePercent = ((1 - (sixMonthPackage.storeProduct.price / (monthlyPackage.storeProduct.price * 6))) * 100).toInt();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: WeeklyPurchaseButton(
            weeklyPackage: weeklyPackage,
            onTap: (weeklyPackage) async {
              analytics.logEvent(name: "pressed_weekly_purchase_button");
              await _purchase(context, weeklyPackage, purchase);
            },
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              MonthlyPurchaseButton(
                monthlyPackage: monthlyPackage,
                onTap: (monthlyPackage) async {
                  analytics.logEvent(name: "pressed_monthly_purchase_button");
                  await _purchase(context, monthlyPackage, purchase);
                },
              ),
              Positioned(
                top: -6,
                right: 8,
                child: DiscountBadge(
                  text: "週額より最大$maxMonthlyDiscountBadgePercent%OFF",
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SixMonthPurchaseButton(
                sixMonthPackage: sixMonthPackage,
                offeringType: offeringType,
                onTap: (sixMonthPackage) async {
                  analytics.logEvent(name: "pressed_six_m_purchase_button");
                  await _purchase(context, sixMonthPackage, purchase);
                },
              ),
              Positioned(
                top: -6,
                right: 8,
                child: DiscountBadge(
                  text: "月額より$sixMonthDiscountBadgePercent%OFF",
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
