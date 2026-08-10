import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/analytics/error.dart';
import 'package:medicalarm/utils/platform/platform.dart';
import 'package:medicalarm/utils/purchase/error.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:medicalarm/features/localization/l.dart';

class PremiumIntroductionFotter extends StatelessWidget {
  final ValueNotifier<bool> isLoading;

  const PremiumIntroductionFotter({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  color: Colors.grey.shade700,
                ),
                children: [
                  TextSpan(text: '・${L.premiumContractPeriod}\n'),
                  const TextSpan(text: '・'),
                  TextSpan(
                    text: L.privacyPolicy,
                    style: const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        analytics.logEvent(name: 'premium_intro_privacy_tapped');
                        launchUrl(Uri.parse('https://bannzai.github.io/medicalarm/PrivacyPolicy'), mode: LaunchMode.inAppWebView);
                      },
                  ),
                  const TextSpan(
                    text: ' / ',
                  ),
                  TextSpan(
                    text: L.termsOfService,
                    style: const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        analytics.logEvent(name: 'premium_intro_terms_tapped');
                        launchUrl(Uri.parse('https://bannzai.github.io/medicalarm/Terms'), mode: LaunchMode.inAppWebView);
                      },
                  ),
                  const TextSpan(
                    text: ' / ',
                  ),
                  TextSpan(
                    text: L.specifiedCommercialTransactionAct,
                    style: const TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        analytics.logEvent(name: 'premium_intro_scta_tapped');
                        launchUrl(Uri.parse('https://bannzai.github.io/medicalarm/SpecifiedCommercialTransactionAct'), mode: LaunchMode.inAppWebView);
                      },
                  ),
                  TextSpan(
                    text: '${L.confirmBeforeRegistration}\n',
                  ),
                  TextSpan(
                    text: '・${L.autoRenewalNotice}\n',
                  ),
                  TextSpan(
                    text: L.premiumCancelDescription(storeName),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () async {
              analytics.logEvent(name: 'premium_intro_restore_tapped');
              try {
                isLoading.value = true;
                final messenger = ScaffoldMessenger.of(context);
                final shouldShowSnackbar = await _restore();
                if (shouldShowSnackbar) {
                  messenger.showSnackBar(
                    SnackBar(
                      duration: const Duration(
                        seconds: 2,
                      ),
                      content: Text(L.purchaseRestored),
                    ),
                  );
                }
              } catch (error) {
                if (context.mounted) showErrorAlert(context, error);
              } finally {
                isLoading.value = false;
              }
            },
            child: Text(
              L.restorePurchase,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Return true indicates end of regularllly pattern.
  /// Return false indicates not regulally pattern.
  /// Return value is used to display the completion snackbar
  Future<bool> _restore() async {
    try {
      final purchaserInfo = await Purchases.restorePurchases();
      final entitlements = purchaserInfo.entitlements.all[premiumEntitlementIdentifier];
      analytics.logEvent(name: 'proceed_restore_purchase_info', parameters: {
        'entitlements': entitlements?.identifier ?? '',
        'isActivated': entitlements?.isActive ?? false,
      });
      if (entitlements != null && entitlements.isActive) {
        analytics.logEvent(name: 'done_restore_purchase_info', parameters: {
          'entitlements': entitlements.identifier,
        });
        return Future.value(true);
      }
      analytics.logEvent(name: 'undone_restore_purchase_info', parameters: {
        'entitlements': entitlements?.identifier ?? '',
        'isActivated': entitlements?.isActive ?? false,
      });
      throw FormatException(L.purchaseErrorRestoreFailed);
    } on PlatformException catch (exception, stack) {
      analytics.logEvent(
          name: 'catched_restore_exception',
          parameters: {'code': exception.code, 'details': exception.details.toString(), 'message': exception.message ?? ''});
      final newException = mapToDisplayedException(exception);
      if (newException == null) {
        return Future.value(false);
      }
      errorLogger.recordError(exception, stack);
      throw newException;
    } catch (exception, stack) {
      analytics.logEvent(name: 'catched_restore_anonymous_exception', parameters: {
        'exception_type': exception.runtimeType.toString(),
      });
      errorLogger.recordError(exception, stack);
      rethrow;
    }
  }
}
