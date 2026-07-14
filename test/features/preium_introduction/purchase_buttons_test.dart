import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/preium_introduction/components/annual_purchase_button.dart';
import 'package:medicalarm/features/preium_introduction/components/monthly_purchase_button.dart';
import 'package:medicalarm/features/preium_introduction/components/purchase_buttons.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// 購入処理に渡された Package を記録する Purchase。テストで実課金 (Purchases.purchasePackage) を発生させないために使用する
class _RecordingPurchase extends Purchase {
  Package? purchasedPackage;

  @override
  Future<bool> call(Package package) async {
    purchasedPackage = package;
    return false;
  }
}

/// テスト用の Package を組み立てる
Package _buildPackage({required String identifier, required PackageType packageType, required double price}) {
  return Package(
    identifier,
    packageType,
    StoreProduct(identifier, '', identifier, price, '¥$price', 'JPY'),
    const PresentedOfferingContext('Premium', null, null),
  );
}

void main() {
  final monthlyPackage = _buildPackage(identifier: 'monthly', packageType: PackageType.monthly, price: 300);
  final annualPackage = _buildPackage(identifier: 'annual', packageType: PackageType.annual, price: 3000);

  /// PurchaseButtons を purchaseProvider の差し替え付きで表示する
  Future<void> pumpPurchaseButtons(WidgetTester tester, {required _RecordingPurchase purchase}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [purchaseProvider.overrideWithValue(purchase)],
        child: MaterialApp(
          home: Scaffold(
            body: PurchaseButtons(
              offeringType: OfferingType.premium,
              monthlyPackage: monthlyPackage,
              annualPackage: annualPackage,
              isLoading: ValueNotifier(false),
            ),
          ),
        ),
      ),
    );
  }

  // issue #248: 年額プランボタンのタップで monthlyPackage が購入される不具合の回帰テスト
  testWidgets('年額プランボタンをタップすると年額パッケージが購入処理に渡される', (tester) async {
    final purchase = _RecordingPurchase();
    await pumpPurchaseButtons(tester, purchase: purchase);

    await tester.tap(find.byType(AnnualPurchaseButton));
    await tester.pump();

    expect(purchase.purchasedPackage, annualPackage);
  });

  testWidgets('月額プランボタンをタップすると月額パッケージが購入処理に渡される', (tester) async {
    final purchase = _RecordingPurchase();
    await pumpPurchaseButtons(tester, purchase: purchase);

    await tester.tap(find.byType(MonthlyPurchaseButton));
    await tester.pump();

    expect(purchase.purchasedPackage, monthlyPackage);
  });
}
