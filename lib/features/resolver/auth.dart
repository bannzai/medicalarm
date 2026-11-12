import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/onboarding_medication_plan.dart';
import 'package:medicalarm/utils/analytics/error.dart';
import 'package:medicalarm/utils/launch/launch_stage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
Stream<User?> firebaseUserChanges(Ref ref) {
  String? previousUserID;
  var receivedUser = false;
  // 認証境界では古いアカウントの通知を解除してから新しいユーザーを公開する。
  return FirebaseAuth.instance.userChanges().asyncMap((user) async {
    if (!receivedUser || previousUserID != user?.uid) {
      try {
        await traceLaunchStage(stage: 'cancelOnboardingMedicationPlanNotifications', operation: cancelOnboardingMedicationPlanNotifications);
      } catch (error, stackTrace) {
        // 補助通知の失敗で認証を止めない。初期化後とアプリ復帰時の同期でも解除を再試行する。
        errorLogger.recordError(error, stackTrace);
      }
    }
    previousUserID = user?.uid;
    receivedUser = true;
    return user;
  });
}

class AuthResolver extends HookConsumerWidget {
  final Widget Function(BuildContext, User) builder;

  const AuthResolver({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseUserChanges = ref.watch(firebaseUserChangesProvider);

    return Retry(
      retry: () => ref.invalidate(firebaseUserChangesProvider),
      child: () {
        return firebaseUserChanges.when(
          data: (user) {
            debugPrint('user.uid: ${user?.uid}');
            if (user == null) {
              return SignInResolver(
                firebaseAuth: FirebaseAuth.instance,
                builder: (context, user) => builder(context, user),
              );
            } else {
              return ProviderScope(
                overrides: [
                  appUserIDProvider.overrideWithValue(user.uid),
                ],
                child: builder(context, user),
              );
            }
          },
          error: (e, st) => RetryPage(exception: e),
          loading: () => const IndicatorPage(),
        );
      }(),
    );
  }
}

/// サインインしていない時に匿名サインインし、サインインしたユーザーで [builder] を描画する。
/// 匿名サインインが失敗した時は再試行の画面を出し、再試行の操作でサインインをやり直す (#582)。
class SignInResolver extends HookConsumerWidget {
  /// 匿名サインインに使う FirebaseAuth。widget test でモックに差し替えて、失敗と再試行を確かめるために受け取る。
  final FirebaseAuth firebaseAuth;
  final Widget Function(BuildContext, User) builder;

  const SignInResolver({super.key, required this.firebaseAuth, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = useState(firebaseAuth.currentUser);
    final userValue = user.value;
    // 直近の匿名サインインの失敗。null の間はサインインを試み、失敗中は再試行の操作を待つ。
    final signInError = useState<Object?>(null);
    final signInErrorValue = signInError.value;

    useEffect(() {
      void f() async {
        if (userValue == null && signInErrorValue == null) {
          try {
            final credential = await traceLaunchStage(stage: 'signInAnonymously', operation: firebaseAuth.signInAnonymously);
            // サインインの成功で AuthResolver が先の画面へ切り替えると、完了前にこの widget が破棄され state も破棄される
            if (context.mounted) {
              user.value = credential.user;
            }
          } catch (error, stackTrace) {
            errorLogger.recordError(error, stackTrace);
            if (context.mounted) {
              signInError.value = error;
            }
          }
        }
      }

      f();
      return null;
    }, [user.value, signInError.value]);

    if (userValue != null) {
      debugPrint('userValue: ${userValue.uid}');
      return ProviderScope(
        overrides: [
          appUserIDProvider.overrideWithValue(userValue.uid),
        ],
        child: builder(context, userValue),
      );
    }
    if (signInErrorValue != null) {
      return Retry(
        retry: () => signInError.value = null,
        child: RetryPage(exception: signInErrorValue),
      );
    }
    return const IndicatorPage();
  }
}
