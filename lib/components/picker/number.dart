import 'package:flutter/material.dart';
import 'package:medicalarm/components/picker/toolbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

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
                analytics.logEvent(name: 'number_picker_area_tapped');
                Navigator.pop(context);
              },
              child: CupertinoPicker(
                // 既定の文字サイズの項目の高さ 30 を、端末の文字の倍率に合わせて伸ばす。
                // 固定のままだと文字を拡大した時に数字の上下が切れる (#522)
                itemExtent: MediaQuery.textScalerOf(context).scale(30),
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
    useSafeArea: true,
    context: context,
    builder: (BuildContext context) {
      return AppNumberPicker(initialNumber: initialNumber);
    },
  );
}
