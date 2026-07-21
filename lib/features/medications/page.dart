import 'dart:async';

import 'package:async_value_group/async_value_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/components/admob/admob.dart';
import 'package:medicalarm/components/banner/account_link_banner.dart';
import 'package:medicalarm/components/calendar/weekly/pager.dart';
import 'package:medicalarm/components/error/error_alert.dart';
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
                  const AccountLinkBanner(),
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
    // アンチェックで発行した revert がまだ行の snapshot に反映されていない間 true。
    // この間のチェックし直しを「既存 take への上書き」ではなく「新しい take の追記」として扱うために保持する。
    // 既存 take は revert に打ち消されたままなので、上書きしてもチェック済みには戻らない
    final hasPendingRevert = useRef(false);
    final medicationHistoryTake = ref.watch(medicationHistoryTakeProvider);
    final medicationHistoryRevert = ref.watch(medicationHistoryRevertProvider);
    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);

    // 行キーが安定化され snapshot 更新で widget が再生成されなくなったため、他メンバーの操作による
    // 記録の増減をローカルの isChecked へ反映する
    useEffect(() {
      isChecked.value = scheduleRow.medicationHistory != null;
      // 行の記録が入れ替わった = 自分の revert 発行前後の snapshot 遅延は解消済み
      hasPendingRevert.value = false;
      return null;
    }, [scheduleRow.medicationHistory?.id]);

    Future<void> take({required MedicationHistory? medicationHistory}) async {
      // 記録の書き込みで snapshot が更新されると、この widget は再ビルドされる。
      // await をまたいで ref を触るとウィジェット破棄後アクセスで例外になるため、ref 依存値は await の前に読み出す。
      final groupID = ref.read(currentGroupIDProvider);
      final currentUserID = ref.read(appUserIDProvider);
      // memberSettings は take 内の AlarmKit 判定と Focus 連携の解決で共用するため、write より前に読み出して解決する。
      final memberSettings = await ref.read(groupMemberNotificationSettingsProvider.future);

      final MedicationHistory newMedicationHistory;
      try {
        newMedicationHistory = await medicationHistoryTake.call(
          medicationHistory: medicationHistory,
          scheduledRecordedDate: scheduleRow.date,
          recordedDateTime: medicationHistory?.recordedDateTime ?? DateTime.now(),
          medicine: scheduleRow.medicine,
          medicationSchedule: scheduleRow.medicationSchedule,
          memberSettings: memberSettings,
        );
      } catch (e, st) {
        // 記録が作られていないのにチェック済み表示のままだと飲み忘れを誘発するため、表示を実状態へ戻す
        errorLogger.recordError(e, st);
        if (context.mounted) {
          isChecked.value = !hasPendingRevert.value && scheduleRow.medicationHistory != null;
          showErrorAlert(context, e.toString());
        }
        return;
      }
      unawaited(registerReminderLocalNotification.call());

      // 同じグループの他メンバーへ服薬記録を push 通知する。失敗しても記録は成功扱いにするため unawaited + catch。
      // ソログループなど送信対象が 0 件の場合はサーバー側でスキップされる。
      if (groupID != null) {
        unawaited(
          functions
              .sendMedicationRecordNotification(
            groupID: groupID,
            medicineID: scheduleRow.medicine.id,
            medicationHistoryID: newMedicationHistory.id,
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
        memberSettings: memberSettings,
        currentUserID: currentUserID,
      ).focusConnectScheduleID;
      if (focusConnectScheduleID != null) {
        await launchUrl(
          Uri.parse(
            'focus-connect://schedule/unlock?focusConnectScheduleID=$focusConnectScheduleID&focusConnectAppID=$focusConnectAppID',
          ),
        );
      }
    }

    // アンチェック操作。take ドキュメントは削除せず、取消(revert)アクションを即時追記する論理削除 (#253)。
    // 誤タップでも他メンバーの記録は失われず、チェックし直せば新しい take の追記でチェック済みへ戻せる
    Future<void> revert() async {
      final medicationHistory = scheduleRow.medicationHistory;
      if (medicationHistory == null) {
        // 他メンバーの取消が先行して未チェック扱いになっている場合。取消対象が無いので表示の同期だけに留める
        return;
      }

      // await より前に立てる。書き込み完了を待ってから立てると、書き込み中のチェックし直しが
      // 「既存 take への上書き」と誤解釈され、後から完了した revert に打ち消されてしまう
      hasPendingRevert.value = true;

      try {
        await medicationHistoryRevert.call(takeMedicationHistory: medicationHistory);
      } catch (e, st) {
        // 取消が書けていないのに未チェック表示のままだと二重服用を誘発するため、表示を実状態へ戻す
        errorLogger.recordError(e, st);
        hasPendingRevert.value = false;
        if (context.mounted) {
          isChecked.value = scheduleRow.medicationHistory != null;
          showErrorAlert(context, e.toString());
        }
        return;
      }
      unawaited(registerReminderLocalNotification.call());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(L.medicationHistoryDeletedSnackbar)),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              // Apple HIG の最小タップターゲット 44pt。行の高さごと確保することで、
              // 隣接行のチェックボックスとタップ領域が重ならないよう分離する (#253)
              width: 44,
              height: 44,
              child: Checkbox(
                value: isDisabled ? false : isChecked.value,
                onChanged: isDisabled
                    ? null
                    : (value) {
                        final newValue = value ?? false;
                        if (newValue == isChecked.value) {
                          return;
                        }
                        isChecked.value = newValue;
                        if (newValue) {
                          // 自分の revert が snapshot に未反映の間のチェックし直しは、revert に打ち消された
                          // 既存 take へ上書きしても戻らないため、新しい take の追記として記録する
                          unawaited(take(medicationHistory: hasPendingRevert.value ? null : scheduleRow.medicationHistory));
                        } else {
                          unawaited(revert());
                        }
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
            // 同名・同時刻で並ぶ行を見分けるための識別情報として、チェック済みの行に記録時刻を表示する (#253)
            if (isChecked.value && scheduleRow.medicationHistory != null) ...[
              Text(
                L.medicationTakenAtLabel(DateFormat.Hm().format(scheduleRow.medicationHistory!.recordedDateTime)),
                style: const TextStyle(fontSize: 12, color: TextColor.gray),
              ),
              const SizedBox(width: 8),
            ],
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
