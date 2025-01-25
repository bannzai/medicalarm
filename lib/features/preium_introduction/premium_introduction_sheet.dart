import 'package:async_value_group/async_value_group.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/features/preium_introduction/components/premium_introduction_footer.dart';
import 'package:medicalarm/features/preium_introduction/components/premium_introduction_header.dart';
import 'package:medicalarm/features/preium_introduction/components/premium_user_thanks.dart';
import 'package:medicalarm/features/preium_introduction/components/purchase_buttons.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';

class PremiumIntroductionSheet extends HookConsumerWidget {
  const PremiumIntroductionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Retry(
      retry: () {
        ref.invalidate(customerInfoProvider);
        ref.invalidate(offeringsProvider);
      },
      child: AsyncValueGroup.group2(
        ref.watch(customerInfoProvider),
        ref.watch(offeringsProvider),
      ).when(
        data: (data) => _Body(
          customerInfo: data.$1,
          offerings: data.$2,
        ),
        error: (error, stackTrace) => RetryPage(exception: error),
        loading: () => const IndicatorPage(),
      ),
    );
  }
}

class _Body extends HookConsumerWidget {
  final CustomerInfo customerInfo;
  final Offerings offerings;

  const _Body({
    required this.customerInfo,
    required this.offerings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offeringType = customerInfo.currentOfferingType;
    final monthlyPackage = ref.watch(monthlyPackageProvider);
    final annualPackage = ref.watch(annualPackageProvider);
    final isLoading = useState(false);

    if (monthlyPackage == null || annualPackage == null) {
      return const IndicatorPage();
    }
    if (isLoading.value) {
      const IndicatorPage();
    }

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(color: Colors.black),
        title: const PremiumIntroductionHeader(),
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        elevation: 1,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (customerInfo.activeSubscriptions.isNotEmpty) ...[
                const SizedBox(height: 32),
                const PremiumUserThanksRow(),
              ],
              if (customerInfo.activeSubscriptions.isEmpty) ...[
                const Text(
                  """
  ＿人人人人人人人人＿
＞　AI機能使い放題　＜
￣Y^Y^Y^Y^Y^Y^Y^￣
                 """,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                PurchaseButtons(
                  offeringType: offeringType,
                  monthlyPackage: monthlyPackage,
                  annualPackage: annualPackage,
                  isLoading: isLoading,
                ),
              ],
              const SizedBox(height: 24),
              PremiumIntroductionFotter(
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showPremiumIntroductionSheet(BuildContext context) async {
  analytics.setCurrentScreen(screenName: "PremiumIntroductionSheet");

  await showModalBottomSheet(
    context: context,
    builder: (_) => const PremiumIntroductionSheet(),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useSafeArea: true,
  );
}
