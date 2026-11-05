import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';

// カンナダ語・グジャラート語の arb に、別の言語の文字 (漢字・グルムキー文字等)・訳されずに残った英字・
// アプリの説明文が混ざった訳文が無いことを確かめる (#475)
void main() {
  final template = jsonDecode(File('lib/l10n/app_ja.arb').readAsStringSync()) as Map<String, dynamic>;

  // 訳さずに英字のまま表示する語。ブランド名・OS の機能名・単位で、どの言語の arb でも英字で書いている
  // Focus は連携アプリの名前で、app_ja.arb の description が訳さないと指示している (#495)
  const allowedLatinWords = {'Alert', 'App', 'Apple', 'Critical', 'FAQ', 'Focus', 'Google', 'Medicalarm', 'OSS', 'Pilll', 'Premium', 'Store', 'mg'};

  for (final (locale, scriptStart, scriptEnd) in [('kn', 0x0C80, 0x0CFF), ('gu', 0x0A80, 0x0AFF)]) {
    group('app_$locale.arb', () {
      final arb = jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync()) as Map<String, dynamic>;
      final messages = arb.entries.where((entry) => !entry.key.startsWith('@') && entry.value is String);

      test('その言語の文字・ASCII の数字と記号・記号類 (絵文字・★・• 等) 以外の文字を含まない', () {
        final violations = <String>[];
        for (final message in messages) {
          final foreignCharacters = (message.value as String).runes.where((rune) {
            final isExpectedScript = rune >= scriptStart && rune <= scriptEnd;
            final isAscii = rune < 0x80;
            // U+2000〜U+2027 は ZWNJ・ZWJ (インド系文字の字形の制御) と ’ や • 等の一般的な記号
            final isGeneralPunctuation = rune >= 0x2000 && rune <= 0x2027;
            // ⚠️ ★ 等の記号、🎉 等の絵文字 (U+1F300〜U+1FAFF)、絵文字の表示を指定する異体字セレクタ (U+FE0F)
            final isSymbol = (rune >= 0x2600 && rune <= 0x27BF) || (rune >= 0x1F300 && rune <= 0x1FAFF) || rune == 0xFE0F;
            return !isExpectedScript && !isAscii && !isGeneralPunctuation && !isSymbol;
          }).toList();
          if (foreignCharacters.isNotEmpty) {
            violations.add('${message.key}: ${String.fromCharCodes(foreignCharacters)}');
          }
        }
        expect(violations, isEmpty);
      });

      test('英字はブランド名・機能名・単位だけ', () {
        final violations = <String>[];
        for (final message in messages) {
          final latinWords = RegExp('[A-Za-z]+')
              .allMatches((message.value as String).replaceAll(RegExp(r'\{[^}]*\}'), ''))
              .map((match) => match.group(0)!)
              .where((word) => !allowedLatinWords.contains(word))
              .toList();
          if (latinWords.isNotEmpty) {
            violations.add('${message.key}: ${latinWords.join(', ')}');
          }
        }
        expect(violations, isEmpty);
      });

      test('原文 (ja) が 1 行の訳文は改行を含まない', () {
        final violations = messages
            .where((message) => (message.value as String).contains('\n') && !(template[message.key] as String? ?? '').contains('\n'))
            .map((message) => message.key)
            .toList();
        expect(violations, isEmpty);
      });

      test('プレースホルダが原文 (ja) と同じ', () {
        final violations = messages
            .where(
              (message) => !const SetEquality<String>().equals(
                RegExp(r'\{(\w+)\}').allMatches(message.value as String).map((match) => match.group(1)!).toSet(),
                RegExp(r'\{(\w+)\}').allMatches(template[message.key] as String? ?? '').map((match) => match.group(1)!).toSet(),
              ),
            )
            .map((message) => message.key)
            .toList();
        expect(violations, isEmpty);
      });

      // 訳文の中で別のキーのボタン名・画面名を案内する時、利用者が画面で探せるようにその arb の該当キーの訳文と一致させる (#487)
      test('文中で案内するボタン名・画面名が、その arb の該当キーの訳文と一致する', () {
        final violations = <String>[];
        for (final message in messages) {
          final templateMessage = template[message.key] as String? ?? '';
          if (templateMessage.contains('設定 > 問い合わせ') && !(message.value as String).contains('${arb['settings']} > ${arb['inquiry']}')) {
            violations.add('${message.key}: settings > inquiry');
          }
          if (templateMessage.contains('「以前購入した方はこちら」') && !(message.value as String).contains(arb['restorePurchase'] as String)) {
            violations.add('${message.key}: restorePurchase');
          }
        }
        expect(violations, isEmpty);
      });
    });
  }
}
