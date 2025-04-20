import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/promotion_start/page.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/shared_preferences.dart';
import 'package:medicalarm/utils/config/environment.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'resolver.g.dart';

@Riverpod(dependencies: [sharedPreferences])
class PromotionStartPageCancelButtonTappedDateTimeInterval extends _$PromotionStartPageCancelButtonTappedDateTimeInterval {
  static const _key = 'PromotionStartPageCancelButtonTappedDateTimeInterval';

  @override
  double build() {
    final sp = ref.watch(sharedPreferencesProvider);
    return sp.getDouble(_key) ?? 0.0;
  }

  Future<void> update(double value) async {
    final sp = ref.read(sharedPreferencesProvider);
    await sp.setDouble(_key, value);
    state = value;
  }
}

class PromotionStartResolver extends HookConsumerWidget {
  const PromotionStartResolver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(appUserProvider).asData?.value;
    final customerInfo = ref.watch(customerInfoProvider).asData?.value;
    final promotionStartPageCancelButtonTappedDateTimeInterval = ref.watch(promotionStartPageCancelButtonTappedDateTimeIntervalProvider);

    final promotionStartPageCancelButtonTappedDate =
        DateTime.fromMillisecondsSinceEpoch((promotionStartPageCancelButtonTappedDateTimeInterval * 1000).toInt());

    final promotionStartPageIsPresentedNotifier = useState(false);
    final promotionStartPageIsPresented = promotionStartPageIsPresentedNotifier.value;

    // コンポーネントのマウント時に一度だけ実行
    useEffect(() {
      if (!Environment.isProduction) {
        return null;
      }

      if (customerInfo?.entitlements.all[premiumEntitlementIdentifier]?.isActive == true) {
        return null;
      }

      // 7日間キャンセルボタンを押さなかった場合
      final cancelThresholdDate = promotionStartPageCancelButtonTappedDate.add(const Duration(days: 7));
      if (cancelThresholdDate.isBefore(DateTime.now())) {
        // trialDeadlineがnullの場合（有料版を使ったことがない場合）に表示
        promotionStartPageIsPresentedNotifier.value = appUser?.maybeTrialDeadlineDate == null;
      }

      return null;
    }, []);

    if (promotionStartPageIsPresented) {
      return PromotionStartPage(
        onStartPromotion: () {
          promotionStartPageIsPresentedNotifier.value = false;
        },
        onCancel: () {
          promotionStartPageIsPresentedNotifier.value = false;
          ref.read(promotionStartPageCancelButtonTappedDateTimeIntervalProvider.notifier).update(DateTime.now().millisecondsSinceEpoch / 1000);
        },
      );
    }

    return const SizedBox.shrink(); // 透明なウィジェットを返す
  }
}

extension AppUserExtension on AppUser {
  DateTime? get maybeTrialDeadlineDate {
    // AppUserクラスに対して、trial期限を取得するメソッド
    // 実際の実装はプロジェクトによりますが、ここではnullを返します
    return null;
  }
}
