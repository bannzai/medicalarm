import 'package:medicalarm/components/picker/toolbar.dart';
import 'package:flutter/cupertino.dart';

class NumberPicker extends StatelessWidget {
  final int initialNumber;
  final void Function(int number) done;

  const NumberPicker({
    super.key,
    required this.initialNumber,
    required this.done,
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
            done(selectedNumber);
          }),
          cancel: (() => Navigator.pop(context)),
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
