import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/app_user.dart';
import 'package:medicalarm/features/promotion_start/page.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/remote_config_parameter.dart';
import 'package:medicalarm/provider/start_promotion.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';

class PromotionStartResolver extends HookConsumerWidget {
  final AppUser appUser;
  final WidgetBuilder builder;
  const PromotionStartResolver({
    super.key,
    required this.appUser,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerInfo = ref.watch(customerInfoProvider).asData?.value;
    final promotionStartPageCancelButtonTappedDateTime =
        useState(appUser.promotionStartPageCancelButtonTappedDateTime ?? DateTime.fromMillisecondsSinceEpoch(0));

    final remoteConfigParameter = ref.watch(remoteConfigParameterProvider);
    final promotionStartPageIsPresented = useState(customerInfo?.hasPremiumEntitlement != true &&
        promotionStartPageCancelButtonTappedDateTime.value.add(const Duration(days: 7)).isBefore(DateTime.now()) &&
        appUser.maybeTrialDeadlineDate == null);

    if (promotionStartPageIsPresented.value) {
      return PromotionStartPage(
        onStartPromotion: () async {
          promotionStartPageIsPresented.value = false;
          await ref.read(startPromotionProvider).call(promotionDayCount: remoteConfigParameter.promotionDayCount);
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

    return builder(context);
  }
}
