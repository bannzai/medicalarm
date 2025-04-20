import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/app_user.dart';
import 'package:medicalarm/features/promotion_start/page.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/app_user.dart';
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

    // useStateを使用して状態を管理
    final promotionStartPageIsPresented = useState(false);

    // コンポーネントのマウント時に一度だけ実行
    useEffect(() {
      if (!Environment.isProduction) {
        return null;
      }

      if (customerInfo?.entitlements.all[premiumEntitlementIdentifier]?.isActive == true) {
        return null;
      }

      final cancelDateTime = appUser?.promotionStartPageCancelButtonTappedDateTime;

      // キャンセルボタンが押されていない、または7日間以上経過している場合
      if (cancelDateTime == null || cancelDateTime.add(const Duration(days: 7)).isBefore(DateTime.now())) {
        // trialDeadlineDateがnullの場合（有料版を使ったことがない場合）に表示
        promotionStartPageIsPresented.value = appUser?.trialDeadlineDate == null;
      }

      return null;
    }, [appUser, customerInfo]);

    if (promotionStartPageIsPresented.value) {
      return PromotionStartPage(
        onStartPromotion: () {
          promotionStartPageIsPresented.value = false;
          // ここでユーザーにtrial期間を付与する処理を実装
        },
        onCancel: () async {
          promotionStartPageIsPresented.value = false;

          // AppUserのpromotionStartPageCancelButtonTappedDateTimeを更新
          final userDatabase = ref.read(userDatabaseProvider);
          await userDatabase.userReference().update({
            'promotionStartPageCancelButtonTappedDateTime': DateTime.now(),
          });
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
