import 'dart:io';

import 'package:medicalarm/utils/functions/firebase_functions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feature_request.g.dart';

/// 機能要望を Cloud Functions 経由で Slack に通知する mutation。
/// 既存の `MedicineAdd` 等と同じく専用 class + Provider の組み合わせで提供する。
class FeatureRequestSubmit {
  FeatureRequestSubmit();

  Future<void> call({required String content, required String? emailAddress}) async {
    final packageInfo = await PackageInfo.fromPlatform();
    await functions.submitFeatureRequest(
      content: content.trim(),
      emailAddress: emailAddress?.trim(),
      appVersion: packageInfo.version,
      platform: Platform.isIOS ? 'iOS' : 'Android',
    );
  }
}

@Riverpod(dependencies: [])
FeatureRequestSubmit featureRequestSubmit(FeatureRequestSubmitRef ref) {
  return FeatureRequestSubmit();
}
