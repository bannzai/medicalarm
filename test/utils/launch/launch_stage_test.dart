import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/utils/launch/launch_stage.dart';

/// 経過時間を固定した記録を作る。
LaunchStageEntry _entry({required String kind, required String stage, String? detail}) {
  return (elapsed: const Duration(milliseconds: 1500), kind: kind, stage: stage, detail: detail);
}

void main() {
  group('pendingLaunchStages', () {
    test('開始だけで完了も失敗も無い段階を返す', () {
      expect(
        pendingLaunchStages(
          entries: [_entry(kind: 'start', stage: 'GroupMigration serverAppUserFetch')],
        ),
        ['GroupMigration serverAppUserFetch'],
      );
    });

    test('完了した段階と失敗した段階は返さない', () {
      expect(
        pendingLaunchStages(
          entries: [
            _entry(kind: 'start', stage: 'signInAnonymously'),
            _entry(kind: 'done', stage: 'signInAnonymously'),
            _entry(kind: 'start', stage: 'AppUserCreate'),
            _entry(kind: 'fail', stage: 'AppUserCreate', detail: 'unavailable'),
          ],
        ),
        isEmpty,
      );
    });

    test('完了の後にもう一度開始した段階は返す (再試行で止まった時)', () {
      expect(
        pendingLaunchStages(
          entries: [
            _entry(kind: 'start', stage: 'cancelOnboardingMedicationPlanNotifications'),
            _entry(kind: 'done', stage: 'cancelOnboardingMedicationPlanNotifications'),
            _entry(kind: 'start', stage: 'cancelOnboardingMedicationPlanNotifications'),
          ],
        ),
        ['cancelOnboardingMedicationPlanNotifications'],
      );
    });

    test('到達点の記録 (reached) は完了待ちとして扱わない', () {
      expect(
        pendingLaunchStages(
          entries: [_entry(kind: 'reached', stage: 'Resolved: AuthResolver')],
        ),
        isEmpty,
      );
    });

    test('完了していない段階が複数あれば開始の順に返す', () {
      expect(
        pendingLaunchStages(
          entries: [
            _entry(kind: 'start', stage: 'initializePurchase'),
            _entry(kind: 'start', stage: 'AppUserCreate'),
            _entry(kind: 'done', stage: 'AppUserCreate'),
            _entry(kind: 'start', stage: 'GroupMigration serverAppUserFetch'),
          ],
        ),
        ['initializePurchase', 'GroupMigration serverAppUserFetch'],
      );
    });
  });

  group('traceLaunchStage', () {
    setUp(launchStageEntries.clear);

    test('完了した処理は start と done を記録し、結果をそのまま返す', () async {
      expect(await traceLaunchStage(stage: 'AppUserCreate', operation: () async => 'ok'), 'ok');
      expect(launchStageEntries.map((entry) => entry.kind), ['start', 'done']);
    });

    test('失敗した処理は start と fail を記録し、例外をそのまま投げ直す', () async {
      await expectLater(traceLaunchStage(stage: 'AppUserCreate', operation: () async => throw StateError('unavailable')), throwsStateError);
      expect(launchStageEntries.map((entry) => entry.kind), ['start', 'fail']);
      expect(launchStageEntries.last.detail, contains('unavailable'));
    });
  });

  group('recordLaunchStageOnce', () {
    setUp(launchStageEntries.clear);

    test('同じ到達点は build のたびに呼ばれても 1 回だけ記録する', () {
      recordLaunchStageOnce(stage: 'Resolved: AuthResolver');
      recordLaunchStageOnce(stage: 'Resolved: AuthResolver');
      expect(launchStageEntries, hasLength(1));
    });

    test('別の到達点はそれぞれ記録する', () {
      recordLaunchStageOnce(stage: 'Resolved: AuthResolver');
      recordLaunchStageOnce(stage: 'Resolved: AppUserCreateResolver');
      expect(launchStageEntries, hasLength(2));
    });
  });

  test('launchStageEntryText は経過秒・種別・段階・補足を 1 行にする', () {
    expect(
      launchStageEntryText(
        entry: _entry(kind: 'reached', stage: 'Resolved: AuthResolver', detail: 'uid=abc'),
      ),
      '1.5s reached Resolved: AuthResolver (uid=abc)',
    );
    expect(
      launchStageEntryText(
        entry: _entry(kind: 'start', stage: 'AppUserCreate'),
      ),
      '1.5s start AppUserCreate',
    );
  });

  group('IndicatorPage の起動の段階の表示 (DEBUG)', () {
    setUp(launchStageEntries.clear);

    testWidgets('完了していない段階と記録をスピナーの下に表示する', (tester) async {
      recordLaunchStageOnce(stage: 'Resolved: PurchaseSetupResolver');
      recordLaunchStage(kind: 'start', stage: 'GroupMigration serverAppUserFetch');
      await tester.pumpWidget(const MaterialApp(home: IndicatorPage()));

      expect(find.text('pending: GroupMigration serverAppUserFetch'), findsOneWidget);
      expect(find.textContaining('reached Resolved: PurchaseSetupResolver'), findsOneWidget);
    });

    testWidgets('表示の後に増えた記録を 1 秒以内に描き直す', (tester) async {
      recordLaunchStage(kind: 'start', stage: 'AppUserCreate');
      await tester.pumpWidget(const MaterialApp(home: IndicatorPage()));
      expect(find.text('pending: AppUserCreate'), findsOneWidget);

      recordLaunchStage(kind: 'done', stage: 'AppUserCreate');
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('pending: -'), findsOneWidget);
    });

    testWidgets('記録が無ければ何も表示しない', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: IndicatorPage()));
      expect(find.textContaining('pending:'), findsNothing);
    });
  });
}
