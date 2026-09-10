import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/entity/onboarding_medication_plan.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medications/components/placeholder_cards.dart';
import 'package:medicalarm/features/medicine_form/page.dart';
import 'package:medicalarm/features/onboarding/components/medication_registration_page.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// 未登録のカードと登録誘導の表示に使う保存済みプラン。
OnboardingMedicationPlan _plan() => OnboardingMedicationPlan(
      userID: 'test-user',
      groupID: 'test-group',
      doseReceiverID: 'firstUser',
      createdDateTime: DateTime(2026, 9, 8),
      schedules: [
        for (final hour in [8, 12, 19])
          MedicationSchedule(
            id: 'test-$hour',
            hour: hour,
            minute: 0,
            quantityMemo: '',
            notificationSetting: const MedicineScheduleNotificationSetting(
              isReminderEnabled: true,
              isFollowupEnabled: false,
              useCriticalAlert: false,
            ),
            focusConnectSetting: null,
          ),
      ],
    );

/// UI の時刻表示・後回し導線・未登録と実薬の区別を検証する。
void main() {
  testWidgets('登録誘導は狭い画面と大きな文字でも時刻と後回しボタンを表示できる', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [customerInfoProvider.overrideWith((ref) => const Stream<CustomerInfo>.empty())],
      child: MaterialApp(
        builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(2)), child: child!),
        home: OnboardingMedicationRegistrationPage(schedules: _plan().schedules),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text(L.onboardingMedicationLater), findsOneWidget);
    await tester.ensureVisible(find.text('19:00'));
    await tester.pumpAndSettle();
    expect(find.text('08:00'), findsOneWidget);
    expect(find.text('12:00'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('あとでを選ぶと登録フォームを開かず元の画面へ進む', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [customerInfoProvider.overrideWith((ref) => const Stream<CustomerInfo>.empty())],
      child: MaterialApp(
        home: Scaffold(body: Builder(builder: (context) {
          return TextButton(
            onPressed: () => Navigator.of(context).push<void>(MaterialPageRoute(
              builder: (context) => OnboardingMedicationRegistrationPage(schedules: _plan().schedules),
            )),
            child: const Text('登録案内を開く'),
          );
        })),
      ),
    ));
    await tester.tap(find.text('登録案内を開く'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(L.onboardingMedicationLater));
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingMedicationRegistrationPage), findsNothing);
    expect(find.text('登録案内を開く'), findsOneWidget);
  });

  testWidgets('課金情報が未取得でも無料上限内の時刻を引き継いで登録フォームを開ける', (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        customerInfoProvider.overrideWith((ref) => const Stream<CustomerInfo>.empty()),
        userDatabaseProvider.overrideWith((ref) => UserDatabase(userID: 'test-user')),
        currentGroupDatabaseProvider.overrideWith((ref) => GroupDatabase(groupID: 'test-group')),
        appUserIDProvider.overrideWith((ref) => 'test-user'),
      ],
      child: MaterialApp(home: Scaffold(body: Builder(builder: (context) {
        return TextButton(
          onPressed: () => Navigator.of(context).push<void>(MaterialPageRoute(
            builder: (context) => OnboardingMedicationRegistrationPage(schedules: _plan().schedules),
          )),
          child: const Text('登録案内を開く'),
        );
      }))),
    ));
    await tester.tap(find.text('登録案内を開く'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(L.addMedicine));
    await tester.pumpAndSettle();
    expect(tester.widget<MedicineFormPage>(find.byType(MedicineFormPage)).initialSchedules.map((schedule) => schedule.hour), [8, 12]);
    expect(find.text('08:00'), findsWidgets);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingMedicationRegistrationPage), findsNothing);
    expect(find.text('登録案内を開く'), findsOneWidget);
  });

  testWidgets('仮カードは時刻と服用者と登録案内を表示し服薬チェック欄を持たない', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [customerInfoProvider.overrideWith((ref) => const Stream<CustomerInfo>.empty())],
      child: MaterialApp(
        builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(2)), child: child!),
        home: Scaffold(
            body: SingleChildScrollView(
                child: MedicationPlaceholderTile(
          plan: _plan(),
          schedule: _plan().schedules.first,
          doseReceiverName: '自分',
        ))),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('08:00'), findsOneWidget);
    expect(find.text('自分'), findsOneWidget);
    expect(find.text(L.onboardingMedicationPlaceholderTitle), findsOneWidget);
    expect(find.text(L.delete), findsOneWidget);
    expect(find.byType(Checkbox), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
