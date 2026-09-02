import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/app_user.dart';
import 'package:medicalarm/features/onboarding/resolver.dart';

void main() {
  final now = DateTime(2026, 9, 2, 12);

  // 初回起動のオンボーディングを出す条件 (完了記録なし・非プレミアム・AppUser 作成から 1 日以内) を検証する
  group('shouldPresentOnboarding', () {
    test('作成直後で完了記録が無い非プレミアムユーザーには表示する', () {
      expect(
        shouldPresentOnboarding(appUser: AppUser(createdDateTime: now), hasPremiumEntitlement: false, now: now, isAvailable: true),
        isTrue,
      );
    });

    test('customerInfo がエラー等で取得できない (null) 時は非プレミアム扱いで表示する', () {
      expect(
        shouldPresentOnboarding(appUser: AppUser(createdDateTime: now), hasPremiumEntitlement: null, now: now, isAvailable: true),
        isTrue,
      );
    });

    test('完了記録があれば表示しない', () {
      expect(
        shouldPresentOnboarding(
          appUser: AppUser(createdDateTime: now, onboardingCompletedDateTime: now),
          hasPremiumEntitlement: false,
          now: now,
          isAvailable: true,
        ),
        isFalse,
      );
    });

    test('プレミアム (トライアル含む) には表示しない', () {
      expect(
        shouldPresentOnboarding(appUser: AppUser(createdDateTime: now), hasPremiumEntitlement: true, now: now, isAvailable: true),
        isFalse,
      );
    });

    test('作成から 1 日以上経過した既存ユーザーには表示しない (リリース前からのユーザーを巻き込まない)', () {
      expect(
        shouldPresentOnboarding(
          appUser: AppUser(createdDateTime: now.subtract(const Duration(days: 1))),
          hasPremiumEntitlement: false,
          now: now,
          isAvailable: true,
        ),
        isFalse,
      );
    });

    test('作成から 1 日未満なら表示する', () {
      expect(
        shouldPresentOnboarding(
          appUser: AppUser(createdDateTime: now.subtract(const Duration(hours: 23))),
          hasPremiumEntitlement: false,
          now: now,
          isAvailable: true,
        ),
        isTrue,
      );
    });

    test('createdDateTime が無ければ表示しない', () {
      expect(
        shouldPresentOnboarding(appUser: const AppUser(), hasPremiumEntitlement: false, now: now, isAvailable: true),
        isFalse,
      );
    });

    test('createdDateTime が未来 (端末時計のずれ) なら表示しない', () {
      expect(
        shouldPresentOnboarding(
          appUser: AppUser(createdDateTime: now.add(const Duration(hours: 1))),
          hasPremiumEntitlement: false,
          now: now,
          isAvailable: true,
        ),
        isFalse,
      );
    });

    test('文言が未翻訳のロケールには表示しない', () {
      expect(
        shouldPresentOnboarding(appUser: AppUser(createdDateTime: now), hasPremiumEntitlement: false, now: now, isAvailable: false),
        isFalse,
      );
    });
  });
}
