import 'package:flutter/material.dart';

/// Flutterの [Checkbox] はSizeの調整をするのが難しいので、カスタムで作成する。Rowに置いた時もAlignmentが揃わない問題がある
class AppCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  AppCheckboxState createState() => AppCheckboxState();
}

class AppCheckboxState extends State<AppCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        width: 24.0,
        height: 24.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 2.0),
        ),
        child: CustomPaint(
          painter: _CheckboxPainter(isChecked: widget.value),
        ),
      ),
    );
  }
}

class _CheckboxPainter extends CustomPainter {
  final bool isChecked;

  _CheckboxPainter({required this.isChecked});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    if (isChecked) {
      final path = Path()
        ..moveTo(size.width * 0.2, size.height * 0.5)
        ..lineTo(size.width * 0.4, size.height * 0.7)
        ..lineTo(size.width * 0.8, size.height * 0.3);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
