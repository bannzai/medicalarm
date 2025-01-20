import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/components/container/flat_tile.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';

class MedicationBeginTile extends StatelessWidget {
  final ValueNotifier<DateTime> begin;
  const MedicationBeginTile({super.key, required this.begin});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: FlatTile(
        child: ListTile(
          title: const Text('飲む頻度'),
          trailing: Wrap(
            children: [
              Text(DateFormat('yyyy/MM/dd').format(begin.value)),
              const Icon(Icons.chevron_right),
            ],
          ),
          onTap: () async {
            final firstDate = today().subtract(const Duration(days: 365));
            final lastDate = today();
            final result = await showDatePicker(context: context, firstDate: firstDate, lastDate: lastDate);
            if (result != null) {
              begin.value = result;
            }
          },
        ),
      ),
    );
  }
}
