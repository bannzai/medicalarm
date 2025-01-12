import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/components/loading/loading.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_form/components/additional_info/section.dart';
import 'package:medicalarm/features/medicine_form/components/medication_frequency/tile.dart';
import 'package:medicalarm/features/medicine_form/components/name_text_field.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/section.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/style/button.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/theme/form.dart';

class MedicineFormPage extends HookConsumerWidget {
  final Medicine? medicine;

  const MedicineFormPage({super.key, required this.medicine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = useState(medicine?.name ?? '');
    final frequency = useState(medicine?.frequency ?? const MedicationFrequency.daily());
    final schedules = useState(medicine?.schedules ?? []);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final memo = useState(medicine?.memo ?? '');
    final memoImageURL = useState(medicine?.memoImageURL ?? '');
    final doseReceiver = useState(medicine?.doseReceiver);

    final medicineAdd = ref.watch(medicineAddProvider);
    final medicineUpdate = ref.watch(medicineUpdateProvider);

    final isLoading = useState(false);
    final canSubmit = name.value.isNotEmpty && schedules.value.isNotEmpty;

    Future<void> submit() async {
      final medicine = this.medicine;
      if (medicine == null) {
        await medicineAdd(
          name: name.value,
          frequency: frequency.value,
          schedules: schedules.value,
          memo: memo.value,
          memoImageURL: memoImageURL.value,
          doseReceiver: doseReceiver.value,
        );
      } else {
        await medicineUpdate(
          medicineID: medicine.id,
          medicine: medicine,
          name: name.value,
          frequency: frequency.value,
          schedules: schedules.value,
          memo: memo.value,
          memoImageURL: memoImageURL.value,
          doseReceiver: doseReceiver.value,
        );
      }
    }

    return DraggableScrollableSheet(
        initialChildSize: 1.0,
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return FormTheme(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Medicine Form', style: TextStyle(color: primaryColor)),
              ),
              body: SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 60.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              children: [
                                MedicineFormNameTextField(name: name),
                                const SizedBox(height: 6),
                                MedicationFrequencyTile(frequency: frequency),
                              ],
                            ),
                          ),
                          const Divider(color: Colors.black, height: 1),
                          MedicineScheduleSection(schedules: schedules),
                          const Divider(color: Colors.black, height: 1),
                          MedicineAdditionalInfoSection(
                            memo: memo,
                            memoImageURL: memoImageURL,
                            doseReceiver: doseReceiver,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          children: [
                            const Spacer(),
                            if (!canSubmit) ...[
                              const Text('名前と服用スケジュールを入力してください', style: TextStyle(color: TextColor.danger, fontSize: 10.0)),
                            ],
                            Loading(
                              isLoading: isLoading.value,
                              child: ElevatedButton(
                                style: elevatedButtonStyle,
                                onPressed: canSubmit
                                    ? () async {
                                        try {
                                          if (isLoading.value) {
                                            return;
                                          }
                                          isLoading.value = true;

                                          await submit();
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
                                child: const Text('保存'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
