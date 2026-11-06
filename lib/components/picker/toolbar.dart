import 'package:flutter/cupertino.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

class PickerToolbar extends StatelessWidget {
  final VoidCallback done;
  final VoidCallback cancel;

  const PickerToolbar({super.key, required this.done, required this.cancel});
  @override
  Widget build(BuildContext context) {
    // 既定の文字サイズでの行の高さ 44 を下限にし、文字を拡大した時は Cancel・Done の文字に合わせて伸ばす。
    // 高さを固定すると文字の上下が切れる (#522)
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CupertinoButton(
            onPressed: () {
              analytics.logEvent(name: 'picker_toolbar_cancel_pressed');
              cancel();
            },
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 5.0,
            ),
            child: Text(
              L.cancel,
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: TextColor.main,
              ),
            ),
          ),
          CupertinoButton(
            onPressed: () {
              analytics.logEvent(name: 'picker_toolbar_done_pressed');
              done();
            },
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 5.0,
            ),
            child: Text(
              L.completed,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: TextColor.main,
              ),
            ),
          )
        ],
      ),
    );
  }
}
