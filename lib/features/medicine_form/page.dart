import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_form/components/notification_setting/section.dart';
import 'package:medicalarm/features/medicine_form/components/section.dart';
import 'package:medicalarm/style/button.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/theme/form.dart';

class MedicineFormPage extends HookConsumerWidget {
  final Medicine? medicine;

  const MedicineFormPage({super.key, required this.medicine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = useState(medicine?.name ?? '');
    final notificationSettings = useState(medicine?.notificationSettings ?? []);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return FormTheme(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Medicine Form', style: TextStyle(color: primaryColor)),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                child: TextFormField(
                  initialValue: name.value,
                  onChanged: (value) {
                    name.value = value;
                  },
                  decoration: const InputDecoration(
                    hintText: '薬の名前',
                  ),
                ),
              ),
              Section(
                icon: Icons.schedule,
                text: '服用時刻',
                children: [
                  MedicineNotificationSettingSection(notificationSettings: notificationSettings),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
