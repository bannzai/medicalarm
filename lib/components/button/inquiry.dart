import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/style/button.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/shared_preferences/keys.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medicalarm/entity/app_user.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/config/environment.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';

void inquiry() {
  PackageInfo.fromPlatform().then((value) => debugInfo(', ')).then((info) {
    launchUrl(
        Uri.parse(Uri.encodeFull(
            'https://docs.google.com/forms/d/e/1FAIpQLSekfSrJzYFKsMyQsTIezbbmOSuIbltomfP6KTs37SoR9_Xrhw/viewform?usp=pp_url&entry.1212480449=$info')),
        mode: LaunchMode.externalApplication);
  });
}

Future<String> debugInfo(String separator) async {
  final userID = FirebaseAuth.instance.currentUser?.uid;
  if (userID == null) {
    final sharedPreferences = await SharedPreferences.getInstance();
    return Future.value('DEBUG INFO user is not found. lastest last login id ${sharedPreferences.getString(StringKey.lastSignInFirebaseAuthUserID)}');
  }

  UserDatabase databaseConnection = UserDatabase(userID: userID);

  AppUser? user;
  try {
    user = (await databaseConnection.userReference().get()).data();
  } catch (_) {}

  PackageInfo? package;
  try {
    package = await PackageInfo.fromPlatform();
  } catch (_) {}

  CustomerInfo? customerInfo;
  try {
    customerInfo = await Purchases.getCustomerInfo();
  } catch (_) {}

  final appName = package?.appName;
  final buildNumber = package?.buildNumber;
  final packageName = package?.packageName;
  final version = package?.version;
  final platform = Platform.isIOS ? 'iOS' : 'Android';

  final contents = [
    'DEBUG INFO',
    "$platform:$appName:$version:$packageName:$buildNumber:${Environment.isProduction ? "prod" : "dev"}",
    'userID: $userID',
    'createdDateTime: ${user?.createdDateTime}',
    'isPremium: ${customerInfo?.isPremium}',
    'isInPromotion: ${customerInfo?.isInPromotion}',
  ];
  return contents.join(separator);
}

class InquiryButton extends HookConsumerWidget {
  const InquiryButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      icon: const Icon(
        Icons.mail,
        size: 20,
      ),
      label: Text(
        L.inquiry,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 14,
          color: TextColor.black,
        ),
      ),
      onPressed: () {
        analytics.logEvent(name: 'problem_unresolved_button_pressed');
        inquiry();
      },
      style: filledWidthButtonStyle,
    );
  }
}
