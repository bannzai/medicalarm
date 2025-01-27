import 'package:flutter/widgets.dart';

class FloatingActionButtonLayout extends StatelessWidget {
  final Widget scaffoldBody;
  final Widget floatingActionButton;

  const FloatingActionButtonLayout({
    super.key,
    required this.scaffoldBody,
    required this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        scaffoldBody,
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(),
                floatingActionButton,
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
