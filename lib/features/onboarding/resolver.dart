import 'dart:async';

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
  // createdDateTime はクライアント時計で生成されるため、端末時計が進んだ状態で作成したユーザーが後から時計を戻すと
  // 負の経過時間になる。その場合に既存ユーザーへ表示しないため、負の経過時間は表示対象外として扱う
  final age = now.difference(createdDateTime);
  return !age.isNegative && age < const Duration(days: 1);
}

/// 条件を満たす間 [OnboardingPage] を表示し、結果画面の CTA でペイウォール (既存のプレミアム紹介シート) を開く。
/// シートが閉じられたら完了として Firestore に記録し、[builder] (ホーム画面) へ進む。
/// [builder] には、このセッションでオンボーディングを完了したか (表示せず通過した場合は false) を渡す。
///
/// 表示判定は entitlement 以外の条件 (完了記録あり・既存ユーザー) を先に評価し、
/// 表示候補にならない場合は customerInfo を待たずに確定する。表示候補の場合だけ customerInfo の到着を
/// [customerInfoWaitTimeout] まで待ち、届かなければ非プレミアム扱いで判定する
class OnboardingResolver extends HookConsumerWidget {
  final AppUser appUser;

  /// 第 2 引数の didCompleteOnboardingInThisSession は、このセッションでオンボーディングを完了したかどうか。
  /// 完了直後に別の訴求を続けて出さない判断に使う
  final Widget Function(BuildContext context, bool didCompleteOnboardingInThisSession) builder;

  /// customerInfo の到着を待つ上限。
  /// RevenueCat は configure 直後にキャッシュ済みの CustomerInfo を listener へ即座に流すため通常は数百ms 以内に届く。
  /// オフラインでキャッシュも無い初回起動では届かないため、それ以上は待たず非プレミアム扱いで判定する
  static const customerInfoWaitTimeout = Duration(seconds: 3);

  const OnboardingResolver({
    super.key,
    required this.appUser,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerInfoAsync = ref.watch(customerInfoProvider);
    // 表示判定は一度確定させたら固定する。以後 appUser・customerInfo が更新されても再判定しない。
    // build 中に代入するため useState (setState during build になる) ではなく useRef に保持する
    final decision = useRef<bool?>(null);
    // 完了 (ペイウォールを閉じた) 後にホームへ進めるためのフラグ。判定自体は変えない
    final isCompleted = useState(false);
    // customerInfo の待ち時間が上限に達したか。hooks は early return より前に毎回同じ順序で呼ぶ
    final waitTimedOut = useState(false);
    // ペイウォールを開く処理が進行中か。CTA の連打で二重に開かないためのガード
    final isPaywallOpening = useRef(false);
    useEffect(() {
      // unmount 時に cancel されるため、破棄済みの ValueNotifier へ書き込まない
      final timer = Timer(customerInfoWaitTimeout, () => waitTimedOut.value = true);
      return timer.cancel;
    }, const []);
    final languageCode = Localizations.localeOf(context).languageCode;

    if (decision.value == null) {
      // entitlement 以外の条件だけで表示しないと決まる (完了記録あり・既存ユーザー) 場合は
      // customerInfo を待たずに確定する。待つとオフライン起動で customerInfo が届かず起動がブロックされるため
      final isCandidate = shouldPresentOnboarding(
        appUser: appUser,
        hasPremiumEntitlement: null,
        now: DateTime.now(),
      );
      if (!isCandidate) {
        decision.value = false;
      } else if (customerInfoAsync.isLoading && !waitTimedOut.value) {
        // 表示候補の時だけ customerInfo の到着を待つ。上限を過ぎたら待たずに判定する
        return const IndicatorPage();
      } else {
        // 未取得 (エラー・タイムアウト) は非プレミアム (null) 扱いで判定する
        decision.value = shouldPresentOnboarding(
          appUser: appUser,
          hasPremiumEntitlement: customerInfoAsync.asData?.value.hasPremiumEntitlement,
          now: DateTime.now(),
        );
      }
    }

    if (decision.value != true || isCompleted.value) {
      return builder(context, isCompleted.value);
    }

    final isShortForm = isShortFormOnboarding(languageCode: languageCode);
    return OnboardingPage(
      isShortForm: isShortForm,
      onPlanStartPressed: () async {
        // CTA の連打 (アクセシビリティ操作を含む) で showPremiumIntroductionSheet が 2 重に開き、完了イベント・完了記録が重複しないようにする
        if (isPaywallOpening.value) {
          return;
        }
        isPaywallOpening.value = true;
        try {
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
        } finally {
          isPaywallOpening.value = false;
        }
      },
    );
  }
}
