import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/components/calendar/day/today_badge.dart';
import 'package:medicalarm/components/calendar/weekly/pager.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/components/text/edit_sheet.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/features/medications_histories/components/achievement_summary.dart';
import 'package:medicalarm/features/preium_introduction/premium_introduction_sheet.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/current_group_id.dart';
import 'package:medicalarm/provider/group_user_profile.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';
import 'package:medicalarm/features/localization/l.dart';

class MedicationHistoriesPage extends HookConsumerWidget {
  const MedicationHistoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = useState(today());
    final page = useState(todayCalendarPageIndex);
    final pageController = usePageController(initialPage: page.value);
    pageController.addListener(() {
      final pageControllerPage = pageController.page;
      if (pageControllerPage != null) {
        page.value = pageControllerPage.toInt();
      }
    });
    final medicationHistoriesAsync = ref.watch(medicationHistoriesByDateProvider(date.value));
    final medicationHistories = useState(medicationHistoriesAsync.asData?.valueOrNull ?? []);

    useEffect(() {
      final asyncValue = medicationHistoriesAsync.asData;
      if (asyncValue != null) {
        medicationHistories.value = asyncValue.value;
      }
      return null;
    }, [medicationHistoriesAsync.asData?.valueOrNull]);

    return Retry(
      retry: () => ref.invalidate(medicationHistoriesByDateProvider(date.value)),
      child: () {
        if (medicationHistoriesAsync is AsyncError) {
          return RetryPage(exception: medicationHistoriesAsync.error!);
        }
        return Stack(
          children: [
            MedicationsHistoryPageBody(histories: medicationHistories.value, date: date, pageController: pageController),
            if (medicationHistoriesAsync is AsyncLoading) ...[
              const Indicator(),
            ],
          ],
        );
      }(),
    );
  }
}

class MedicationsHistoryPageBody extends HookConsumerWidget {
  final ValueNotifier<DateTime> date;
  final PageController pageController;
  final List<MedicationHistory> histories;
  const MedicationsHistoryPageBody({
    super.key,
    required this.date,
    required this.pageController,
    required this.histories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerInfo = ref.watch(customerInfoProvider).asData?.value;
    return Scaffold(
      appBar: AppBar(
        title: Text(L.medicationHistory),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: MedicationAchievementSummary(),
            ),
            WeeklyCalendarPager(date: date, pageController: pageController),
            const Divider(
              height: 1,
              color: Colors.black,
            ),
            TodayBadge(date: date),
            Expanded(
              child: Stack(
                children: [
                  if (histories.isEmpty) ...[
                    const MedicationHistoryEmpty(),
                  ],
                  if (histories.isNotEmpty) ...[
                    Positioned.fill(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        itemCount: histories.length,
                        itemBuilder: (context, index) {
                          final history = histories[index];
                          return Column(
                            children: [
                              // 取消(revert)の記録も服薬記録と同じ一覧に行として表示する (#253)
                              if (history.action is RevertMedicationHistoryAction) ...[
                                MedicationHistoryRevertTile(history: history),
                              ] else ...[
                                MedicationHistoryTile(history: history),
                              ],
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                  if (customerInfo?.hasPremiumEntitlement == false && date.value.isBefore(today())) ...[
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
                                  analytics.logEvent(name: 'med_histories_premium_pressed');
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
            ),
          ],
        ),
      ),
    );
  }
}

class MedicationHistoryEmpty extends StatelessWidget {
  const MedicationHistoryEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(L.noMedicationHistory));
  }
}

/// 服薬記録の操作者(記録者・取消者)が「自分以外のメンバー」の場合に表示名を返す。
/// displayName が未登録・プロフィール不在でもフォールバック文言([L.memberFallbackName])を返し、操作者表示を必ず出す。
/// 操作者が自分・不明の場合は null を返し、操作者表示を出さない。
String? _operatorMemberDisplayName(WidgetRef ref, MedicationHistory history) {
  final recordedByUserID = history.recordedByUserID;
  if (recordedByUserID == null || recordedByUserID == ref.watch(appUserIDProvider)) {
    return null;
  }
  final currentGroupID = ref.watch(currentGroupIDProvider);
  final displayName = currentGroupID == null
      ? null
      : ref
          .watch(groupUserProfilesProvider(groupID: currentGroupID))
          .valueOrNull
          ?.firstWhereOrNull((profile) => profile.userID == recordedByUserID)
          ?.displayName;
  return (displayName?.isNotEmpty ?? false) ? displayName : L.memberFallbackName;
}

class MedicationHistoryTile extends HookConsumerWidget {
  const MedicationHistoryTile({
    super.key,
    required this.history,
  });

  final MedicationHistory history;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicine = history.medicine;
    final schedule = history.action.medicationSchedule;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final memoUpdate = ref.watch(medicationHistoryMemoUpdateProvider);
    final recorderName = _operatorMemberDisplayName(ref, history);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // 影の位置を調整
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(medicine.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor)),
                const Spacer(),
                Text(
                  schedule.quantityMemo,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(medicine.doseReceiver.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            if (recorderName != null) ...[
              const SizedBox(height: 4),
              Text(L.recordedByMember(recorderName), style: const TextStyle(fontSize: 12, color: TextColor.gray)),
            ],
            const SizedBox(height: 4),
            Column(
              children: [
                Row(
                  children: [
                    Text(L.scheduledTime),
                    const Spacer(),
                    Text(
                      '${DateFormat(DateFormat.MONTH_DAY).format(history.scheduledRecordedDate)} ${schedule.toTimeString()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(L.recordedTime),
                    const Spacer(),
                    Text(
                      '${DateFormat(DateFormat.MONTH_DAY).format(history.recordedDateTime)} ${DateFormat(DateFormat.HOUR24_MINUTE).format(history.recordedDateTime)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (history.memo.isEmpty) ...[
                  Expanded(child: Text(L.noMemo)),
                ] else ...[
                  Expanded(child: Text(history.memo)),
                ],
                IconButton(
                  onPressed: () async {
                    analytics.logEvent(name: 'med_histories_memo_edit_pressed');
                    final result = await showTextEditSheet(context, text: history.memo);
                    if (result != null) {
                      memoUpdate.call(medicationHistory: history, memo: result);
                    }
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 取消(revert)の記録行。誰が・いつ服薬記録を取り消したかを表示する (#253)。
/// 服薬記録(take)の行と違い、取消の記録にメモは付けないため編集ボタンは持たない。
class MedicationHistoryRevertTile extends HookConsumerWidget {
  const MedicationHistoryRevertTile({
    super.key,
    required this.history,
  });

  final MedicationHistory history;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicine = history.medicine;
    final schedule = history.action.medicationSchedule;
    final reverterName = _operatorMemberDisplayName(ref, history);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // 影の位置を調整
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 取消ラベルと並ぶため、長い薬名は折り返さず省略して横幅あふれを防ぐ
                Expanded(
                  child: Text(
                    medicine.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: TextColor.gray),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(L.medicationHistoryReverted, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: TextColor.danger)),
              ],
            ),
            const SizedBox(height: 4),
            Text(medicine.doseReceiver.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            if (reverterName != null) ...[
              const SizedBox(height: 4),
              Text(L.revertedByMember(reverterName), style: const TextStyle(fontSize: 12, color: TextColor.gray)),
            ],
            const SizedBox(height: 4),
            Column(
              children: [
                Row(
                  children: [
                    Text(L.scheduledTime),
                    const Spacer(),
                    Text(
                      '${DateFormat(DateFormat.MONTH_DAY).format(history.scheduledRecordedDate)} ${schedule.toTimeString()}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: TextColor.gray),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(L.revertedTime),
                    const Spacer(),
                    Text(
                      '${DateFormat(DateFormat.MONTH_DAY).format(history.recordedDateTime)} ${DateFormat(DateFormat.HOUR24_MINUTE).format(history.recordedDateTime)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: TextColor.danger),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
