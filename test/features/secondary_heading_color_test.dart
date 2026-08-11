import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/features/medication_frequency_form/components/section_layout.dart';
import 'package:medicalarm/features/medicine_form/components/section_layout.dart';
import 'package:medicalarm/features/settings/components/section.dart';
import 'package:medicalarm/style/color.dart';

// #265: 画面がピンク一色にならないよう、セクション見出しはアクセントカラー(secondary)で描画する。
// primary へ戻ってしまう回帰を検出するためのテスト。
void main() {
  // テーマの secondary が見出しへ反映されることを確認する番兵色。
  // AppColors の実値と無関係な値にして、primary へのフォールバックや定数直書きを区別できるようにする
  const sentinelPrimary = Color(0xFF654321);
  const sentinelSecondary = Color(0xFF123456);

  /// 対象 widget をアプリと同じ Material 2 テーマ(番兵色入り)配下で描画する。
  Widget wrapWithTheme({required Widget child}) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: sentinelPrimary,
          primary: sentinelPrimary,
          secondary: sentinelSecondary,
        ),
        useMaterial3: false,
      ),
      home: Scaffold(body: child),
    );
  }

  testWidgets('MedicineFormSectionLayout の見出しテキストとアイコンは colorScheme.secondary で描画される', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      child: const MedicineFormSectionLayout(icon: Icons.medication, text: '見出し', children: []),
    ));

    expect(tester.widget<Text>(find.text('見出し')).style?.color, sentinelSecondary);
    expect(tester.widget<Icon>(find.byIcon(Icons.medication)).color, sentinelSecondary);
  });

  testWidgets('MedicationFrequencyFormSectionLayout の見出しテキストとアイコンは colorScheme.secondary で描画される', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      child: const MedicationFrequencyFormSectionLayout(icon: Icons.schedule, text: '見出し', children: []),
    ));

    expect(tester.widget<Text>(find.text('見出し')).style?.color, sentinelSecondary);
    expect(tester.widget<Icon>(find.byIcon(Icons.schedule)).color, sentinelSecondary);
  });

  testWidgets('SettingSectionTitle の見出しテキストは AppColors.secondary で描画される', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      child: const SettingSectionTitle(text: '見出し', children: []),
    ));

    expect(tester.widget<Text>(find.text('見出し')).style?.color, AppColors.secondary);
  });

  test('AppColors.secondary は primary と異なるアクセントカラーである', () {
    // #265 の完了条件そのもの: secondary がピンク(primary)系のままではないこと
    expect(AppColors.secondary, isNot(AppColors.primary));
  });
}
