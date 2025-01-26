import 'package:async_value_group/async_value_group.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medicine.dart';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (customerInfo.activeSubscriptions.isNotEmpty) ...[
                const SizedBox(height: 32),
                const PremiumUserThanksRow(),
              ],
              if (customerInfo.activeSubscriptions.isEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      border: Border.all(
                        width: 0.4,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    child: DefaultTextStyle(
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.remove_red_eye),
                              SizedBox(width: 8),
                              Text('広告の非表示'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(Icons.history),
                              SizedBox(width: 8),
                              Text('服用履歴をすべて表示'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.medication),
                              const SizedBox(width: 8),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: '薬の登録数を',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: '${Medicine.maxCount(isPremium: false)} → ${Medicine.maxCount(isPremium: true)}',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.schedule),
                              const SizedBox(width: 8),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: '通知のスケジュール数を',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: '${MedicationSchedule.maxCount(isPremium: false)} → ${MedicationSchedule.maxCount(isPremium: true)}',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.person),
                              const SizedBox(width: 8),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: '服用者の登録数を',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: '${DoseReceiver.maxCount(isPremium: false)} → ${DoseReceiver.maxCount(isPremium: true)}',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
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
