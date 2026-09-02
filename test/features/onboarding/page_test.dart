import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/onboarding/components/plan_generating_step.dart';
import 'package:medicalarm/features/onboarding/page.dart';
import 'package:medicalarm/style/color.dart';

void main() {
  /// iPhone 相当の論理サイズで描画し、RenderFlex overflow 等のレイアウト例外をテスト失敗として検出する。
  /// [size] と [textScaler] で狭い画面・大きな文字サイズの条件も再現する
  Future<void> pumpOnboarding(
    WidgetTester tester, {
    required bool isShortForm,
    required VoidCallback onPlanStartPressed,
    Size size = const Size(390, 844),
    TextScaler textScaler = TextScaler.noScaling,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, primary: AppColors.primary),
            useMaterial3: false,
          ),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: textScaler),
            child: child!,
          ),
          home: OnboardingPage(isShortForm: isShortForm, onPlanStartPressed: onPlanStartPressed),
        ),
      ),
    );
  }

  /// 選択肢をタップして画面遷移のアニメーションを終える。狭い画面ではスクロールしないと押せないため表示位置まで送る
  Future<void> tapAndSettle(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text));
    await tester.pumpAndSettle();
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  /// 長尺 (US) のファネルを最初から最後まで進め、結果画面が表示されるまで待つ
  Future<void> walkThroughLongForm(WidgetTester tester) async {
    await tapAndSettle(tester, L.onboardingStart);
    await tapAndSettle(tester, L.onboardingFrequencyOften);

    expect(find.text(L.onboardingPainWorryTitle), findsOneWidget);
    await tapAndSettle(tester, L.onboardingFrequencyOften);

    expect(find.text(L.onboardingValueReminderTitle), findsOneWidget);
    await tapAndSettle(tester, L.onboardingNext);

    expect(find.text(L.onboardingCareTargetTitle), findsOneWidget);
    await tapAndSettle(tester, L.onboardingCareTargetSelfAndFamily);
    await tapAndSettle(tester, L.onboardingDailyDoseThreeOrMore);
    await tapAndSettle(tester, L.onboardingMedicineCountSixOrMore);

    expect(find.text(L.onboardingBeforeAfterTitle), findsOneWidget);
    await tapAndSettle(tester, L.onboardingNext);

    expect(find.text(L.onboardingGoalTitle), findsOneWidget);
    await tester.ensureVisible(find.text(L.onboardingGoalWatchFamily));
    await tester.pumpAndSettle();
    await tester.tap(find.text(L.onboardingGoalWatchFamily));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // プラン生成演出が表示され、所定時間の経過で自動的に結果画面へ進む
    expect(find.text(L.onboardingPlanGeneratingTitle), findsOneWidget);
    await tester.pump(OnboardingPlanGeneratingStep.duration);
    await tester.pumpAndSettle();
  }

  testWidgets('JP 短尺: 価値宣言 → 質問 3 つ → プラン生成 → 結果提示の順に進み CTA でコールバックが呼ばれる', (tester) async {
    var planStartPressedCount = 0;
    await pumpOnboarding(tester, isShortForm: true, onPlanStartPressed: () => planStartPressedCount++);

    expect(find.text(L.onboardingWelcomeTitle), findsOneWidget);
    await tapAndSettle(tester, L.onboardingStart);

    expect(find.text(L.onboardingPainForgotTitle), findsOneWidget);
    await tapAndSettle(tester, L.onboardingFrequencySometimes);

    expect(find.text(L.onboardingCareTargetTitle), findsOneWidget);
    await tapAndSettle(tester, L.onboardingCareTargetSelf);

    expect(find.text(L.onboardingDailyDoseCountTitle), findsOneWidget);
    await tapAndSettle(tester, L.onboardingDailyDoseTwice);

    expect(find.text(L.onboardingMedicineCountTitle), findsOneWidget);
    await tester.tap(find.text(L.onboardingMedicineCountOneToTwo));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // プラン生成演出が表示され、所定時間の経過で自動的に結果画面へ進む
    expect(find.text(L.onboardingPlanGeneratingTitle), findsOneWidget);
    await tester.pump(OnboardingPlanGeneratingStep.duration);
    await tester.pumpAndSettle();

    expect(find.text(L.onboardingPlanResultTitle), findsOneWidget);
    // 回答した内容が結果画面に反映される
    expect(find.text(L.onboardingCareTargetSelf), findsOneWidget);
    expect(find.text(L.onboardingDailyDoseTwice), findsOneWidget);
    expect(find.text(L.onboardingMedicineCountOneToTwo), findsOneWidget);
    // 無料枠に収まる回答ではプレミアム訴求を出さない
    expect(find.text(L.onboardingPremiumRecommendedTitle), findsNothing);

    await tester.tap(find.text(L.onboardingPlanStart));
    await tester.pump();
    expect(planStartPressedCount, 1);
  });

  testWidgets('US 長尺: 価値提示・Before/After・目標設定を含む全画面を通過し、目標と上限超過のプレミアム訴求が結果に反映される', (tester) async {
    var planStartPressedCount = 0;
    await pumpOnboarding(tester, isShortForm: false, onPlanStartPressed: () => planStartPressedCount++);

    await walkThroughLongForm(tester);

    expect(find.text(L.onboardingPlanResultTitle), findsOneWidget);
    expect(find.text(L.onboardingPlanResultGoalFormat(L.onboardingGoalWatchFamily)), findsOneWidget);
    expect(find.text(L.onboardingPremiumRecommendedTitle), findsOneWidget);

    await tester.tap(find.text(L.onboardingPlanStart));
    await tester.pump();
    expect(planStartPressedCount, 1);
  });

  testWidgets('結果画面は文字サイズ 2 倍・幅 320 でも overflow しない', (tester) async {
    await pumpOnboarding(
      tester,
      isShortForm: false,
      onPlanStartPressed: () {},
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2.0),
    );

    await walkThroughLongForm(tester);

    // RenderFlex overflow が起きると例外でテストが失敗するため、結果画面まで到達できれば overflow していない
    expect(find.text(L.onboardingPlanResultTitle), findsOneWidget);
  });

  testWidgets('戻るボタンで前の質問へ戻り、回答済みの選択肢が保持される', (tester) async {
    await pumpOnboarding(tester, isShortForm: true, onPlanStartPressed: () {});

    await tapAndSettle(tester, L.onboardingStart);
    // 価値宣言の次 (最初の質問) から戻るボタンが出る
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    await tapAndSettle(tester, L.onboardingFrequencyOften);
    expect(find.text(L.onboardingCareTargetTitle), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text(L.onboardingPainForgotTitle), findsOneWidget);
    // 回答済みの選択肢は枠線が primary で強調される
    final selectedContainer = tester.widget<Container>(
      find.ancestor(of: find.text(L.onboardingFrequencyOften), matching: find.byType(Container)).first,
    );
    expect((selectedContainer.decoration! as BoxDecoration).border!.top.color, AppColors.primary);
  });

  testWidgets('価値宣言の画面には戻るボタンを出さない', (tester) async {
    await pumpOnboarding(tester, isShortForm: true, onPlanStartPressed: () {});

    expect(find.byIcon(Icons.arrow_back), findsNothing);
  });

  testWidgets('遷移アニメーションの完了後は戻るボタンが有効になる', (tester) async {
    await pumpOnboarding(tester, isShortForm: true, onPlanStartPressed: () {});

    await tester.tap(find.text(L.onboardingStart));
    await tester.pump();
    // 遷移中は無効
    expect(tester.widget<IconButton>(find.byType(IconButton)).onPressed, isNull);

    await tester.pump(OnboardingPage.transitionDuration);
    expect(tester.widget<IconButton>(find.byType(IconButton)).onPressed, isNotNull);
  });

  testWidgets('遷移中は戻るボタンが無効になり、連打しても 1 ステップしか戻らない', (tester) async {
    await pumpOnboarding(tester, isShortForm: true, onPlanStartPressed: () {});

    await tapAndSettle(tester, L.onboardingStart);
    await tapAndSettle(tester, L.onboardingFrequencyOften);
    await tapAndSettle(tester, L.onboardingCareTargetSelf);
    expect(find.text(L.onboardingDailyDoseCountTitle), findsOneWidget);

    // 1 回目の戻るで遷移が始まった直後 (settle しない) に 2 回目を押しても、戻るボタンは無効なので反応しない
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    expect(tester.widget<IconButton>(find.byType(IconButton)).onPressed, isNull);
    await tester.tap(find.byIcon(Icons.arrow_back), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text(L.onboardingCareTargetTitle), findsOneWidget);
    expect(find.text(L.onboardingPainForgotTitle), findsNothing);
  });
}
