import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/picker/number.dart';
import 'package:medicalarm/features/medication_frequency_form/components/weekday_picker.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/features/medication_frequency_form/components/section_layout.dart';
import 'package:medicalarm/theme/form.dart';
import 'package:medicalarm/utils/date_time/weekday.dart';
import 'package:medicalarm/features/localization/l.dart';

class MedicationFrequencyFormPage extends HookConsumerWidget {
  final ValueNotifier<MedicationFrequency> frequency;
  const MedicationFrequencyFormPage({super.key, required this.frequency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frequency = useState(this.frequency.value);
    final frequencyValue = frequency.value;
    final weekdays = useState<List<Weekday>>(frequencyValue is SpecificWeekdaysMedicationFrequency ? frequencyValue.weekdays : Weekday.values);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: FormTheme(
            child: Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.only(top: 20.0, bottom: 60.0),
                        child: Column(
                          children: [
                            Text(L.medicationFrequency, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: primaryColor)),
                            MedicationFrequencyFormSectionLayout(
                              icon: Icons.schedule,
                              text: L.medicationFrequency,
                              children: [
                                ListTile(
                                  title: Text(L.daily),
                                  trailing: frequency.value is DailyMedicationFrequency ? const Icon(Icons.check) : null,
                                  onTap: () {
                                    frequency.value = const MedicationFrequency.daily();
                                  },
                                ),
                                const Divider(color: Colors.black, height: 1),
                                ListTile(
                                  title: Text(L.everyXDays),
                                  subtitle: Text(L.everyXDaysDescription),
                                  trailing: frequency.value is EveryXDaysMedicationFrequency ? const Icon(Icons.check) : null,
                                  onTap: () {
                                    frequency.value = const MedicationFrequency.everyXDays(interval: 1);
                                  },
                                ),
                                const Divider(color: Colors.black, height: 1),
                                ListTile(
                                  title: Text(L.specificWeekdays),
                                  subtitle: Text(L.specificWeekdaysDescription),
                                  trailing: frequency.value is SpecificWeekdaysMedicationFrequency ? const Icon(Icons.check) : null,
                                  onTap: () {
                                    frequency.value = const MedicationFrequency.specificWeekdays(weekdays: Weekday.values);
                                  },
                                ),
                                const Divider(color: Colors.black, height: 1),
                                ListTile(
                                  title: Text(L.cycle),
                                  subtitle: Text(L.cycleDescription),
                                  trailing: frequency.value is CycleMedicationFrequency ? const Icon(Icons.check) : null,
                                  onTap: () {
                                    frequency.value = const MedicationFrequency.cycle(consecutiveDays: 21, restDays: 7);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            switch (frequencyValue) {
                              DailyMedicationFrequency() => const SizedBox.shrink(),
                              EveryXDaysMedicationFrequency() => MedicationFrequencyFormSectionLayout(
                                  icon: Icons.schedule,
                                  text: L.everyXDays,
                                  children: [
                                    ListTile(
                                      title: Text(L.everyXDaysFormat(frequencyValue.interval)),
                                      trailing: const Icon(Icons.chevron_right),
                                      onTap: () async {
                                        final interval = await showModalBottomSheet<int>(
                                          context: context,
                                          useSafeArea: true,
                                          barrierColor: Colors.transparent,
                                          builder: (context) => AppNumberPicker(initialNumber: frequencyValue.interval),
                                        );
                                        if (interval != null) {
                                          frequency.value = MedicationFrequency.everyXDays(interval: interval);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              SpecificWeekdaysMedicationFrequency() => MedicationFrequencyFormSectionLayout(
                                  icon: Icons.schedule,
                                  text: L.specificWeekdays,
                                  children: [
                                    WeekdayPicker(weekdays: weekdays),
                                  ],
                                ),
                              CycleMedicationFrequency() => MedicationFrequencyFormSectionLayout(
                                  icon: Icons.schedule,
                                  text: L.cycle,
                                  children: [
                                    ListTile(
                                      title: Text(L.consecutiveDaysFormat(frequencyValue.consecutiveDays)),
                                      trailing: const Icon(Icons.chevron_right),
                                      onTap: () async {
                                        final consecutiveDays = await showModalBottomSheet<int>(
                                          context: context,
                                          useSafeArea: true,
                                          builder: (context) => AppNumberPicker(initialNumber: frequencyValue.consecutiveDays),
                                        );
                                        if (consecutiveDays != null) {
                                          frequency.value = MedicationFrequency.cycle(
                                            consecutiveDays: consecutiveDays,
                                            restDays: frequencyValue.restDays,
                                          );
                                        }
                                      },
                                    ),
                                    const Divider(color: Colors.black, height: 1),
                                    ListTile(
                                      title: Text(L.restDaysFormat(frequencyValue.restDays)),
                                      trailing: const Icon(Icons.chevron_right),
                                      onTap: () async {
                                        final restDays = await showModalBottomSheet<int>(
                                          context: context,
                                          useSafeArea: true,
                                          builder: (context) => AppNumberPicker(initialNumber: frequencyValue.restDays),
                                        );
                                        if (restDays != null) {
                                          frequency.value = MedicationFrequency.cycle(
                                            consecutiveDays: frequencyValue.consecutiveDays,
                                            restDays: restDays,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                            }
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: ElevatedButton(
                            onPressed: () {
                              this.frequency.value = frequency.value;
                              Navigator.pop(context);
                            },
                            child: Text(L.save),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
