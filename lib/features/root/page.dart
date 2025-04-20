import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/home/page.dart';
import 'package:medicalarm/features/localization/resolver.dart';
import 'package:medicalarm/features/promotion_start/resolver.dart';
import 'package:medicalarm/features/resolver/app_entity_prepare.dart';
import 'package:medicalarm/features/resolver/app_user.dart';
import 'package:medicalarm/features/resolver/app_user_create.dart';
import 'package:medicalarm/features/resolver/auth.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/features/resolver/force_update.dart';
import 'package:medicalarm/features/resolver/in_app_review.dart';
import 'package:medicalarm/features/resolver/purchase_setup.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

class RootPage extends HookConsumerWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppLocalizationResolver(builder: (context) {
      debugPrint('Resolved: AppLocalizationResolver');
      return AuthResolver(builder: (_, user) {
        debugPrint('Resolved: AuthResolver');
        return UserDatabaseResolver(
            user: user,
            builder: (context) {
              debugPrint('Resolved: UserDatabaseResolver');
              return AppUserCreateResolver(builder: (context, appUser) {
                debugPrint('Resolved: AppUserCreateResolver');
                return ForceUpdateResolver(builder: (context) {
                  debugPrint('Resolved: ForceUpdateResolver');
                  return PurchaseSetupResolver(
                    userID: user.uid,
                    builder: (context) {
                      debugPrint('Resolved: PurchaseSetupResolver');
                      return AppEntityPrepareResolver(
                        userID: user.uid,
                        builder: (context) {
                          debugPrint('Resolved: AppEntityPrepareResolver');
                          return PromotionStartResolver(
                              appUser: appUser,
                              builder: (context) {
                                debugPrint('Resolved: PromotionStartResolver');
                                return Stack(
                                  children: [
                                    const InAppReviewResolver(),
                                    AppUserStreamResolver(stream: (user) => analyticsDebugIsEnabled = user.analyticsDebugIsEnabled),
                                    const HomePage(),
                                  ],
                                );
                              });
                        },
                      );
                    },
                  );
                });
              });
            });
      });
    });
  }
}
