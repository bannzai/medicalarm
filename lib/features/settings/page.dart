import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medicalarm/components/button/inquiry.dart';
import 'package:medicalarm/components/button/user_delete.dart';
import 'package:medicalarm/features/settings/components/premium_introduction.dart';
import 'package:medicalarm/features/settings/components/section.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:medicalarm/features/localization/l.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L.settings),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SettingSectionTitle(text: L.premiumPlan, children: const [
              PremiumIntroduction(),
              _Divider(),
            ]),
            SettingSectionTitle(text: L.aboutApp, children: [
              ListTile(
                  title: Text(
                    L.termsOfService,
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    analytics.logEvent(name: 'did_select_terms_of_service', parameters: {});
                    launchUrl(Uri.parse('https://bannzai.github.io/medicalarm/Terms'), mode: LaunchMode.externalApplication);
                  }),
              const _Divider(),
              ListTile(
                title: Text(
                  L.privacyPolicy,
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  analytics.logEvent(name: 'did_select_privacy_policy', parameters: {});
                  launchUrl(Uri.parse('https://bannzai.github.io/medicalarm/PrivacyPolicy'), mode: LaunchMode.externalApplication);
                },
              ),
              const _Divider(),
              ListTile(
                  title: Text(
                    L.specifiedCommercialTransactionAct,
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    analytics.logEvent(name: 'did_select_scta', parameters: {});
                    launchUrl(Uri.parse('https://bannzai.github.io/medicalarm/SpecifiedCommercialTransactionAct'),
                        mode: LaunchMode.externalApplication);
                  }),
              const _Divider(),
              ListTile(
                title: Text(L.inquiry),
                onTap: () {
                  inquiry();
                },
              ),
            ]),
            if (kDebugMode) ...[
              const DeleteUserButton(),
            ],
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Container(
        height: 1,
        color: AppColors.border,
      ),
    );
  }
}
