import 'dart:async';

import 'package:async_value_group/async_value_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/components/admob/admob.dart';
import 'package:medicalarm/components/calendar/weekly/pager.dart';
import 'package:medicalarm/components/fab/layout.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/entity/group_member_notification_settings.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medications/components/add_button.dart';
import 'package:medicalarm/components/calendar/day/today_badge.dart';
import 'package:medicalarm/features/medications/components/group_chips_bar.dart';
import 'package:medicalarm/features/medications/entity/grouped.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/focus_connect/section.dart';
import 'package:medicalarm/features/medicine_form/page.dart';
import 'package:medicalarm/features/medicines/page.dart';
import 'package:medicalarm/features/preium_introduction/premium_introduction_sheet.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/current_group_id.dart';
import 'package:medicalarm/provider/group_member_notification_settings.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/analytics/error.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/utils/functions/firebase_functions.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class MedicationsPage extends HookConsumerWidget {
  const MedicationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = useState(today());
    final medicines = ref.watch(activeMedicinesProvider);
    final medicationHistoriesAsync = ref.watch(medicationHistoriesByDateProvider(date.value.date()));
    final medicationHistories = useState(medicationHistoriesAsync.asData?.valueOrNull ?? []);
    final customerInfo = ref.watch(customerInfoProvider);

    useEffect(() {
      final asyncValue = medicationHistoriesAsync.asData;
      if (asyncValue != null) {
        medicationHistories.value = asyncValue.value;
      }
      return null;
    }, [medicationHistoriesAsync.asData?.valueOrNull]);

    return Retry(
      retry: () => ref.invalidate(activeMedicinesProvider),
      child: AsyncValueGroup.group2(medicines, customerInfo).when(
        data: (data) => MedicationsPageBody(
          date: date,
          medicines: data.$1,
          medicationHistories: medicationHistories.value,
          customerInfo: data.$2,
        ),
        error: (error, stackTrace) => RetryPage(exception: error),
        loading: () => const IndicatorPage(),
      ),
    );
  }
}

class MedicationsPageBody extends HookConsumerWidget {
  final ValueNotifier<DateTime> date;
  final List<Medicine> medicines;
  final List<MedicationHistory> medicationHistories;
  final CustomerInfo customerInfo;

  const MedicationsPageBody({
    super.key,
    required this.date,
    required this.medicines,
    required this.medicationHistories,
    required this.customerInfo,
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

    final primaryColor = Theme.of(context).colorScheme.primary;

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
            tooltip: L.medicineEditTooltip,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MedicinesPage()),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: FloatingActionButtonLayout(
        scaffoldBody: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const GroupChipsBar(),
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
                        padding: const EdgeInsets.only(top: 20.0, bottom: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (!customerInfo.hasPremiumEntitlement) ...[
                              const AdMob(),
                            ],
                            if (customerInfo.isInPromotion) ...[
                              GestureDetector(
                                onTap: () {
                                  showPremiumIntroductionSheet(context);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  color: primaryColor.withValues(alpha: 0.8),
                                  child: Text(
                                    L.currentlyInPremiumTrial,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
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

class MedicationGroupTile extends StatelessWidget {
  final MedicationGroup tileValue;
  const MedicationGroupTile({super.key, required this.tileValue});

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
            for (final scheduleRow in tileValue.scheduleRows) ...[
              MedicineTileScheduleRow(key: ValueKey(scheduleRow.id), scheduleRow: scheduleRow),
            ],
          ],
        ),
      ),
    );
  }
}

class MedicineTileScheduleRow extends HookConsumerWidget {
  final MedicationGroupScheduleRow scheduleRow;
  const MedicineTileScheduleRow({
    super.key,
    required this.scheduleRow,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDisabled = scheduleRow.isDisabled;
    final isChecked = useState(scheduleRow.medicationHistory != null);
    final medicationHistoryTake = ref.watch(medicationHistoryTakeProvider);
    final medicationHistoryDelete = ref.watch(medicationHistoryDeleteProvider);
    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);

    isChecked.addListener(() async {
      unawaited(registerReminderLocalNotification.call());

      if (isChecked.value) {
        await medicationHistoryTake.call(
          medicationHistory: scheduleRow.medicationHistory,
          scheduledRecordedDate: scheduleRow.date,
          recordedDateTime: scheduleRow.medicationHistory?.recordedDateTime ?? DateTime.now(),
          medicine: scheduleRow.medicine,
          medicationSchedule: scheduleRow.medicationSchedule,
        );

        // 同じグループの他メンバーへ服薬記録を push 通知する。失敗しても記録は成功扱いにするため unawaited + catch。
        // ソログループなど送信対象が 0 件の場合はサーバー側でスキップされる。
        final groupID = ref.read(currentGroupIDProvider);
        if (groupID != null) {
          unawaited(
            functions
                .sendMedicationRecordNotification(
              groupID: groupID,
              medicineID: scheduleRow.medicine.id,
              medicineName: scheduleRow.medicine.name,
              doseReceiverName: scheduleRow.medicine.doseReceiver.name,
            )
                .catchError((Object e, StackTrace st) {
              errorLogger.recordError(e, st);
            }),
          );
        }

        // Focus 連携は端末個人の設定のため、テンプレート直読みではなく有効設定の解決経由で取得する
        final focusConnectScheduleID = resolveEffectiveNotificationSetting(
          medicine: scheduleRow.medicine,
          schedule: scheduleRow.medicationSchedule,
          memberSettings: await ref.read(groupMemberNotificationSettingsProvider.future),
          currentUserID: ref.read(appUserIDProvider),
        ).focusConnectScheduleID;
        if (focusConnectScheduleID != null) {
          await launchUrl(
            Uri.parse(
              'focus-connect://schedule/unlock?focusConnectScheduleID=$focusConnectScheduleID&focusConnectAppID=$focusConnectAppID',
            ),
          );
        }
      } else {
        await medicationHistoryDelete.call(scheduleRow.medicationHistory!);
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
                scheduleRow.medicine.name,
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () {
                showMedicineForm(context, scheduleRow.medicine);
              },
            ),
            const Spacer(),
            if (scheduleRow.quantityMemo.isNotEmpty) ...[
              Text(scheduleRow.quantityMemo),
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
