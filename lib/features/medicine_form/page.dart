import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/button/buttons.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/components/fab/layout.dart';
import 'package:medicalarm/components/keyboard/toolbar.dart';
import 'package:medicalarm/components/loading/loading.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_form/components/additional_info/section.dart';
import 'package:medicalarm/features/medicine_form/components/begin/tile.dart';
import 'package:medicalarm/features/medicine_form/components/medication_frequency/tile.dart';
import 'package:medicalarm/features/medicine_form/components/name_text_field.dart';
import 'package:medicalarm/features/medicine_form/components/pause/tile.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/section.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/theme/form.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:medicalarm/features/localization/l.dart';

class MedicineFormPage extends HookConsumerWidget {
  final Medicine? medicine;

  const MedicineFormPage({super.key, required this.medicine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userID = ref.watch(appUserIDProvider);
    final name = useState(medicine?.name ?? '');
    final frequency = useState(medicine?.frequency ?? const MedicationFrequency.daily());
    final begin = useState(medicine?.beganDateTime ?? today());
    final schedules = useState(medicine?.schedules ?? []);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final memo = useState(medicine?.memo ?? '');
    final memoImageURL = useState(medicine?.memoImageURL ?? '');
    final doseReceiver = useState<DoseReceiver>(medicine?.doseReceiver ?? DoseReceiver.firstUser(userID: userID));

    // MedicinePauseTile 等で編集中に外部から更新された pausedDateTime を保存処理に取り込むため、activeMedicinesProvider から最新の Medicine を解決する
    final currentMedicine =
        medicine == null ? null : ref.watch(activeMedicinesProvider).valueOrNull?.firstWhereOrNull((m) => m.id == medicine!.id) ?? medicine;

    final medicineAdd = ref.watch(medicineAddProvider);
    final medicineUpdate = ref.watch(medicineUpdateProvider);

    final isLoading = useState(false);
    final canSubmit = name.value.isNotEmpty && schedules.value.isNotEmpty;

    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);

    final nameFocusNode = useFocusNode();
    final memoFocusNode = useFocusNode();

    Future<void> submit() async {
      if (currentMedicine == null) {
        await medicineAdd(
          name: name.value,
          frequency: frequency.value,
          schedules: schedules.value,
          memo: memo.value,
          memoImageURL: memoImageURL.value,
          doseReceiver: doseReceiver.value,
          beganDateTime: begin.value,
        );
      } else {
        await medicineUpdate(
          medicineID: currentMedicine.id,
          medicine: currentMedicine,
          name: name.value,
          frequency: frequency.value,
          schedules: schedules.value,
          memo: memo.value,
          memoImageURL: memoImageURL.value,
          doseReceiver: doseReceiver.value,
          beganDateTime: begin.value,
        );
      }
    }

    return DraggableScrollableSheet(
        initialChildSize: 1.0,
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: FormTheme(
              // showModalBottomSheet 内では ScaffoldMessenger.of がルート側に解決され、
              // 全画面モーダルの背後に SnackBar が表示されて見えないため、モーダル内に ScaffoldMessenger を持つ
              child: ScaffoldMessenger(
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(L.medicineRegistration, style: TextStyle(color: primaryColor)),
                    actions: [
                      IconButton(
                        onPressed: () async {
                          final medicineID = medicine?.id;
                          if (medicineID != null) {
                            try {
                              unawaited(ref.read(registerReminderLocalNotificationProvider).call());
                              await ref.read(medicineDeleteProvider).call(medicineID: medicineID);
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            } catch (e) {
                              if (context.mounted) {
                                showErrorAlert(context, e.toString());
                              }
                            }
                          }
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                  body: FloatingActionButtonLayout(
                    scaffoldBody: SafeArea(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.only(bottom: 60.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                                        child: Column(
                                          children: [
                                            MedicineFormNameTextField(name: name, focusNode: nameFocusNode),
                                            const SizedBox(height: 6),
                                            MedicationFrequencyTile(frequency: frequency),
                                            const SizedBox(height: 6),
                                            MedicationBeginTile(begin: begin),
                                            if (currentMedicine != null) ...[
                                              const SizedBox(height: 6),
                                              MedicinePauseTile(medicine: currentMedicine),
                                            ],
                                          ],
                                        ),
                                      ),
                                      const Divider(color: Colors.black, height: 1),
                                      MedicineScheduleSection(schedules: schedules, medicine: currentMedicine),
                                      const Divider(color: Colors.black, height: 1),
                                      MedicineAdditionalInfoSection(
                                        memo: memo,
                                        memoImageURL: memoImageURL,
                                        doseReceiver: doseReceiver,
                                        memoFocusNode: memoFocusNode,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (nameFocusNode.hasFocus || memoFocusNode.hasFocus) ...[
                                KeyboardToolbar(
                                  doneButton: AlertButton(
                                    text: L.completed,
                                    onPressed: () async {
                                      analytics.logEvent(name: 'medicine_form_done_button_pressed');
                                      nameFocusNode.unfocus();
                                      memoFocusNode.unfocus();
                                    },
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    floatingActionButton: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            if (!canSubmit) ...[
                              Text(L.medicineFormValidationError, style: const TextStyle(color: TextColor.danger, fontSize: 10.0)),
                            ],
                            ElevatedButton.icon(
                              onPressed: canSubmit
                                  ? () async {
                                      try {
                                        if (isLoading.value) {
                                          return;
                                        }
                                        isLoading.value = true;

                                        await submit();
                                        unawaited(registerReminderLocalNotification());

                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          showErrorAlert(context, e.toString());
                                        }
                                      } finally {
                                        isLoading.value = false;
                                      }
                                    }
                                  : null,
                              label: Loading(
                                isLoading: isLoading.value,
                                child: Text(L.save),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

void showMedicineForm(BuildContext context, Medicine? medicine) {
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => MedicineFormPage(medicine: medicine),
  );
}
