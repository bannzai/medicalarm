import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/components/calendar/const.dart';
import 'package:medicalarm/components/calendar/day/tile.dart';
import 'package:medicalarm/components/calendar/day/today_badge.dart';
import 'package:medicalarm/components/calendar/weekly/badge.dart';
import 'package:medicalarm/components/calendar/weekly/line.dart';
import 'package:medicalarm/components/calendar/weekly/pager.dart';
import 'package:medicalarm/components/fab/layout.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medications/entity/grouped.dart';
import 'package:medicalarm/features/medications/page.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/utils/date_time/weekday.dart';

class ScreenshotMedicationsPage extends HookWidget {
  const ScreenshotMedicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final page = useState(todayCalendarPageIndex);
    final pageController = usePageController(initialPage: page.value);
    pageController.addListener(() {
      final pageControllerPage = pageController.page;
      if (pageControllerPage != null) {
        page.value = pageControllerPage.toInt();
      }
    });
    final date = useState(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(L.medicine, style: const TextStyle(fontSize: 20)),
            Text(_displayMonth(page.value), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: FloatingActionButtonLayout(
        scaffoldBody: SafeArea(
          child: Column(
            children: [
              WeeklyCalendarPager(date: date, pageController: pageController),
              const Divider(
                height: 1,
                color: Colors.black,
              ),
              TodayBadge(date: date),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        for (final tileValue in medicationGroups(
                          medicines: medicines,
                          medicationHistories: medicationHistories,
                          date: date.value,
                        )) ...[
                          MedicationGroupTile(
                            key: ValueKey(tileValue.id),
                            tileValue: tileValue,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: MedicalAddFloatingActionButtonChild(
          medicines: medicines,
        ),
      ),
    );
  }
}

String _displayMonth(int page) {
  String format(DateTime date) {
    return DateFormat(DateFormat.NUM_MONTH_DAY).format(date);
  }

  final first = _dateTimeRange(page).start;
  final last = _dateTimeRange(page).end;
  return '${format(first)} - ${format(last)}';
}

DateTimeRange _dateTimeRange(int page) {
  final first = weekcalendarDataSource[page].first;
  final last = weekcalendarDataSource[page].last;
  return DateTimeRange(start: first, end: last);
}

List<Medicine> get medicines => [
      Medicine(
        id: '1',
        userID: '1',
        name: L.screenshotMedicationName1,
        beganDateTime: DateTime.now(),
        frequency: const DailyMedicationFrequency(),
        doseReceiver: DoseReceiver(id: '1', userID: '1', name: L.screenshotMedicationDoserReceiver1),
        memo: 'Memo 1',
        memoImageURL: 'https://example.com/memo.png',
        schedules: [
          MedicationSchedule(
            id: '1',
            hour: 10,
            minute: 0,
            quantityMemo: L.screenshotMedicationQuontityMemo1,
            notificationSetting: const MedicineScheduleNotificationSetting(
              isReminderEnabled: true,
              isFollowupEnabled: true,
              useCriticalAlert: true,
            ),
            focusConnectSetting: const MedicineScheduleFocusConnectSetting(),
          ),
        ],
      ),
      Medicine(
        id: '2',
        userID: '2',
        name: L.screenshotMedicationName2,
        beganDateTime: DateTime.now(),
        frequency: const DailyMedicationFrequency(),
        doseReceiver: DoseReceiver(id: '2', userID: '2', name: L.screenshotMedicationDoserReceiver2),
        memo: 'Memo 2',
        memoImageURL: 'https://example.com/memo.png',
        schedules: [
          MedicationSchedule(
            id: '2',
            hour: 8,
            minute: 0,
            quantityMemo: L.screenshotMedicationQuontityMemo2,
            notificationSetting: const MedicineScheduleNotificationSetting(
              isReminderEnabled: true,
              isFollowupEnabled: true,
              useCriticalAlert: true,
            ),
            focusConnectSetting: const MedicineScheduleFocusConnectSetting(),
          ),
        ],
      ),
    ];

List<MedicationHistory> get medicationHistories => [
      MedicationHistory(
        id: '1',
        userID: '1',
        medicine: medicines[0],
        actionKind: MedicationHistoryActionKind.take,
        action: MedicationHistoryAction.take(
          kind: MedicationHistoryActionKind.take,
          medicationSchedule: medicines[0].schedules[0],
          scheduledRecordedDate: DateTime.now(),
        ),
        memo: 'Memo 1',
        recordedDateTime: DateTime.now(),
        scheduledRecordedDate: DateTime.now(),
        ttlExpiresDateTime: DateTime.now(),
      ),
    ];

class MedicalAddFloatingActionButtonChild extends StatelessWidget {
  const MedicalAddFloatingActionButtonChild({
    super.key,
    required this.medicines,
  });

  final List<Medicine> medicines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: Text(L.addMedicine),
          ),
        ],
      ),
    );
  }
}

const double _horizontalPadding = 10;

class WeeklyCalendarPager extends StatelessWidget {
  final ValueNotifier<DateTime> date;
  final PageController pageController;
  const WeeklyCalendarPager({
    super.key,
    required this.date,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final List<Diary> diaries = [];

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _WeekdayLine(),
          LimitedBox(
            maxHeight: CalendarConst.weeklyTileHeight,
            child: PageView.builder(
              controller: pageController,
              physics: const PageScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final days = weekcalendarDataSource[index];

                return SizedBox(
                  width: MediaQuery.of(context).size.width - 20 * 2,
                  child: CalendarWeekLine(
                    dateRange: DateTimeRange(start: days.first, end: days.last),
                    horizontalPadding: _horizontalPadding,
                    day: (context, weekday, date) {
                      final diary = diaries.firstWhereOrNull((e) => isSameDay(e.diaryDate, date));
                      return CalendarDayTile(
                        weekday: weekday,
                        date: date,
                        diary: diary,
                        onTap: (date) {},
                        selected: isSameDay(date, this.date.value),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  DateTimeRange allWeekCalendarDateTimeRange() {
    final range = weekcalendarDataSource;
    return DateTimeRange(start: range.first.first, end: range.last.last);
  }
}

class _WeekdayLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(Weekday.values.length, (index) => Expanded(child: WeekdayBadge(weekday: Weekday.values[index]))),
    );
  }
}
