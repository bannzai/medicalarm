import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/delete_button.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/quantity_memo_text_field.dart';
import 'package:medicalarm/features/medicine_form/page.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';

/// Firestore に接続せず、保存しようとした schedules を記録するだけのテスト用 MedicineUpdate。
class _FakeMedicineUpdate extends MedicineUpdate {
  _FakeMedicineUpdate() : super(database: GroupDatabase(groupID: 'test-group'));

  /// 最後に call へ渡された schedules。保存されていなければ null。
  List<MedicationSchedule>? savedSchedules;

  @override
  Future<Medicine> call({
    required String medicineID,
    required Medicine medicine,
    required String name,
    required MedicationFrequency frequency,
    required List<MedicationSchedule> schedules,
    required DoseReceiver doseReceiver,
    required String memo,
    required String memoImageURL,
    required int? minimumDoseIntervalHours,
    required DateTime beganDateTime,
  }) async {
    savedSchedules = schedules;
    return medicine.copyWith(schedules: schedules);
  }
}

/// ローカル通知プラグインに触れないテスト用の RegisterReminderLocalNotification。
class _FakeRegisterReminderLocalNotification extends RegisterReminderLocalNotification {
  _FakeRegisterReminderLocalNotification(super.ref);

  @override
  Future<void> call() async {}
}

/// テスト用のスケジュール。容量欄の値だけをテストごとに変える。
MedicationSchedule _schedule({required String id, required String quantityMemo}) {
  return MedicationSchedule(
    id: id,
    hour: 8,
    minute: 0,
    quantityMemo: quantityMemo,
    notificationSetting: const MedicineScheduleNotificationSetting(isReminderEnabled: true, isFollowupEnabled: false, useCriticalAlert: false),
    focusConnectSetting: null,
  );
}

/// 編集モードの MedicineFormPage を開く。保存された schedules は返り値の fake で確認する。
Future<_FakeMedicineUpdate> _openMedicineForm(WidgetTester tester, {required List<MedicationSchedule> schedules}) async {
  // フォーム全体が1画面に収まるように十分な高さを確保する
  tester.view.physicalSize = const Size(800, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final medicine = Medicine(
    id: 'medicine-1',
    userID: 'test-user',
    name: 'テスト薬',
    frequency: const MedicationFrequency.daily(),
    schedules: schedules,
    doseReceiver: const DoseReceiver(id: 'firstUser', userID: 'test-user', name: '自分'),
    memo: '',
    memoImageURL: '',
    minimumDoseIntervalHours: null,
    beganDateTime: DateTime(2026, 1, 1),
  );
  final medicineUpdate = _FakeMedicineUpdate();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userDatabaseProvider.overrideWith((ref) => UserDatabase(userID: 'test-user')),
        currentGroupDatabaseProvider.overrideWith((ref) => GroupDatabase(groupID: 'test-group')),
        appUserIDProvider.overrideWith((ref) => 'test-user'),
        activeMedicinesProvider.overrideWith((ref) => Stream.value([medicine])),
        customerInfoProvider.overrideWith((ref) => const Stream.empty()),
        medicineUpdateProvider.overrideWith((ref) => medicineUpdate),
        registerReminderLocalNotificationProvider.overrideWith((ref) => _FakeRegisterReminderLocalNotification(ref)),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(onPressed: () => showMedicineForm(context, medicine), child: const Text('open')),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return medicineUpdate;
}

/// index 番目の容量欄に表示されている文字列。
String _quantityMemoText(WidgetTester tester, {required int index}) {
  final editableText = find.descendant(of: find.byType(MedicineScheduleQuantityMemoTextField).at(index), matching: find.byType(EditableText));
  return tester.widget<EditableText>(editableText).controller.text;
}

// お薬登録フォームの服用スケジュール行の容量欄の入力・初期表示を検証する。
// https://github.com/bannzai/medicalarm/issues/402
void main() {
  testWidgets('容量を保存済みの薬を編集で開くと容量欄に保存済みの値が表示される', (WidgetTester tester) async {
    await _openMedicineForm(
      tester,
      schedules: [_schedule(id: 'schedule-1', quantityMemo: '1錠')],
    );

    expect(_quantityMemoText(tester, index: 0), '1錠');
  });

  testWidgets('容量を入力して改行せずに保存しても入力した容量が保存される', (WidgetTester tester) async {
    final medicineUpdate = await _openMedicineForm(
      tester,
      schedules: [_schedule(id: 'schedule-1', quantityMemo: '')],
    );

    // 改行 (TextInputAction.done) を送らずに保存する
    await tester.enterText(find.byType(MedicineScheduleQuantityMemoTextField), '2錠');
    await tester.pump();
    await tester.tap(find.text(L.save));
    await tester.pumpAndSettle();

    expect(medicineUpdate.savedSchedules?.single.quantityMemo, '2錠');
  });

  testWidgets('先頭の服用スケジュールを削除すると残った行の容量欄に残った行の値が表示される', (WidgetTester tester) async {
    await _openMedicineForm(
      tester,
      schedules: [
        _schedule(id: 'schedule-1', quantityMemo: '1錠'),
        _schedule(id: 'schedule-2', quantityMemo: '2錠'),
      ],
    );

    await tester.tap(find.byType(MedicineScheduleDeleteButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(MedicineScheduleQuantityMemoTextField), findsOneWidget);
    expect(_quantityMemoText(tester, index: 0), '2錠');
  });
}
