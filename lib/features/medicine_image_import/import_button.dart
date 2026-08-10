import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/alert/image_picker.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/components/loading/loading.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_image_import/review_sheet.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/style/button.dart';
import 'package:medicalarm/utils/billing/created_count.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/utils/functions/firebase_functions.dart';
import 'package:medicalarm/utils/image/image.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';
import 'package:uuid/uuid.dart';

// Functions の抽出結果 (JSON) をレビューシート用の候補に変換する。
// 通知設定はフォームの新規スケジュール (MedicineScheduleAddButton) と同じ既定値にする。
// スケジュール数はフォーム画面 (MedicineScheduleAddButton) と同じプレミアム制限 (scheduleMaxCount) を
// この時点で切り捨てる。登録時ではなく変換時に切り捨てるのは、レビューシートの表示と実際に保存される
// 内容を一致させるため (表示された服用時刻が保存時に黙って消えると飲み忘れにつながる)。
MedicineImageImportCandidate medicineImageImportCandidate({required Map<String, dynamic> generatedMedicine, required int scheduleMaxCount}) {
  final schedules = [
    for (final schedule in (generatedMedicine['schedules'] as List<dynamic>? ?? <dynamic>[]).cast<Map<String, dynamic>>())
      _newSchedule(
        hour: (schedule['hour'] as num).toInt(),
        minute: (schedule['minute'] as num).toInt(),
        quantityMemo: schedule['quantityMemo'] as String? ?? '',
      ),
  ];
  return MedicineImageImportCandidate(
    name: generatedMedicine['name'] as String? ?? '',
    // 保存には 1 件以上のスケジュールが必要 (MedicineFormPage の canSubmit と同じ制約) なため、
    // 服用時刻を読み取れなかった薬はフォームの新規スケジュールと同じ 10:00 を既定にする。
    schedules: schedules.isEmpty ? [_newSchedule(hour: 10, minute: 0, quantityMemo: '')] : schedules.take(scheduleMaxCount).toList(),
    selected: true,
  );
}

// 既定の通知設定を持つスケジュールを作る。既定値は MedicineScheduleAddButton の新規スケジュールに合わせる。
MedicationSchedule _newSchedule({required int hour, required int minute, required String quantityMemo}) {
  return MedicationSchedule(
    id: const Uuid().v4(),
    hour: hour,
    minute: minute,
    quantityMemo: quantityMemo,
    notificationSetting: const MedicineScheduleNotificationSetting(
      isReminderEnabled: true,
      isFollowupEnabled: true,
      useCriticalAlert: false,
      criticalAlertVolume: 0.5,
    ),
    focusConnectSetting: const MedicineScheduleFocusConnectSetting(),
  );
}

/// お薬手帳・処方箋などの画像から薬を読み取って登録するボタン。
/// 画像選択 → Functions で AI 抽出 → レビューシートで取捨選択 → 選択分を登録、まで行う。
class MedicineImageImportButton extends HookConsumerWidget {
  /// 表示中の薬一覧。登録数のプレミアム制限 (Medicine.maxCount) の残り枠計算に使う。
  final List<Medicine> medicines;

  const MedicineImageImportButton({super.key, required this.medicines});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerInfo = ref.watch(customerInfoProvider).asData?.value;
    final appUserID = ref.watch(appUserIDProvider);
    // レビューシート表示中に本 widget が unmount されても登録処理を継続できるよう、
    // build 時に確保した provider の値を使い、await 後に ref へ触らない。
    final medicineAdd = ref.watch(medicineAddProvider);
    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);
    final isLoading = useState(false);
    final createdMedicinesCount = countCreatedByUser(items: medicines, userID: appUserID, creatorUserID: (medicine) => medicine.userID);
    final medicineMaxCount = Medicine.maxCount(hasPremiumEntitlement: customerInfo?.hasPremiumEntitlement);
    final scheduleMaxCount = MedicationSchedule.maxCount(hasPremiumEntitlement: customerInfo?.hasPremiumEntitlement);

    Future<void> importFromImage() async {
      final photo = await showImagePickerDialog(context);
      if (photo == null) {
        return;
      }
      isLoading.value = true;
      try {
        final file = File(photo.path);
        final base64Image = await base64CompressImage(file);
        final generatedMedicines = await functions.generateMedicinesFromImage(mimeType: mimeType(file), base64Image: base64Image);
        if (!context.mounted) {
          return;
        }
        final selectedCandidates = await showMedicineImageImportReviewSheet(
          context: context,
          candidates: [
            for (final generatedMedicine in generatedMedicines)
              medicineImageImportCandidate(generatedMedicine: generatedMedicine, scheduleMaxCount: scheduleMaxCount),
          ],
          maxSelectableCount: medicineMaxCount - createdMedicinesCount,
        );
        if (selectedCandidates == null || selectedCandidates.isEmpty) {
          return;
        }
        for (final candidate in selectedCandidates) {
          await medicineAdd(
            name: candidate.name,
            // スケジュール数の切り捨ては medicineImageImportCandidate (変換時) で適用済み。
            // ここの take はプレミアム失効等で build 間に上限が変わった場合の保険。
            frequency: const MedicationFrequency.daily(),
            schedules: candidate.schedules.take(scheduleMaxCount).toList(),
            doseReceiver: DoseReceiver.firstUser(userID: appUserID),
            memo: '',
            memoImageURL: '',
            beganDateTime: today(),
          );
        }
        unawaited(registerReminderLocalNotification());
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(L.medicineImageImportCompletedSnackbar(selectedCandidates.length))));
        }
      } catch (e) {
        if (context.mounted) {
          showErrorAlert(context, e.toString());
        }
      } finally {
        isLoading.value = false;
      }
    }

    return TextButton.icon(
      onPressed: createdMedicinesCount < medicineMaxCount && !isLoading.value ? importFromImage : null,
      icon: const Icon(Icons.photo_camera),
      label: Loading(
        isLoading: isLoading.value,
        child: Text(L.medicineImageImport, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      style: capsuleTextButtonStyle(context),
    );
  }
}
