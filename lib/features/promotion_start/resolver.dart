import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/app_user.dart';
import 'package:medicalarm/features/promotion_start/page.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/remote_config_parameter.dart';
import 'package:medicalarm/provider/start_promotion.dart';
import 'package:medicalarm/utils/config/environment.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';

class PromotionStartResolver extends HookConsumerWidget {
  final AppUser appUser;
  const PromotionStartResolver({
    super.key,
    required this.appUser,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerInfo = ref.watch(customerInfoProvider).asData?.value;
    final promotionStartPageCancelButtonTappedDateTime = useState(appUser.promotionStartPageCancelButtonTappedDateTime);

    // useStateを使用して状態を管理
    final promotionStartPageIsPresented = useState(false);
    final remoteConfigParameter = ref.watch(remoteConfigParameterProvider);

    // コンポーネントのマウント時に一度だけ実行
    useEffect(() {
      if (!Environment.isProduction) {
        return null;
      }

      if (customerInfo?.entitlements.all[premiumEntitlementIdentifier]?.isActive == true) {
        return null;
      }

      final promotionStartPageCancelButtonTappedDateTimeValue = promotionStartPageCancelButtonTappedDateTime.value;
      // キャンセルボタンが押されていない、または7日間以上経過している場合
      if (promotionStartPageCancelButtonTappedDateTimeValue == null ||
          promotionStartPageCancelButtonTappedDateTimeValue.add(const Duration(days: 7)).isBefore(DateTime.now())) {
        // trialDeadlineDateがnullの場合（有料版を使ったことがない場合）に表示
        promotionStartPageIsPresented.value = appUser.maybeTrialDeadlineDate == null;
      }

      return null;
    }, [appUser, customerInfo]);

    if (promotionStartPageIsPresented.value) {
      return PromotionStartPage(
        onStartPromotion: () async {
          await ref.read(startPromotionProvider).call(promotionDayCount: remoteConfigParameter.promotionDayCount);
          promotionStartPageIsPresented.value = false;
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
