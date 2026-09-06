import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/widgets.dart';
import 'package:medicalarm/entity/remote_config_parameter.dart';
import 'package:medicalarm/utils/analytics/error.dart';
import 'package:medicalarm/utils/config/version.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_config.g.dart';

final remoteConfig = FirebaseRemoteConfig.instance;

Future<void> setupRemoteConfig() async {
  try {
    await (
      remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      )),
      // [RemoteConfigDefaultValues] でgrepした場所に全て設定する
      remoteConfig.setDefaults({
        RemoteConfigKeys.minimumAppVersion: RemoteConfigParameterDefaultValues.minimumAppVersion,
        RemoteConfigKeys.promotionDayCount: RemoteConfigParameterDefaultValues.promotionDayCount,
        RemoteConfigKeys.releasedVersion: RemoteConfigParameterDefaultValues.releasedVersion,
      }),
    ).wait;

    // fetch はネットワーク・負荷状況次第で fetchTimeout (1分) まで待ち得る (実測: 高負荷の simulator で 36.5 秒)。
    // main() はこの関数の完了を待って runApp するため、fetch を待ち続けると初回フレームが描画されず
    // 起動白画面になる。10 秒で見切って起動を優先する。10 秒は、通常時の fetch (数秒以内) を妨げず、
    // 見切り時も setDefaults 済みの既定値で全機能が動く前提の起動ブロック上限。
    // Future.timeout は見切り後の元 future の結果・エラーを無視するため、遅延完了が unhandled error にはならない
    // (遅れて fetch が完了した場合は fetchAndActivate 自身が activate し、次回の参照から取得値が効く)
    await remoteConfig.fetchAndActivate().timeout(const Duration(seconds: 10));

    debugPrintRemoteConfig();
  } catch (error, st) {
    // ignore error
    // ParallelWaitErrorとentrypointでRemoteConfigを導入してからエラーが出るようになった。RemoteConfigの設定は失敗しても最悪どうにかなるだろう。ということでエラーは無視する
    debugPrint(error.toString());
    errorLogger.recordError(error, st);
  }

  // 設定・fetch の成否によらず、サーバー側の更新をリアルタイム反映するリスナーは常に張る
  remoteConfig.onConfigUpdated.listen((event) {
    remoteConfig.activate();
  });
}

void debugPrintRemoteConfig() {
  for (final entry in remoteConfig.getAll().entries) {
    debugPrint('RemoteConfig: ${entry.key} ${entry.value.asString()}');
  }
}

@Riverpod()
Future<bool> appIsReleased(Ref ref) async {
  final releasedVersion = Version.parse(remoteConfig.getString(RemoteConfigKeys.releasedVersion));
  final packageInfo = await PackageInfo.fromPlatform();
  final appVersion = Version.parse(packageInfo.version);
  return !appVersion.isGreaterThan(releasedVersion);
}
