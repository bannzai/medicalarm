// ignore_for_file: constant_identifier_names

enum Flavor {
  DEVELOP,
  PRODUCTION,
  LOCAL, // Local is special flavor for development with firebase:emulators
}

abstract class Environment {
  static bool get isProduction => flavor == Flavor.PRODUCTION;
  static bool get isDevelopment => flavor == Flavor.DEVELOP || flavor == Flavor.LOCAL;
  static bool get isLocal => flavor == Flavor.LOCAL;
  static bool isTest = false;
  static Flavor? flavor;
  // Avoid too, too much CPU usage.
  // Ref: https://github.com/flutter/flutter/issues/13203#issuecomment-430134157
  static bool get disableWidgetAnimation => const bool.fromEnvironment('DISABLE_WIDGET_ANIMATION') && isDevelopment;

  static const siwaServiceIdentifier = String.fromEnvironment('SIWA_SERVICE_IDENTIFIIER');
  static const androidSiwaRedirectURL = String.fromEnvironment('ANDROID_SIWA_REDIRECT_URL');

  /// メンテナンス中かを読む先 (`<状態を返す Worker の URL>/<サービス名>`。castle の service-maintenance-setup skill)。
  /// 既定は本番の状態で、`service-maintenance on medicalarm` で切り替わる。
  /// 本番の利用者にメンテナンス中の画面を出さずに確かめる時だけ、`--dart-define=MAINTENANCE_STATE_URL=<手元のサーバー>` で差し替える
  static const maintenanceStateURL =
      String.fromEnvironment('MAINTENANCE_STATE_URL', defaultValue: 'https://service-maintenance.star-kojiki.workers.dev/medicalarm');

  static Function()? deleteUser;
  static Function()? signOutUser;
}
