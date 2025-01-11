import 'package:flutter/material.dart';
import 'package:medicalarm/components/picker/toolbar.dart';
import 'package:flutter/cupertino.dart';

class AppNumberPicker extends StatelessWidget {
  final int initialNumber;

  const AppNumberPicker({
    super.key,
    required this.initialNumber,
  });

  @override
  Widget build(BuildContext context) {
    var selectedNumber = initialNumber;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        PickerToolbar(
          done: (() {
            Navigator.pop(context, selectedNumber);
          }),
          cancel: (() => Navigator.pop(context, null)),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: CupertinoPicker(
                itemExtent: 30,
                scrollController: FixedExtentScrollController(
                  initialItem: selectedNumber,
                ),
                onSelectedItemChanged: (int value) {
                  selectedNumber = value;
                },
                children: List.generate(100, (index) => Text('$index')),
              )),
        ),
      ],
    );
  }
}

Future<int?> showAppNumberPicker(BuildContext context, {required int initialNumber}) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return AppNumberPicker(initialNumber: initialNumber);
    },
  );
}
