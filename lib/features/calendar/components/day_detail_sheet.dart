import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/features/diary_post/page.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medications_histories/page.dart';
import 'package:medicalarm/features/preium_introduction/premium_introduction_sheet.dart';
import 'package:medicalarm/provider/diary.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/theme/form.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';

/// カレンダーの日付タップで開く、その日の服薬記録の振り返りと日記の閲覧・投稿をまとめたシート (#62)
class CalendarDayDetailSheet extends HookConsumerWidget {
  final DateTime date;

  const CalendarDayDetailSheet({super.key, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // DiaryPostPage で保存して戻った直後の内容をシートに反映するため、タップ時点の値を引き回さず provider を watch する
    final diariesAsync = ref.watch(diariesForDateTimeRangeProvider(
        dateTimeRange: DateTimeRange(start: date.date(), end: date.date().add(const Duration(days: 1)).subtract(const Duration(seconds: 1)))));
    final diary = diariesAsync.valueOrNull?.firstWhereOrNull((diary) => isSameDay(diary.diaryDate, date));
    final medicationHistories = ref.watch(medicationHistoriesByDateProvider(date));
    final customerInfo = ref.watch(customerInfoProvider).asData?.value;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.8,
      builder: (context, scrollController) {
        return FormTheme(
          child: Scaffold(
            appBar: AppBar(
              title: Text(DateFormat(DateFormat.YEAR_MONTH_DAY).format(date), style: TextStyle(color: primaryColor)),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(L.diary, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor)),
                          const Spacer(),
                          if (diary != null) ...[
                            IconButton(
                              tooltip: L.editDiaryTooltip,
                              onPressed: () {
                                analytics.logEvent(name: 'calendar_day_edit_diary_button_pressed');
                                Navigator.of(context).push(DiaryPostPageRoute.route(date, diary));
                              },
                              icon: const Icon(Icons.edit, size: 20),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // 日記が無いと取得完了後に確定するまで「日記を書く」を出さない。
                    // ロード中に出すと、既存日記がある日にタップされた場合に別ドキュメントが重複作成されてしまう
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: diariesAsync.when(
                        data: (diaries) {
                          final loadedDiary = diaries.firstWhereOrNull((diary) => isSameDay(diary.diaryDate, date));
                          if (loadedDiary == null) {
                            return TextButton.icon(
                              onPressed: () {
                                analytics.logEvent(name: 'calendar_day_write_diary_button_pressed');
                                Navigator.of(context).push(DiaryPostPageRoute.route(date, null));
                              },
                              icon: const Icon(Icons.add),
                              label: Text(L.writeDiary, style: const TextStyle(fontWeight: FontWeight.bold)),
                            );
                          }
                          return Text(loadedDiary.memo);
                        },
                        error: (error, _) => Text(error.toString()),
                        loading: () => const SizedBox(width: double.infinity, height: 48, child: Indicator()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // テーマの dividerColor (黒) を避け、カレンダーの罫線と揃えた薄い色にする
                    const Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(L.medicationHistory, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor)),
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        // 課金状態が未解決(customerInfo が null)の間は過去日の服薬記録を描画しない(フェイルクローズ)。
                        // 描画すると、課金状態の解決が遅い・失敗した場合にプレミアム制限を迂回して過去の記録を閲覧できてしまう
                        if (date.isBefore(today()) && customerInfo == null) ...[
                          const SizedBox(width: double.infinity, height: 120, child: Indicator()),
                        ] else ...[
                          medicationHistories.when(
                            data: (histories) {
                              if (histories.isEmpty) {
                                return SizedBox(
                                  width: double.infinity,
                                  // プレミアム誘導のぼかしオーバーレイ(Positioned.fill)が潰れない程度の空表示エリアを確保する
                                  height: 120,
                                  child: const MedicationHistoryEmpty(),
                                );
                              }
                              return Column(
                                children: [
                                  for (final history in histories) ...[
                                    // 履歴画面と同様に、取消(revert)の記録も服薬記録と同じ一覧に行として表示する (#253)
                                    if (history.action is RevertMedicationHistoryAction) ...[
                                      MedicationHistoryRevertTile(history: history),
                                    ] else ...[
                                      MedicationHistoryTile(history: history),
                                    ],
                                    const SizedBox(height: 10),
                                  ],
                                ],
                              );
                            },
                            error: (error, _) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(error.toString()),
                            ),
                            loading: () => const SizedBox(width: double.infinity, height: 120, child: Indicator()),
                          ),
                        ],
                        // 履歴画面(medications_histories)と同じ条件で過去日の服薬記録の閲覧をプレミアム加入者に限定し、
                        // カレンダー経由で閲覧制限を迂回できないようにする
                        if (customerInfo?.hasPremiumEntitlement == false && date.isBefore(today())) ...[
                          Positioned.fill(
                            child: ClipRRect(
                              child: Stack(
                                children: [
                                  BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                    child: Container(
                                      color: Colors.black.withValues(alpha: 0.5),
                                    ),
                                  ),
                                  Center(
                                    child: TextButton(
                                      onPressed: () {
                                        showPremiumIntroductionSheet(context);
                                      },
                                      child: Text(
                                        L.premiumRequired,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// [CalendarDayDetailSheet] をモーダルボトムシートとして表示する
void showCalendarDayDetailSheet(BuildContext context, {required DateTime date}) {
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CalendarDayDetailSheet(date: date),
  );
}
