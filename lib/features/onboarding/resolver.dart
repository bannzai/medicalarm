import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/app_user.dart';
import 'package:medicalarm/features/onboarding/page.dart';
import 'package:medicalarm/features/onboarding/steps.dart';
import 'package:medicalarm/features/preium_introduction/premium_introduction_sheet.dart';
import 'package:medicalarm/provider/onboarding.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/analytics/error.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';

/// 初回起動時にオンボーディングを表示する条件。
/// - 完了記録 (onboardingCompletedDateTime) が無い
/// - プレミアム (トライアル含む) でない
/// - AppUser 作成から 1 日以内 (既存ユーザーにはこの機能のリリース後も表示しない。再インストールでも匿名ユーザーは Keychain から復元されるため再表示されない)
bool shouldPresentOnboarding({
  required AppUser appUser,
  required bool? hasPremiumEntitlement,
  required DateTime now,
}) {
  if (appUser.onboardingCompletedDateTime != null) {
    return false;
  }
  if (hasPremiumEntitlement == true) {
    return false;
  }
  final createdDateTime = appUser.createdDateTime;
  if (createdDateTime == null) {
    return false;
  }
  return now.difference(createdDateTime) < const Duration(days: 1);
}

/// 条件を満たす間 [OnboardingPage] を表示し、結果画面の CTA でペイウォール (既存のプレミアム紹介シート) を開く。
/// シートが閉じられたら完了として Firestore に記録し、[builder] (ホーム画面) へ進む
class OnboardingResolver extends HookConsumerWidget {
  final AppUser appUser;
  final WidgetBuilder builder;

  const OnboardingResolver({
    super.key,
    required this.appUser,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerInfo = ref.watch(customerInfoProvider).asData?.value;
    // PromotionStartResolver と同じく初回 build で判定を固定し、完了書き込みによる appUser の更新で再判定しない
    final isPresented = useState(shouldPresentOnboarding(
      appUser: appUser,
      hasPremiumEntitlement: customerInfo?.hasPremiumEntitlement,
      now: DateTime.now(),
    ));

    if (!isPresented.value) {
      return builder(context);
    }

    final isShortForm = isShortFormOnboarding(languageCode: Localizations.localeOf(context).languageCode);
    return OnboardingPage(
      isShortForm: isShortForm,
      onPlanStartPressed: () async {
        final onboardingComplete = ref.read(onboardingCompleteProvider);
        analytics.logEvent(name: 'onboarding_paywall_shown');
        await showPremiumIntroductionSheet(context);
        analytics.logEvent(name: 'onboarding_paywall_closed');
        analytics.logEvent(name: 'onboarding_completed', parameters: {'form': isShortForm ? 'short' : 'long'});
        isPresented.value = false;
        try {
          await onboardingComplete();
        } catch (error, stackTrace) {
          // 完了記録に失敗してもホームへは進める。記録が無いままなら次回起動 (作成から 1 日以内) に再表示される
          errorLogger.recordError(error, stackTrace);
        }
      },
    );
  }
}
