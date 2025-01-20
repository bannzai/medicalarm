import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/calendar/day/today_badge.dart';
import 'package:medicalarm/components/calendar/weekly/pager.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medications/page.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';

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

class MedicationsHistoryPageBody extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('服薬履歴'),
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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                itemCount: histories.length,
                itemBuilder: (context, index) {
                  final history = histories[index];
                  final medicine = history.medicine;
                  final schedule = history.action.medicationSchedule;
                  return MedicationHistoryTile(medicine: medicine, history: history, schedule: schedule);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicationHistoryTile extends StatelessWidget {
  const MedicationHistoryTile({
    super.key,
    required this.medicine,
    required this.history,
    required this.schedule,
  });

  final Medicine medicine;
  final MedicationHistory history;
  final MedicationSchedule schedule;

  @override
  Widget build(BuildContext context) {
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
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // 影の位置を調整
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(medicine.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Row(
              children: [
                const Text('時間:'),
                Text(history.createdDateTime?.toString() ?? 'No Date'),
              ],
            ),
            Text(schedule.quantityMemo, style: const TextStyle(fontSize: 12)),
            Text(medicine.doseReceiver.name),
            Text('${schedule.hour}:${schedule.minute}'),
            Text(history.memo),
            if (history.actionKind == MedicationHistoryActionKind.take)
              const Text('Action: Take')
            else if (history.actionKind == MedicationHistoryActionKind.revert)
              const Text('Action: Revert')
            else if (history.actionKind == MedicationHistoryActionKind.skip)
              const Text('Action: Skip'),
          ],
        ),
      ),
    );
  }
}
