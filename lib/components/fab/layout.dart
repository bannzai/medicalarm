import 'package:flutter/material.dart';

/// 本文の上にボタン列を重ねて画面下部へ固定するレイアウト。
///
/// 重ねる領域には Scaffold の背景色で不透明な下地を敷く。ボタン自身は不透明だが、
/// 上限メッセージのような背景を持たない Text / TextButton を積むと、下でスクロールする本文と文字が重なって
/// 読めなくなるため (#288)。下地の上端は透明から背景色へのグラデーションにして、本文との境界を自然にする
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
    // Scaffold は backgroundColor 未指定時にこの色へフォールバックするため、どの呼び出し元の本文とも同じ色になる
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Stack(
      children: [
        scaffoldBody,
        Align(
          alignment: Alignment.bottomCenter,
          // mainAxisSize.min にしないと Column が Stack の全高に広がり、下地が本文全体を覆ってしまう
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 本文との境界をぼかすフェード。タップは通さないため、
              // 本文の末尾がこの領域に隠れないよう、呼び出し元のスクロール領域側で下余白を確保する
              Container(
                // ボタン列との高さの比率で不自然にならず、本文の 1 行が完全に隠れない程度の高さ
                height: 24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [backgroundColor.withValues(alpha: 0), backgroundColor],
                  ),
                ),
              ),
              // SafeArea の外に置き、ホームインジケーター領域まで下地を塗る
              Container(
                width: double.infinity,
                color: backgroundColor,
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      floatingActionButton,
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
