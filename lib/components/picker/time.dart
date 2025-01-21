import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medicalarm/components/picker/toolbar.dart';
import 'package:medicalarm/utils/config/environment.dart';
import 'package:flutter/cupertino.dart';

class AppTimePicker extends StatelessWidget {
  final TimeOfDay initialTime;

  const AppTimePicker({
    super.key,
    required this.initialTime,
  });

  @override
  Widget build(BuildContext context) {
    var selectedDateTime = DateTime.now().copyWith(hour: initialTime.hour, minute: initialTime.minute);
    var minimumInterval = 10;
    if (kDebugMode) {
      minimumInterval = 1;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        PickerToolbar(
          done: (() {
            Navigator.pop(context, selectedDateTime);
          }),
          cancel: (() => Navigator.pop(context, null)),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: CupertinoDatePicker(
                use24hFormat: true,
                minuteInterval: minimumInterval,
                initialDateTime: selectedDateTime,
                mode: CupertinoDatePickerMode.time,
                onDateTimeChanged: (DateTime value) {
                  selectedDateTime = value;
                },
              )),
        ),
      ],
    );
  }
}

Future<DateTime?> showAppTimePicker(BuildContext context, {required TimeOfDay initialTime}) {
  return showModalBottomSheet(
    useSafeArea: true,
    context: context,
    builder: (BuildContext context) {
      return AppTimePicker(
        initialTime: initialTime,
      );
    },
  );
}
