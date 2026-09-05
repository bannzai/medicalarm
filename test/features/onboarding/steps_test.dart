import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/features/onboarding/steps.dart';

void main() {
  // US 長尺 / JP 短尺のファネル構成 (documents/onboarding-funnel-design.md) を検証する
  group('onboardingSteps', () {
    test('長尺は全画面を宣言順に含む', () {
      expect(onboardingSteps(isShortForm: false), OnboardingStep.values);
    });

    test('短尺は長尺専用の画面 (ペインの重ね聞き・価値提示・Before/After・目標設定) を省く', () {
      expect(onboardingSteps(isShortForm: true), [
        OnboardingStep.welcome,
        OnboardingStep.painForgot,
        OnboardingStep.careTarget,
        OnboardingStep.dailyDoseCount,
        OnboardingStep.medicineCount,
        OnboardingStep.planGenerating,
        OnboardingStep.planResult,
      ]);
    });

    test('どちらの形式も価値宣言で始まりプラン生成 → 結果提示で終わる (結果提示の CTA がペイウォールへの唯一の入口)', () {
      for (final isShortForm in [true, false]) {
        final steps = onboardingSteps(isShortForm: isShortForm);
        expect(steps.first, OnboardingStep.welcome);
        expect(steps[steps.length - 2], OnboardingStep.planGenerating);
        expect(steps.last, OnboardingStep.planResult);
      }
    });

    test('価値宣言・プラン生成・結果提示には戻るボタンを出さない', () {
      expect(OnboardingStep.welcome.canGoBack, isFalse);
      expect(OnboardingStep.planGenerating.canGoBack, isFalse);
      expect(OnboardingStep.planResult.canGoBack, isFalse);
      expect(OnboardingStep.painForgot.canGoBack, isTrue);
      expect(OnboardingStep.goal.canGoBack, isTrue);
    });
  });

  group('isShortFormOnboarding', () {
    test('日本語ロケールは JP 短尺', () {
      expect(isShortFormOnboarding(languageCode: 'ja'), isTrue);
    });

    test('日本語以外は US 長尺', () {
      expect(isShortFormOnboarding(languageCode: 'en'), isFalse);
      expect(isShortFormOnboarding(languageCode: 'de'), isFalse);
    });
  });

  // 全言語の arb に、テンプレート (ja) の onboarding* キーが揃っていることを検証する。
  // 揃っていない言語ではテンプレートの日本語にフォールバックした画面が出てしまうため、キーを追加したら translate-app-arb で全言語を翻訳してから通す
  // (flutter test のカレントはプロジェクトルートである前提。test/utils/analytics/log_event_names_test.dart と同じ)
  group('オンボーディング文言の翻訳', () {
    Set<String> onboardingKeys({required String languageCode}) {
      final arb = jsonDecode(File('lib/l10n/app_$languageCode.arb').readAsStringSync()) as Map<String, dynamic>;
      return arb.keys.where((key) => !key.startsWith('@') && key.startsWith('onboarding')).toSet();
    }

    test('全言語の arb にテンプレート (ja) の onboarding* キーがすべて存在する', () {
      final templateKeys = onboardingKeys(languageCode: 'ja');
      expect(templateKeys, isNotEmpty);
      final languageCodes =
          Directory('lib/l10n').listSync().map((entity) => RegExp(r'app_(.+)\.arb$').firstMatch(entity.path)?.group(1)).nonNulls.toList();
      expect(languageCodes.length, greaterThan(70));
      for (final languageCode in languageCodes) {
        expect(onboardingKeys(languageCode: languageCode), containsAll(templateKeys), reason: 'app_$languageCode.arb に未翻訳の onboarding* キーがある');
      }
    });
  });

  // 翻訳が別言語の文字体系 (例: アムハラ語の arb にアルメニア文字) で混入していないことを検証する。
  // 各 arb の既存の訳文で最も多い文字体系を「その言語の文字体系」とし、onboarding* の訳文にそれと異なる非ラテン文字体系が
  // 主に使われていれば失敗にする (ラテン文字は Medicalarm や Critical Alert 等の固有名詞で混ざるため除外)
  group('オンボーディング文言の文字体系', () {
    // Unicode ブロックの範囲と文字体系名。ラテン文字はここに含めず、下の isLatin で判定する
    const scriptRanges = <(int, int, String)>[
      (0x0370, 0x03FF, 'Greek'),
      (0x0400, 0x04FF, 'Cyrillic'),
      (0x0530, 0x058F, 'Armenian'),
      (0x0590, 0x05FF, 'Hebrew'),
      (0x0600, 0x06FF, 'Arabic'),
      (0x0900, 0x097F, 'Devanagari'),
      (0x0980, 0x09FF, 'Bengali'),
      (0x0A00, 0x0A7F, 'Gurmukhi'),
      (0x0A80, 0x0AFF, 'Gujarati'),
      (0x0B00, 0x0B7F, 'Oriya'),
      (0x0B80, 0x0BFF, 'Tamil'),
      (0x0C00, 0x0C7F, 'Telugu'),
      (0x0C80, 0x0CFF, 'Kannada'),
      (0x0D00, 0x0D7F, 'Malayalam'),
      (0x0D80, 0x0DFF, 'Sinhala'),
      (0x0E00, 0x0E7F, 'Thai'),
      (0x0E80, 0x0EFF, 'Lao'),
      (0x1000, 0x109F, 'Myanmar'),
      (0x10A0, 0x10FF, 'Georgian'),
      (0x1200, 0x137F, 'Ethiopic'),
      (0x1780, 0x17FF, 'Khmer'),
      (0x3040, 0x30FF, 'CJK'),
      (0x4E00, 0x9FFF, 'CJK'),
      (0x1100, 0x11FF, 'Hangul'),
      (0x3130, 0x318F, 'Hangul'),
      (0xAC00, 0xD7AF, 'Hangul'),
    ];

    bool isLatin(int rune) => (rune >= 0x41 && rune <= 0x5A) || (rune >= 0x61 && rune <= 0x7A) || (rune >= 0x00C0 && rune <= 0x024F);

    String? scriptOf(int rune) {
      for (final (start, end, name) in scriptRanges) {
        if (rune >= start && rune <= end) {
          return name;
        }
      }
      return null;
    }

    /// 文字体系ごとの出現数。[includeLatin] が false ならラテン文字を数えない
    Map<String, int> countScripts(Iterable<String> values, {required bool includeLatin}) {
      final counts = <String, int>{};
      for (final value in values) {
        for (final rune in value.runes) {
          final script = isLatin(rune) ? (includeLatin ? 'Latin' : null) : scriptOf(rune);
          if (script != null) {
            counts[script] = (counts[script] ?? 0) + 1;
          }
        }
      }
      return counts;
    }

    String? dominant(Map<String, int> counts) => counts.isEmpty ? null : counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

    test('各言語の onboarding* の訳文に、その言語と異なる非ラテン文字体系が主に使われていない', () {
      final mismatches = <String>[];
      for (final entity in Directory('lib/l10n').listSync()) {
        final languageCode = RegExp(r'app_(.+)\.arb$').firstMatch(entity.path)?.group(1);
        if (languageCode == null) {
          continue;
        }
        final arb = jsonDecode(File(entity.path).readAsStringSync()) as Map<String, dynamic>;
        final existingValues =
            arb.entries.where((e) => !e.key.startsWith('@') && !e.key.startsWith('onboarding') && e.value is String).map((e) => e.value as String);
        final languageScript = dominant(countScripts(existingValues, includeLatin: true));
        if (languageScript == null || languageScript == 'Latin') {
          continue;
        }
        for (final entry in arb.entries.where((e) => e.key.startsWith('onboarding') && e.value is String)) {
          final valueScript = dominant(countScripts([entry.value as String], includeLatin: false));
          if (valueScript != null && valueScript != languageScript) {
            mismatches.add('app_$languageCode.arb ${entry.key}: $valueScript (言語は $languageScript)');
          }
        }
      }
      expect(mismatches, isEmpty, reason: mismatches.join('\n'));
    });
  });

  // 回答が無料プランの登録上限 (服用者 2 人・通知スケジュール 2 件・薬 2 種類) を超える時だけプレミアムを勧める
  group('onboardingRecommendsPremium', () {
    test('すべて無料枠に収まるなら勧めない', () {
      expect(
        onboardingRecommendsPremium(
          careTarget: OnboardingCareTarget.family,
          dailyDoseCount: OnboardingDailyDoseCount.twice,
          medicineCount: OnboardingMedicineCount.oneToTwo,
        ),
        isFalse,
      );
    });

    test('未回答は勧めない', () {
      expect(onboardingRecommendsPremium(careTarget: null, dailyDoseCount: null, medicineCount: null), isFalse);
    });

    test('自分と家族 (3 人) は服用者の無料上限を超えるため勧める', () {
      expect(
        onboardingRecommendsPremium(
          careTarget: OnboardingCareTarget.selfAndFamily,
          dailyDoseCount: OnboardingDailyDoseCount.once,
          medicineCount: OnboardingMedicineCount.oneToTwo,
        ),
        isTrue,
      );
    });

    test('1 日 3 回以上は通知スケジュールの無料上限を超えるため勧める', () {
      expect(
        onboardingRecommendsPremium(
          careTarget: OnboardingCareTarget.self,
          dailyDoseCount: OnboardingDailyDoseCount.threeOrMore,
          medicineCount: OnboardingMedicineCount.oneToTwo,
        ),
        isTrue,
      );
    });

    test('薬 3 種類以上は薬の無料上限を超えるため勧める', () {
      expect(
        onboardingRecommendsPremium(
          careTarget: OnboardingCareTarget.self,
          dailyDoseCount: OnboardingDailyDoseCount.once,
          medicineCount: OnboardingMedicineCount.threeToFive,
        ),
        isTrue,
      );
    });
  });
}
