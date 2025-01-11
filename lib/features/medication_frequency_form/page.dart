import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/container/flat_tile.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/style/button.dart';
import 'package:medicalarm/theme/form.dart';

class MedicationFrequencyFormPage extends HookConsumerWidget {
  final ValueNotifier<MedicationFrequency> frequency;
  const MedicationFrequencyFormPage({super.key, required this.frequency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frequency = useState(this.frequency.value);
    final frequencyValue = frequency.value;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return FormTheme(
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              ListTile(
                                title: const Text('毎日'),
                                trailing: frequency.value is DailyMedicationFrequency ? const Icon(Icons.check) : null,
                                onTap: () {
                                  frequency.value = const MedicationFrequency.daily();
                                },
                              ),
                              const Divider(color: Colors.black, height: 1),
                              ListTile(
                                title: const Text('X日ごと'),
                                trailing: frequency.value is EveryXDaysMedicationFrequency ? const Icon(Icons.check) : null,
                                onTap: () {
                                  frequency.value = const MedicationFrequency.everyXDays(interval: 1);
                                },
                              ),
                              const Divider(color: Colors.black, height: 1),
                              ListTile(
                                title: const Text('特定の曜日'),
                                trailing: frequency.value is SpecificDayOfWeekMedicationFrequency ? const Icon(Icons.check) : null,
                                onTap: () {
                                  frequency.value = const MedicationFrequency.specificDayOfWeek(daysOfWeek: [1, 2, 3, 4, 5, 6, 7]);
                                },
                              ),
                              const Divider(color: Colors.black, height: 1),
                              ListTile(
                                title: const Text('月の特定日'),
                                trailing: frequency.value is SpecificDayOfMonthMedicationFrequency ? const Icon(Icons.check) : null,
                                onTap: () {
                                  frequency.value = const MedicationFrequency.specificDayOfMonth(daysOfMonth: [1, 2, 3, 4, 5, 6, 7]);
                                },
                              ),
                              const Divider(color: Colors.black, height: 1),
                              ListTile(
                                title: const Text('奇数日/偶数日'),
                                trailing: frequency.value is OddOrEvenDayMedicationFrequency ? const Icon(Icons.check) : null,
                                onTap: () {
                                  frequency.value = const MedicationFrequency.oddOrEvenDay(isOddDay: true);
                                },
                              ),
                              const Divider(color: Colors.black, height: 1),
                              ListTile(
                                title: const Text('周期'),
                                trailing: frequency.value is CycleMedicationFrequency ? const Icon(Icons.check) : null,
                                onTap: () {
                                  frequency.value = const MedicationFrequency.cycle(consecutiveDays: 21, restDays: 7);
                                },
                              ),
                              const Divider(color: Colors.black, height: 1),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Column(
                            children: switch (frequencyValue) {
                              DailyMedicationFrequency() => [],
                              EveryXDaysMedicationFrequency() => [
                                  FlatTile(
                                    child: ListTile(
                                      title: const Text('X日ごと'),
                                      trailing: Text(frequencyValue.interval.toString()),
                                      onTap: () {},
                                    ),
                                  ),
                                ],
                              SpecificDayOfWeekMedicationFrequency() => [],
                              SpecificDayOfMonthMedicationFrequency() => [],
                              OddOrEvenDayMedicationFrequency() => [],
                              CycleMedicationFrequency() => [],
                            },
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: ElevatedButton(
                        style: elevatedButtonStyle,
                        onPressed: () {
                          this.frequency.value = frequency.value;
                          Navigator.pop(context);
                        },
                        child: const Text('保存'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
