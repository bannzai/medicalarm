import 'package:flutter/material.dart';
import 'package:medicalarm/components/picker/toolbar.dart';
import 'package:medicalarm/utils/config/environment.dart';
import 'package:flutter/cupertino.dart';

class AppTimePicker extends StatelessWidget {
  final DateTime initialDateTime;

  const AppTimePicker({
    super.key,
    required this.initialDateTime,
  });

  @override
  Widget build(BuildContext context) {
    var selectedDateTime = initialDateTime;
    var minimumInterval = 10;
    if (Environment.isDevelopment) {
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

Future<TimeOfDay?> showAppTimePicker(BuildContext context, {required DateTime initialDateTime}) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return AppTimePicker(
        initialDateTime: initialDateTime,
      );
    },
  );
}
