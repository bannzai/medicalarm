import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/entity/app_user.dart';
import 'package:medicalarm/features/onboarding/page.dart';
import 'package:medicalarm/features/onboarding/steps.dart';
import 'package:medicalarm/features/preium_introduction/premium_introduction_sheet.dart';
import 'package:medicalarm/provider/onboarding.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/analytics/error.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';

/// 初回起動時にオンボーディングを表示する条件。
/// - 端末の言語で文言が翻訳済み ([isOnboardingAvailable])
/// - 完了記録 (onboardingCompletedDateTime) が無い
/// - プレミアム (トライアル含む) でない
/// - AppUser 作成から 1 日以内 (既存ユーザーにはこの機能のリリース後も表示しない。再インストールでも匿名ユーザーは Keychain から復元されるため再表示されない)
bool shouldPresentOnboarding({
  required AppUser appUser,
  required bool? hasPremiumEntitlement,
  required DateTime now,
  required bool isAvailable,
}) {
  if (!isAvailable) {
    return false;
  }
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
    final customerInfoAsync = ref.watch(customerInfoProvider);
    // 表示判定は customerInfo の初回取得を待ってから固定する。以後 appUser・customerInfo が更新されても再判定しない。
    // build 中に代入するため useState (setState during build になる) ではなく useRef に保持する
    final decision = useRef<bool?>(null);
    // 完了 (ペイウォールを閉じた) 後にホームへ進めるためのフラグ。判定自体は変えない
    final isCompleted = useState(false);
    final languageCode = Localizations.localeOf(context).languageCode;

    // customerInfo が取得中の間は判定できないためローディングを出す。エラー時は非プレミアム (null) 扱いで判定する
    if (decision.value == null) {
      if (customerInfoAsync.isLoading) {
        return const IndicatorPage();
      }
      decision.value = shouldPresentOnboarding(
        appUser: appUser,
        hasPremiumEntitlement: customerInfoAsync.asData?.value.hasPremiumEntitlement,
        now: DateTime.now(),
        isAvailable: isOnboardingAvailable(languageCode: languageCode),
      );
    }

    if (decision.value != true || isCompleted.value) {
      return builder(context);
    }

    final isShortForm = isShortFormOnboarding(languageCode: languageCode);
    return OnboardingPage(
      isShortForm: isShortForm,
      onPlanStartPressed: () async {
        final onboardingComplete = ref.read(onboardingCompleteProvider);
        analytics.logEvent(name: 'onboarding_paywall_shown');
        await showPremiumIntroductionSheet(context);
        analytics.logEvent(name: 'onboarding_paywall_closed');
        analytics.logEvent(name: 'onboarding_completed', parameters: {'form': isShortForm ? 'short' : 'long'});
        isCompleted.value = true;
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
