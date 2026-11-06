import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';

// ja・en 以外の言語の arb に無く、日本語で表示されていた 28 キー (#495) と、全言語に足したキーの訳文があることを確かめる
// 新機能の PR は ja・en だけにキーを足し、他の言語は後から翻訳するため、全キーではなく列挙したキーを対象にする
void main() {
  const keys = [
    'alarmKitNotification',
    'alarmKitNotificationDescription',
    'focusConnectBlockOtherApps',
    'focusConnectBlockOtherAppsDescription',
    'focusNotInstalled',
    'focusInstallMessage',
    'medicineImageImport',
    'medicineImageImportReviewTitle',
    'medicineImageImportEmpty',
    'medicineImageImportSelectableLimit',
    'medicineImageImportAddCount',
    'medicineImageImportCompletedSnackbar',
    'medicineImageImportTimeFallbackCaption',
    'medicineImageImportDroppedSchedulesCaption',
    'medicineImageImportGroupChangedError',
    // 外部の AI に画像を送る前の確認ダイアログ (#548)。App Store の審査で全言語に表示が要るため ja・en 以外にも足す
    'medicineImageImportConsentTitle',
    'medicineImageImportConsentMessage',
    'cancel',
    'featureRequestTitle',
    'featureRequestPromptTitle',
    'featureRequestPromptMessage',
    'featureRequestPromptCta',
    'later',
    'featureRequestContentLabel',
    'featureRequestContentHint',
    'featureRequestContentFooter',
    'featureRequestEmailLabel',
    'featureRequestEmailFooter',
    'featureRequestEmailInvalid',
    'featureRequestThanks',
    'send',
  ];

  final template = jsonDecode(File('lib/l10n/app_ja.arb').readAsStringSync()) as Map<String, dynamic>;
  final config = jsonDecode(File('translate-app.config.json').readAsStringSync()) as Map<String, dynamic>;
  final locales = (config['target_languages'] as List<dynamic>).cast<String>().where((locale) => locale != 'en');

  Set<String> placeholders(String message) => RegExp(r'\{(\w+)\}').allMatches(message).map((match) => match.group(1)!).toSet();

  for (final locale in locales) {
    test('app_$locale.arb に対象キーの訳文があり、プレースホルダが原文 (ja) と同じ', () {
      final arb = jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync()) as Map<String, dynamic>;
      final violations = keys
          .where(
            (key) =>
                ((arb[key] as String?) ?? '').trim().isEmpty ||
                !const SetEquality<String>().equals(placeholders(arb[key] as String), placeholders(template[key] as String)),
          )
          .toList();
      expect(violations, isEmpty);
    });

    // 案内文が指す設定画面の項目は L.featureRequestTitle を表示するため、利用者が画面で探せるよう同じ訳文にする
    test('app_$locale.arb の featureRequestPromptMessage が案内する項目名が featureRequestTitle と一致する', () {
      final arb = jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync()) as Map<String, dynamic>;
      expect(arb['featureRequestPromptMessage'] as String, contains(arb['featureRequestTitle'] as String));
    });
  }

  test('対象の言語は ja・en を除く 76 言語', () {
    expect(locales.length, 76);
  });
}
