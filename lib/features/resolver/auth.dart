import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/onboarding_medication_plan.dart';
import 'package:medicalarm/utils/analytics/error.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
Stream<User?> firebaseUserChanges(FirebaseUserChangesRef ref) {
  String? previousUserID;
  var receivedUser = false;
  // 認証境界では古いアカウントの通知を解除してから新しいユーザーを公開する。
  return FirebaseAuth.instance.userChanges().asyncMap((user) async {
    if (!receivedUser || previousUserID != user?.uid) {
      try {
        await cancelOnboardingMedicationPlanNotifications();
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

class SignInResolver extends HookConsumerWidget {
  final Widget Function(BuildContext, User) builder;

  const SignInResolver({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = useState(FirebaseAuth.instance.currentUser);
    final userValue = user.value;

    useEffect(() {
      void f() async {
        if (userValue == null) {
          try {
            final credential = await FirebaseAuth.instance.signInAnonymously();
            user.value = credential.user;
          } catch (e) {
            debugPrint('error: $e');
          }
        }
      }

      f();
      return null;
    }, [user.value]);

    if (userValue == null) {
      return const IndicatorPage();
    } else {
      debugPrint('userValue: ${userValue.uid}');
      return ProviderScope(
        overrides: [
          appUserIDProvider.overrideWithValue(userValue.uid),
        ],
        child: builder(context, userValue),
      );
    }
  }
}
