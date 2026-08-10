import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/features/calendar/components/day_detail_sheet.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/diary.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// 非プレミアム(entitlements.active が空)の CustomerInfo。main.dart の emulator 用 fake と同じ形
CustomerInfo buildFreeCustomerInfo() {
  return CustomerInfo.fromJson({
    'entitlements': {'all': <String, dynamic>{}, 'active': <String, dynamic>{}, 'verification': 'FAILED'},
    'allPurchaseDates': <String, dynamic>{},
    'activeSubscriptions': <String>[],
    'allPurchasedProductIdentifiers': <String>[],
    'nonSubscriptionTransactions': <dynamic>[],
    'firstSeen': '2026-01-01T00:00:00Z',
    'originalAppUserId': 'test_user',
    'allExpirationDates': <String, dynamic>{},
    'requestDate': '2026-01-01T00:00:00Z',
  });
}

/// CalendarDayDetailSheet が watch する日記クエリと同一の日付範囲(対象日の 00:00:00 〜 23:59:59)
DateTimeRange dayRange(DateTime date) {
  return DateTimeRange(
    start: date.date(),
    end: date.date().add(const Duration(days: 1)).subtract(const Duration(seconds: 1)),
  );
}

/// provider を差し替えて CalendarDayDetailSheet を単体で描画する
Widget buildSheet({required DateTime date, required List<Override> overrides}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(home: CalendarDayDetailSheet(date: date)),
  );
}

void main() {
  group('CalendarDayDetailSheet 日記セクション', () {
    // 日記クエリのロード中に「日記を書く」を出すと、既存日記がある日に重複ドキュメントを作成できてしまう回帰を防ぐ
    testWidgets('日記ロード中は「日記を書く」を表示しない', (tester) async {
      final date = today();
      await tester.pumpWidget(buildSheet(date: date, overrides: [
        // 値を流さない Stream でロード中状態を維持する
        diariesForDateTimeRangeProvider(dateTimeRange: dayRange(date)).overrideWith((ref) => const Stream<List<Diary>>.empty()),
        medicationHistoriesByDateProvider(date).overrideWith((ref) => Stream.value(<MedicationHistory>[])),
        customerInfoProvider.overrideWith((ref) => Stream.value(buildFreeCustomerInfo())),
      ]));
      await tester.pump();

      expect(find.text(L.writeDiary), findsNothing);
    });

    testWidgets('日記が無いと確定したら「日記を書く」を表示する', (tester) async {
      final date = today();
      await tester.pumpWidget(buildSheet(date: date, overrides: [
        diariesForDateTimeRangeProvider(dateTimeRange: dayRange(date)).overrideWith((ref) => Stream.value(<Diary>[])),
        medicationHistoriesByDateProvider(date).overrideWith((ref) => Stream.value(<MedicationHistory>[])),
        customerInfoProvider.overrideWith((ref) => Stream.value(buildFreeCustomerInfo())),
      ]));
      await tester.pump();
      await tester.pump();

      expect(find.text(L.writeDiary), findsOneWidget);
    });

    testWidgets('日記がある日はメモを表示し「日記を書く」は出さない', (tester) async {
      final date = today();
      await tester.pumpWidget(buildSheet(date: date, overrides: [
        diariesForDateTimeRangeProvider(dateTimeRange: dayRange(date)).overrideWith(
          (ref) => Stream.value([Diary(id: 'diary-1', userID: 'user-a', memo: '今日の体調メモ', diaryDate: date)]),
        ),
        medicationHistoriesByDateProvider(date).overrideWith((ref) => Stream.value(<MedicationHistory>[])),
        customerInfoProvider.overrideWith((ref) => Stream.value(buildFreeCustomerInfo())),
      ]));
      await tester.pump();
      await tester.pump();

      expect(find.text('今日の体調メモ'), findsOneWidget);
      expect(find.text(L.writeDiary), findsNothing);
    });
  });

  group('CalendarDayDetailSheet プレミアム制限', () {
    // 課金状態が未解決のまま過去日の記録を描画すると、解決の遅延・失敗時にプレミアム制限を迂回できてしまう回帰を防ぐ
    testWidgets('過去日で課金状態が未解決の間は服薬記録を表示しない', (tester) async {
      final date = today().addDays(-1);
      await tester.pumpWidget(buildSheet(date: date, overrides: [
        diariesForDateTimeRangeProvider(dateTimeRange: dayRange(date)).overrideWith((ref) => Stream.value(<Diary>[])),
        medicationHistoriesByDateProvider(date).overrideWith((ref) => Stream.value(<MedicationHistory>[])),
        // 値を流さない Stream で課金状態の未解決状態を維持する
        customerInfoProvider.overrideWith((ref) => const Stream<CustomerInfo>.empty()),
      ]));
      await tester.pump();
      await tester.pump();

      expect(find.text(L.noMedicationHistory), findsNothing);
      expect(find.text(L.premiumRequired), findsNothing);
    });

    testWidgets('過去日で非プレミアムなら服薬記録の代わりにプレミアム誘導カードを表示する', (tester) async {
      final date = today().addDays(-1);
      await tester.pumpWidget(buildSheet(date: date, overrides: [
        diariesForDateTimeRangeProvider(dateTimeRange: dayRange(date)).overrideWith((ref) => Stream.value(<Diary>[])),
        medicationHistoriesByDateProvider(date).overrideWith((ref) => Stream.value(<MedicationHistory>[])),
        customerInfoProvider.overrideWith((ref) => Stream.value(buildFreeCustomerInfo())),
      ]));
      await tester.pump();
      await tester.pump();

      expect(find.text(L.premiumRequired), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      // 制限中は服薬記録セクション自体を描画しない(空表示も出さない)
      expect(find.text(L.noMedicationHistory), findsNothing);
    });
  });
}
