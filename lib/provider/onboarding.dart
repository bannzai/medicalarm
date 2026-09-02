import 'package:medicalarm/features/resolver/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding.g.dart';

// オンボーディングの完了日時を AppUser に記録する。ペイウォールを閉じた時点で呼ぶ
class OnboardingComplete {
  final UserDatabase userDatabase;

  OnboardingComplete({required this.userDatabase});

  Future<void> call() async {
    await userDatabase.userReference().update({
      'onboardingCompletedDateTime': DateTime.now(),
    });
  }
}

@Riverpod(dependencies: [userDatabase])
OnboardingComplete onboardingComplete(OnboardingCompleteRef ref) {
  return OnboardingComplete(userDatabase: ref.watch(userDatabaseProvider));
}
