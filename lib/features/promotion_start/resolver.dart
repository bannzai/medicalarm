import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/app_user.dart';
import 'package:medicalarm/features/promotion_start/page.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/remote_config_parameter.dart';
import 'package:medicalarm/provider/start_promotion.dart';
import 'package:medicalarm/secret/secret.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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
    final appUserID = ref.watch(appUserIDProvider);

    final remoteConfigParameter = ref.watch(remoteConfigParameterProvider);
    final promotionStartPageIsPresented = useState(customerInfo?.hasPremiumEntitlement != true &&
        promotionStartPageCancelButtonTappedDateTime.value.add(const Duration(days: 7)).isBefore(DateTime.now()) &&
        appUser.maybeTrialDeadlineDate == null &&
        appUser.createdDateTime != null &&
        appUser.createdDateTime!.add(const Duration(days: 1)).isBefore(DateTime.now()));

    if (promotionStartPageIsPresented.value) {
      return PromotionStartPage(
        onStartPromotion: () async {
          await ref.read(startPromotionProvider).call(promotionDayCount: remoteConfigParameter.promotionDayCount);
          // サーバーからcustomerInfoを再取得して、promotionの状態を反映させる。しかし、FlutterのRevenueCatのSDKでlistenerを設定し直しても(ref.invalidate)、内部のキャッシュが返ってくる
          // なので、configureを呼び出して、キャッシュを更新する。エラーは無視する
          await Purchases.configure(PurchasesConfiguration(Secret.revenueCatPublicAPIKey)..appUserID = appUserID);
          ref.invalidate(customerInfoProvider);

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

    return builder(context);
  }
}
