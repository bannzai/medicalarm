import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';

// ja・en 以外の言語の arb に無く、日本語で表示されていた 28 キーの訳文があることを確かめる (#495)
// 新機能の PR は ja・en だけにキーを足し、他の言語は後から翻訳するため、全キーではなくこの 28 キーを対象にする
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
    test('app_$locale.arb に 28 キーの訳文があり、プレースホルダが原文 (ja) と同じ', () {
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
  }

  test('対象の言語は ja・en を除く 76 言語', () {
    expect(locales.length, 76);
  });
}
