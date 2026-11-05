import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/feature_request/feature_request_prompt_resolver.dart';
import 'package:medicalarm/features/home/page.dart';
import 'package:medicalarm/features/localization/resolver.dart';
import 'package:medicalarm/features/onboarding/resolver.dart';
import 'package:medicalarm/features/onboarding/medication_plan_resolver.dart';
import 'package:medicalarm/features/promotion_start/resolver.dart';
import 'package:medicalarm/features/resolver/app_entity_prepare.dart';
import 'package:medicalarm/features/resolver/app_user.dart';
import 'package:medicalarm/features/resolver/app_user_create.dart';
import 'package:medicalarm/features/resolver/auth.dart';
import 'package:medicalarm/features/resolver/current_group.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/features/resolver/force_update.dart';
import 'package:medicalarm/features/resolver/group_migration.dart';
import 'package:medicalarm/features/resolver/purchase_setup.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/launch/launch_stage.dart';

class RootPage extends HookConsumerWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppLocalizationResolver(builder: (context) {
      recordLaunchStageOnce(stage: 'Resolved: AppLocalizationResolver');
      return AuthResolver(builder: (_, user) {
        // uid を残し、Simulator ごとに新しい匿名ユーザーで起動したことを確かめられるようにする (#516)
        recordLaunchStageOnce(stage: 'Resolved: AuthResolver', detail: 'uid=${user.uid}');
        return UserDatabaseResolver(
            user: user,
            builder: (context) {
              recordLaunchStageOnce(stage: 'Resolved: UserDatabaseResolver');
              return AppUserCreateResolver(
                  firebaseUserID: user.uid,
                  builder: (context, appUser) {
                    recordLaunchStageOnce(stage: 'Resolved: AppUserCreateResolver');
                    return ForceUpdateResolver(builder: (context) {
                      recordLaunchStageOnce(stage: 'Resolved: ForceUpdateResolver');
                      return PurchaseSetupResolver(
                        userID: user.uid,
                        builder: (context) {
                          recordLaunchStageOnce(stage: 'Resolved: PurchaseSetupResolver');
                          return GroupMigrationResolver(builder: (context) {
                            recordLaunchStageOnce(stage: 'Resolved: GroupMigrationResolver');
                            return CurrentGroupResolver(builder: (context) {
                              recordLaunchStageOnce(stage: 'Resolved: CurrentGroupResolver');
                              return AppEntityPrepareResolver(
                                userID: user.uid,
                                builder: (context) {
                                  recordLaunchStageOnce(stage: 'Resolved: AppEntityPrepareResolver');
                                  return OnboardingMedicationPlanResolver(
                                      child: OnboardingResolver(
                                    appUser: appUser,
                                    builder: (context, didCompleteOnboardingInThisSession) {
                                      recordLaunchStageOnce(stage: 'Resolved: OnboardingResolver');
                                      Widget home() => Stack(
                                            children: [
                                              const FeatureRequestPromptResolver(),
                                              AppUserStreamResolver(stream: (user) => analyticsDebugIsEnabled = user.analyticsDebugIsEnabled),
                                              const HomePage(),
                                            ],
                                          );
                                      // オンボーディングのペイウォールを閉じた直後に再エンゲージメント訴求 (PromotionStartResolver) を続けて出さないため。
                                      // 次回起動以降は PromotionStartResolver の条件に従う
                                      if (didCompleteOnboardingInThisSession) {
                                        return home();
                                      }
                                      return PromotionStartResolver(
                                          appUser: appUser,
                                          builder: (context) {
                                            recordLaunchStageOnce(stage: 'Resolved: PromotionStartResolver');
                                            return home();
                                          });
                                    },
                                  ));
                                },
                              );
                            });
                          });
                        },
                      );
                    });
                  });
            });
      });
    });
  }
}
