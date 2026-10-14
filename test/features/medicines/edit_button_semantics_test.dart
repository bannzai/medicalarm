import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicines/page.dart';

void main() {
  // nightly E2E (maestro) がお薬一覧のカード右上の編集アイコンを tooltip の文字列で見つけられなくなったため、
  // 右下の Switch と同じく Semantics identifier で識別でき、その identifier がタップ操作を持つ編集アイコン自身のノードに付くことを検証する。
  // https://github.com/bannzai/medicalarm/issues/388
  testWidgets('お薬一覧のカードの編集アイコンが Semantics identifier で識別できる', (WidgetTester tester) async {
    final semanticsHandle = tester.ensureSemantics();

    final medicine = Medicine(
      id: 'medicine-1',
      userID: 'test-user',
      name: 'テスト薬',
      frequency: const MedicationFrequency.daily(),
      schedules: const [
        MedicationSchedule(
          id: 'schedule-1',
          hour: 10,
          minute: 0,
          quantityMemo: '',
          notificationSetting: MedicineScheduleNotificationSetting(
            isReminderEnabled: true,
            isFollowupEnabled: false,
            useCriticalAlert: false,
          ),
          focusConnectSetting: null,
        ),
      ],
      doseReceiver: const DoseReceiver(id: 'firstUser', userID: 'test-user', name: '自分'),
      memo: '',
      memoImageURL: '',
      minimumDoseIntervalHours: null,
      beganDateTime: DateTime(2026, 1, 1),
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          // MedicinesPageBody と同じく ListView の子として置く。ListView は項目ごとに Semantics ノードを作り、
          // 境界を持たない子孫のノードをそこへ束ねるため、構造を実画面に揃える
          home: Scaffold(
            body: ListView(children: [MedicinesPageSection(medicine: medicine)]),
          ),
        ),
      ),
    );

    expect(find.bySemanticsIdentifier('medicine_edit_button'), findsOneWidget);

    // identifier が ListView の項目のノードに束ねられると maestro は項目の中央をタップしてしまうため、
    // identifier を持つノードが編集アイコン (IconButton の最小タップ領域 48x48) に収まり、タップ操作を持つことも検証する
    final editButtonSemantics = tester.getSemantics(find.bySemanticsIdentifier('medicine_edit_button'));
    expect(editButtonSemantics.rect.width, lessThanOrEqualTo(kMinInteractiveDimension));
    expect(editButtonSemantics.rect.height, lessThanOrEqualTo(kMinInteractiveDimension));
    expect(editButtonSemantics.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

    // tearDown より前に SemanticsHandle の未破棄を検査されるため、テスト本文の末尾で破棄する
    semanticsHandle.dispose();
  });
}
