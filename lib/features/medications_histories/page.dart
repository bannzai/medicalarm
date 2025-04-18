import 'dart:ui';

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
import 'package:medicalarm/features/preium_introduction/premium_introduction_sheet.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/style/color.dart';
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
                              MedicationHistoryTile(history: history),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                  if (customerInfo?.isPremium == false && date.value.isBefore(today())) ...[
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
