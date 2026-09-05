import 'dart:async';

import 'package:async_value_group/async_value_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/components/admob/admob.dart';
import 'package:medicalarm/components/avatar/dose_receiver_avatar.dart';
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
import 'package:medicalarm/features/medications/components/dose_interval_warning_dialog.dart';
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
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/analytics/error.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/utils/functions/firebase_functions.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:medicalarm/utils/member/operator_member_display_name.dart';
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
              analytics.logEvent(name: 'medications_edit_list_pressed');
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
                                  analytics.logEvent(name: 'medications_promo_banner_tapped');
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
            Row(
              children: [
                DoseReceiverAvatar(doseReceiver: tileValue.doseReceiver, size: 32),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tileValue.doseReceiver.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
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
    // アンチェックで発行した revert の書き込み。書き込み中〜SnackBar の「元に戻す」猶予中のみ非 null で、
    // この間のチェックし直しを take ではなく undo(revert の取り下げ)として扱うために保持する。
    // 完了済みドキュメントではなく Future を持つのは、書き込み中(await 完了前)のチェックし直しが
    // take と誤解釈され、後から完了した revert に打ち消される競合を防ぐため
    final pendingRevertWrite = useRef<Future<MedicationHistory>?>(null);
    // 実行中の undo(revert の取り下げ)。undo 完了前に再アンチェックされた場合に、
    // 取り消し対象の take を undo の結果から引き継いで再アンチェックを破棄しないために保持する
    final pendingUndoWrite = useRef<Future<MedicationHistory?>?>(null);
    // 実行中の間隔チェック(takeWithIntervalCheck)の世代。チェックのたびに進め、
    // フェッチ・ダイアログ待ちの古い継続が最新の操作を追い越して記録しないようにする (#81)
    final takeOperationGeneration = useRef(0);
    final medicationHistoryTake = ref.watch(medicationHistoryTakeProvider);
    final medicationHistoryRevert = ref.watch(medicationHistoryRevertProvider);
    final medicationHistoryUndoRevert = ref.watch(medicationHistoryUndoRevertProvider);
    final recentMedicationHistoriesFetch = ref.watch(recentMedicationHistoriesFetchProvider);
    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);
    // 他メンバーが記録した行に「誰が記録したか」を添えるための表示名。自分の記録・不明の場合は null
    final recorderName =
        scheduleRow.medicationHistory == null ? null : operatorMemberDisplayName(ref: ref, history: scheduleRow.medicationHistory!);

    // 行キーが安定化され snapshot 更新で widget が再生成されなくなったため、他メンバーの操作による
    // 記録の増減をローカルの isChecked へ反映する
    useEffect(() {
      isChecked.value = scheduleRow.medicationHistory != null;
      return null;
    }, [scheduleRow.medicationHistory?.id]);

    Future<void> take() async {
      // 記録の書き込みで snapshot が更新されると、この widget は再ビルドされる。
      // await をまたいで ref を触るとウィジェット破棄後アクセスで例外になるため、ref 依存値は await の前に読み出す。
      final groupID = ref.read(currentGroupIDProvider);
      final currentUserID = ref.read(appUserIDProvider);
      // memberSettings は take 内の AlarmKit 判定と Focus 連携の解決で共用するため、write より前に読み出して解決する。
      final memberSettings = await ref.read(groupMemberNotificationSettingsProvider.future);

      final MedicationHistory medicationHistory;
      try {
        medicationHistory = await medicationHistoryTake.call(
          medicationHistory: scheduleRow.medicationHistory,
          scheduledRecordedDate: scheduleRow.date,
          recordedDateTime: scheduleRow.medicationHistory?.recordedDateTime ?? DateTime.now(),
          medicine: scheduleRow.medicine,
          medicationSchedule: scheduleRow.medicationSchedule,
          memberSettings: memberSettings,
        );
      } catch (e, st) {
        // 記録が作られていないのにチェック済み表示のままだと飲み忘れを誘発するため、表示を実状態へ戻す
        errorLogger.recordError(e, st);
        if (context.mounted) {
          isChecked.value = scheduleRow.medicationHistory != null;
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
            medicationHistoryID: medicationHistory.id,
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

    // 最低服用間隔([Medicine.minimumDoseIntervalHours])が空いていない場合に注意ダイアログを挟んでから記録する (#81)。
    // 記録は無効化せず、続行するかどうかはユーザーに委ねる
    Future<void> takeWithIntervalCheck() async {
      final minimumDoseIntervalHours = scheduleRow.medicine.minimumDoseIntervalHours;
      // 服用間隔の警告は新規の服用記録にだけ出す。既存記録の再書き込み(取消競合からの復元)は服用の追加ではないため対象外
      if (minimumDoseIntervalHours == null || scheduleRow.medicationHistory != null) {
        return take();
      }
      final operationGeneration = ++takeOperationGeneration.value;
      // フェッチ・ダイアログの待機中にアンチェックや新しいチェック操作が行われた場合、この継続が
      // 最新のユーザー操作を追い越して記録しないよう、待機明けごとに意図を確認して破棄する
      bool isStale() => takeOperationGeneration.value != operationGeneration || !isChecked.value;
      final now = DateTime.now();
      final DateTime? latestTakeRecordedDateTime;
      try {
        latestTakeRecordedDateTime = latestEffectiveTakeRecordedDateTime(
          medicationHistories: await recentMedicationHistoriesFetch.call(
            recordedSinceDateTime: now.subtract(Duration(hours: minimumDoseIntervalHours)),
          ),
          medicineID: scheduleRow.medicine.id,
        );
      } catch (e, st) {
        // 間隔チェックは補助機能。取得に失敗しても記録自体は止めない
        errorLogger.recordError(e, st);
        if (context.mounted && !isStale()) {
          await take();
        }
        return;
      }
      if (!context.mounted || isStale()) {
        return;
      }
      if (latestTakeRecordedDateTime == null || !now.isBefore(latestTakeRecordedDateTime.add(Duration(hours: minimumDoseIntervalHours)))) {
        return take();
      }
      final shouldTake = await showDoseIntervalWarningDialog(
        context,
        minimumDoseIntervalHours: minimumDoseIntervalHours,
        latestTakeRecordedDateTime: latestTakeRecordedDateTime,
      );
      if (!context.mounted || isStale()) {
        return;
      }
      if (shouldTake == true) {
        return take();
      }
      // キャンセル(ダイアログ外タップで閉じた場合を含む)は記録しない。チェック表示を実状態へ戻す
      isChecked.value = false;
    }

    // 「元に戻す」操作。数秒前の自分の取消の undo なので、履歴に「取消 → 取消の取消」を連ねず
    // 直前に書いた revert ドキュメント自体を取り下げてサーバーもチェック済み状態へ戻す。
    // undo が成立してチェック済みに戻った場合はその take を返し、不成立(別メンバーの取消が残っている・失敗)の場合は null を返す
    Future<MedicationHistory?> undoRevert(Future<MedicationHistory> revertWrite) async {
      final MedicationHistory revertMedicationHistory;
      try {
        revertMedicationHistory = await revertWrite;
      } catch (_) {
        // revert の書き込み自体が失敗 = 取消は成立していない(エラー記録・表示は revertWithUndo 側で行う)。
        // 記録はサーバーに残っているためチェック済みへ戻す
        if (context.mounted) {
          isChecked.value = true;
        }
        return scheduleRow.medicationHistory;
      }
      try {
        final isUndone = await medicationHistoryUndoRevert.call(revertMedicationHistory: revertMedicationHistory);
        unawaited(registerReminderLocalNotification.call());
        if (context.mounted) {
          // 別メンバーの取消が同じ take を上書きしている場合(isUndone = false)は取り下げず、未チェックのまま
          isChecked.value = isUndone;
        }
        return isUndone ? (revertMedicationHistory.action as RevertMedicationHistoryAction).takeAction : null;
      } catch (e, st) {
        // revert ドキュメントが残ったままなので、表示は未チェックのままにする
        errorLogger.recordError(e, st);
        if (context.mounted) {
          isChecked.value = false;
          showErrorAlert(context, e.toString());
        }
        return null;
      }
    }

    // undo を開始し、完了前の再アンチェックが取消対象(take)を引き継げるよう実行中の Future を保持する
    Future<void> startUndo(Future<MedicationHistory> revertWrite) {
      final undoWrite = undoRevert(revertWrite);
      pendingUndoWrite.value = undoWrite;
      return undoWrite.then((_) {}).whenComplete(() {
        if (pendingUndoWrite.value == undoWrite) {
          pendingUndoWrite.value = null;
        }
      });
    }

    // アンチェック操作。take ドキュメントは削除せず、取消(revert)アクションを即時追記する論理削除 (#253)。
    // 誤タップでも他メンバーの記録は失われず、SnackBar の「元に戻す」で revert を取り下げて戻せる
    Future<void> revertWithUndo() async {
      var medicationHistory = scheduleRow.medicationHistory;
      if (medicationHistory == null) {
        final undoWrite = pendingUndoWrite.value;
        if (undoWrite == null) {
          // 他メンバーの取消が先行して未チェック扱いになっている場合。取消対象が無いので表示の同期だけに留める
          return;
        }
        // undo(チェック済みへ戻す)の実行中に再アンチェックされた場合。undo の完了を待ち、
        // 復元された take を取消対象に引き継ぐ(ここで破棄すると undo 完了時に再アンチェックが巻き戻されて消える)
        medicationHistory = await undoWrite;
        if (medicationHistory == null) {
          // undo 不成立 = 未チェックのままなので、取り消すべき take は無い
          return;
        }
        if (context.mounted) {
          // undo 成立時に isChecked が true へ戻されているため、この再アンチェックの意図(未チェック)を適用し直す
          isChecked.value = false;
        }
      }

      // await より前に猶予中マークを立てる。書き込み完了を待ってから立てると、
      // 書き込み中のチェックし直しが take と誤解釈され、後から完了した revert に打ち消されてしまう
      final revertWrite = medicationHistoryRevert.call(takeMedicationHistory: medicationHistory);
      pendingRevertWrite.value = revertWrite;

      try {
        await revertWrite;
      } catch (e, st) {
        errorLogger.recordError(e, st);
        if (context.mounted) {
          // 取消が書けていないのに未チェック表示のままだと二重服用を誘発するため、表示を実状態へ戻す。
          // チェックし直しで undo が消化済みの場合の表示は undoRevert 側が戻している
          if (pendingRevertWrite.value == revertWrite) {
            pendingRevertWrite.value = null;
            isChecked.value = scheduleRow.medicationHistory != null;
          }
          showErrorAlert(context, e.toString());
        }
        return;
      }
      unawaited(registerReminderLocalNotification.call());

      // 書き込み中のチェックし直しで undo が消化済みなら、SnackBar は表示しない
      if (pendingRevertWrite.value != revertWrite || !context.mounted) {
        return;
      }
      final snackBarClosedReason = await ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: Text(L.medicationHistoryDeletedSnackbar),
              // Material の SnackBar 推奨表示時間 4〜10 秒の範囲で、誤タップに気付いてから押せるよう取り消し猶予を長めに取る
              duration: const Duration(seconds: 8),
              // action 付き SnackBar は persist がデフォルト true になり自動クローズしない。
              // 閉じないと「元に戻す」の猶予が永遠に終わらないため、duration で自動クローズさせる
              persist: false,
              action: SnackBarAction(
                label: L.undo,
                // undo の判定は closed の SnackBarClosedReason.action で行うため、ログ以外は何もしない
                onPressed: () {
                  analytics.logEvent(name: 'medications_undo_pressed');
                },
              ),
            ),
          )
          .closed;

      // SnackBar 表示中のチェックし直し(元に戻すと同義)で undo 済みの場合は何もしない
      if (pendingRevertWrite.value != revertWrite) {
        return;
      }
      pendingRevertWrite.value = null;

      if (snackBarClosedReason == SnackBarClosedReason.action) {
        await startUndo(revertWrite);
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
                        analytics.logEvent(name: 'medications_check_changed');
                        final newValue = value ?? false;
                        if (newValue == isChecked.value) {
                          return;
                        }
                        isChecked.value = newValue;
                        if (newValue) {
                          final revertWrite = pendingRevertWrite.value;
                          if (revertWrite != null) {
                            // 「元に戻す」猶予中(revert 書き込み中を含む)のチェックし直しは undo と同義。
                            // take の追記ではなく revert の取り下げで戻す
                            pendingRevertWrite.value = null;
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            unawaited(startUndo(revertWrite));
                          } else {
                            unawaited(takeWithIntervalCheck());
                          }
                        } else {
                          unawaited(revertWithUndo());
                        }
                      },
              ),
            ),
            const SizedBox(width: 8),
            // 記録者表示が加わって横幅が不足した時に、薬名を省略して行あふれを防ぐ。
            // Spacer を並べると flex の取り合いで薬名が余白より先に省略されるため、Expanded が余白ごと引き受け、
            // Align でタップ領域と表示をテキスト幅に保つ
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  child: Text(
                    scheduleRow.medicine.name,
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    analytics.logEvent(name: 'medications_medicine_name_tapped');
                    showMedicineForm(context, scheduleRow.medicine);
                  },
                ),
              ),
            ),
            // 同名・同時刻で並ぶ行を見分けるための識別情報として、チェック済みの行に記録時刻を表示する (#253)。
            // 他メンバーの記録には記録者も併記して「誰が記録したか」を判別できるようにする (#277)
            if (isChecked.value && scheduleRow.medicationHistory != null) ...[
              // 記録者名が長い場合もラベル単体で行幅を超えないよう、画面幅の半分を上限に省略表示する。
              // Flexible にすると Expanded の薬名と flex 領域を等分してしまい、ラベルが短くても薬名が半分幅で省略される
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width / 2),
                child: Text(
                  recorderName == null
                      ? L.medicationTakenAtLabel(DateFormat.Hm().format(scheduleRow.medicationHistory!.recordedDateTime))
                      : '${L.medicationTakenAtLabel(DateFormat.Hm().format(scheduleRow.medicationHistory!.recordedDateTime))}'
                          ' · ${L.recordedByMember(recorderName)}',
                  style: const TextStyle(fontSize: 12, color: TextColor.gray),
                  overflow: TextOverflow.ellipsis,
                ),
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
