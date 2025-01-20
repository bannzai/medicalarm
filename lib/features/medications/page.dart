import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/components/calendar/weekly/pager.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medications/components/add_button.dart';
import 'package:medicalarm/components/calendar/day/today_badge.dart';
import 'package:medicalarm/features/medications/entity/grouped.dart';
import 'package:medicalarm/features/medicine_form/page.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:uuid/uuid.dart';

class MedicationsPage extends HookConsumerWidget {
  const MedicationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = useState(today());
    final medicines = ref.watch(activeMedicinesProvider);
    final medicationHistoriesAsync = ref.watch(medicationHistoriesByDateProvider(date.value.date()));
    final medicationHistories = useState(medicationHistoriesAsync.asData?.valueOrNull ?? []);

    useEffect(() {
      final asyncValue = medicationHistoriesAsync.asData;
      if (asyncValue != null) {
        medicationHistories.value = asyncValue.value;
      }
      return null;
    }, [medicationHistoriesAsync.asData?.valueOrNull]);

    return Retry(
      retry: () => ref.invalidate(activeMedicinesProvider),
      child: medicines.when(
        data: (data) => MedicinesPageBody(
          date: date,
          medicines: data,
          medicationHistories: medicationHistories.value,
        ),
        error: (error, stackTrace) => RetryPage(exception: error),
        loading: () => const IndicatorPage(),
      ),
    );
  }
}

class MedicinesPageBody extends HookConsumerWidget {
  final ValueNotifier<DateTime> date;
  final List<Medicine> medicines;
  final List<MedicationHistory> medicationHistories;

  const MedicinesPageBody({
    super.key,
    required this.date,
    required this.medicines,
    required this.medicationHistories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = useState(todayCalendarPageIndex);
    final pageController = usePageController(initialPage: page.value);
    pageController.addListener(() {
      final pageControllerPage = pageController.page;
      if (pageControllerPage != null) {
        page.value = pageControllerPage.toInt();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('お薬', style: TextStyle(fontSize: 20)),
            Text(_displayMonth(page.value), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
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
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (final tileValue in _tileValues()) ...[
                        MedicineTile(
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
      floatingActionButton: const MedicalAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  List<MedicineTileValue> _tileValues() {
    final tileValues = <MedicineTileValue>[];
    // scheduleTimeとdoseReceiverごとのtileValuesを構築する
    for (final medicine in medicines) {
      final doseReceiver = medicine.doseReceiver;

      for (final schedule in medicine.schedules) {
        final scheduleTime = ScheduleTime(hour: schedule.hour, minute: schedule.minute);
        tileValues.add(MedicineTileValue(id: const Uuid().v4(), scheduleTime: scheduleTime, doseReceiver: doseReceiver, dosingRows: []));
      }
    }

    // dosingRowsを構築する
    for (final medicine in medicines) {
      final doseReceiver = medicine.doseReceiver;

      for (final schedule in medicine.schedules) {
        final scheduleTime = ScheduleTime(hour: schedule.hour, minute: schedule.minute);

        final tileIndex = tileValues.indexWhere(
          (tile) => tile.scheduleTime == scheduleTime && tile.doseReceiver == doseReceiver,
        );
        final tile = tileValues[tileIndex];

        final dosingRows = [...tile.dosingRows];
        final medicationHistory = medicationHistories.firstWhereOrNull(
          (history) => history.medicine.id == medicine.id && history.action.medicationSchedule.id == schedule.id,
        );
        final row = MedicineDosingRowValue(
          id: const Uuid().v4(),
          medicationHistory: medicationHistory,
          medicine: medicine,
          medicationSchedule: schedule,
          quantityMemo: schedule.quantityMemo,
          date: date.value,
        );

        dosingRows.add(row);
        tileValues[tileIndex] = tile.copyWith(dosingRows: [...dosingRows]);
      }
    }

    final ordered = tileValues.sortedBy((tile) => tile.scheduleTime.toTimeString());

    return ordered;
  }
}

class MedicineTile extends StatelessWidget {
  final MedicineTileValue tileValue;
  const MedicineTile({super.key, required this.tileValue});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

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
            Text(
              tileValue.scheduleTime.toTimeString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              tileValue.doseReceiver.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            for (final dosingRow in tileValue.dosingRows) ...[
              MedicineTileRow(key: ValueKey(dosingRow.id), dosingRow: dosingRow),
            ],
          ],
        ),
      ),
    );
  }
}

class MedicineTileRow extends HookConsumerWidget {
  final MedicineDosingRowValue dosingRow;
  const MedicineTileRow({
    super.key,
    required this.dosingRow,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDisabled = dosingRow.isDisabled;
    final isChecked = useState(dosingRow.medicationHistory != null);
    final medicationHistoryTake = ref.watch(medicationHistoryTakeProvider);
    final medicationHistoryDelete = ref.watch(medicationHistoryDeleteProvider);
    isChecked.addListener(() {
      if (isChecked.value) {
        medicationHistoryTake(
          medicationHistory: dosingRow.medicationHistory,
          scheduledRecordedDate: dosingRow.date,
          recordedDateTime: dosingRow.medicationHistory?.recordedDateTime ?? DateTime.now(),
          medicine: dosingRow.medicine,
          medicationSchedule: dosingRow.medicationSchedule,
        );
      } else {
        medicationHistoryDelete(dosingRow.medicationHistory!);
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: isDisabled ? false : isChecked.value,
                onChanged: isDisabled
                    ? null
                    : (value) {
                        isChecked.value = value ?? false;
                      },
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              child: Text(
                dosingRow.medicine.name,
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () {
                showMedicineForm(context, dosingRow.medicine);
              },
            ),
            const Spacer(),
            if (dosingRow.quantityMemo.isNotEmpty) ...[
              Text(dosingRow.quantityMemo),
            ],
          ],
        ),
      ],
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

// DateTime _targetEndDayOfWeekday(int page) {
//   final diff = page - todayCalendarPageIndex;
//   final base = today().addDays(diff * Weekday.values.length);
//   return endDayOfWeekday(base);
// }
