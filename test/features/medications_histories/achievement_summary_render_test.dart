import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medications_histories/components/achievement_summary.dart';
import 'package:medicalarm/l10n/app_localizations.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';

/// 履歴タブの達成サマリー (#278) が、provider のデータが揃った時にカードを描画することの確認。
/// シミュレータ検証でサマリーが表示されなかった事象の切り分け (widget 層 or provider 層) に使う
void main() {
  testWidgets('データが揃うと今週の服薬と連続記録のカードが表示される', (tester) async {
    final medicine = Medicine(
      userID: 'user-1',
      id: 'medicine-1',
      name: 'Vitamin',
      frequency: const MedicationFrequency.daily(),
      schedules: [
        const MedicationSchedule(
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
      doseReceiver: const DoseReceiver(id: 'receiver-1', name: 'User', userID: 'user-1'),
      memo: '',
      memoImageURL: '',
      minimumDoseIntervalHours: null,
      beganDateTime: DateTime.now().subtract(const Duration(days: 3)),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allMedicinesProvider.overrideWith((ref) => Stream.value([medicine])),
          medicationHistoriesByDateRangeProvider(medicationAchievementLookbackDateTimeRange(today: today()))
              .overrideWith((ref) => Stream.value([])),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: MedicationAchievementSummary()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // ja ロケール既定 (Intl.defaultLocale 非依存の widget テストでは英語になる場合があるため両方許容)
    expect(find.textContaining(RegExp('今週の服薬|This week')), findsOneWidget);
    expect(find.textContaining(RegExp('連続記録|Streak')), findsOneWidget);
  });
}
