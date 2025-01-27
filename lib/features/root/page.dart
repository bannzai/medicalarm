import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/home/page.dart';
import 'package:medicalarm/features/localization/resolver.dart';
import 'package:medicalarm/features/resolver/app_entity_prepare.dart';
import 'package:medicalarm/features/resolver/app_resolvers.dart';
import 'package:medicalarm/features/resolver/app_user.dart';
import 'package:medicalarm/features/resolver/app_user_create.dart';
import 'package:medicalarm/features/resolver/force_update.dart';
import 'package:medicalarm/features/resolver/in_app_review.dart';
import 'package:medicalarm/features/resolver/purchase_setup.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

class RootPage extends HookConsumerWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppLocalizationResolver(builder: (context) {
      return AppResolvers(builder: (context, user) {
        return AppUserCreateResolver(builder: (context) {
          return ForceUpdateResolver(builder: (context) {
            return PurchaseSetupResolver(
              userID: user.uid,
              builder: (context) {
                return AppEntityPrepareResolver(
                  userID: user.uid,
                  builder: (context) {
                    return Stack(
                      children: [
                        const InAppReviewResolver(),
                        AppUserStreamResolver(stream: (user) => analyticsDebugIsEnabled = user.analyticsDebugIsEnabled),
                        const HomePage(),
                      ],
                    );
                  },
                );
              },
            );
          });
        });
      });
    });
  }
}
