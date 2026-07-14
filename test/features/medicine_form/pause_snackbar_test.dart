import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_form/components/pause/tile.dart';
import 'package:medicalarm/features/medicine_form/page.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';

/// Firestore に接続せず、pausedDateTime を反映した Medicine を返すだけのテスト用 MedicineSetPaused。
class _FakeMedicineSetPaused extends MedicineSetPaused {
  _FakeMedicineSetPaused() : super(database: GroupDatabase(groupID: 'test-group'));

  @override
  Future<Medicine> call({
    required String medicineID,
    required Medicine medicine,
    required DateTime? pausedDateTime,
  }) async {
    return medicine.copyWith(pausedDateTime: pausedDateTime);
  }
}

/// ローカル通知プラグインに触れないテスト用の RegisterReminderLocalNotification。
class _FakeRegisterReminderLocalNotification extends RegisterReminderLocalNotification {
  _FakeRegisterReminderLocalNotification(super.ref);

  @override
  Future<void> call() async {}
}

void main() {
  // 編集モードの MedicineFormPage(全画面モーダル)で一時停止トグルを操作した時に、
  // SnackBar がモーダルの背後(ルートの ScaffoldMessenger)ではなくモーダル内に表示されることを検証する。
  // https://github.com/bannzai/medicalarm/issues/245
  testWidgets('お薬登録フォーム(モーダル)内の一時停止トグルで SnackBar がモーダル内に表示される', (WidgetTester tester) async {
    // フォーム全体と一時停止トグルが1画面に収まるように十分な高さを確保する
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final medicine = Medicine(
      id: 'medicine-1',
      userID: 'test-user',
      name: 'テスト薬',
      frequency: const MedicationFrequency.daily(),
      schedules: const [
        MedicationSchedule(
          id: 'schedule-1',
          hour: 8,
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
      beganDateTime: DateTime(2026, 1, 1),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userDatabaseProvider.overrideWith((ref) => UserDatabase(userID: 'test-user')),
          // グループ機能 (#241) で medicine 系 provider は currentGroupDatabase を参照するようになったため上書きする
          currentGroupDatabaseProvider.overrideWith((ref) => GroupDatabase(groupID: 'test-group')),
          appUserIDProvider.overrideWith((ref) => 'test-user'),
          activeMedicinesProvider.overrideWith((ref) => Stream.value([medicine])),
          customerInfoProvider.overrideWith((ref) => const Stream.empty()),
          medicineSetPausedProvider.overrideWith((ref) => _FakeMedicineSetPaused()),
          registerReminderLocalNotificationProvider.overrideWith((ref) => _FakeRegisterReminderLocalNotification(ref)),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showMedicineForm(context, medicine),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // 編集モードなので一時停止トグルが表示される
    expect(find.byType(MedicinePauseTile), findsOneWidget);

    await tester.tap(find.descendant(of: find.byType(MedicinePauseTile), matching: find.byType(Switch)));
    await tester.pumpAndSettle();

    // SnackBar がモーダル(MedicineFormPage)内の ScaffoldMessenger に表示されること。
    // 修正前はルートの ScaffoldMessenger に表示されるため MedicineFormPage の子孫には存在しない
    expect(find.text(L.medicinePausedSnackbar), findsOneWidget);
    expect(find.descendant(of: find.byType(MedicineFormPage), matching: find.byType(SnackBar)), findsOneWidget);

    // SnackBar の自動クローズタイマーを消化して pending timer を残さない
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });
}
