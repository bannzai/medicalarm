import 'package:flutter/material.dart';

/// 本文の下にボタン列を画面下部へ固定して並べるレイアウト。
///
/// ボタン列は本文に重ねず、Scaffold の背景色で塗った不透明な帯として本文の下に置く。以前は Stack で本文の上に
/// 重ねていたが、上限メッセージのような背景を持たない Text / TextButton を積むと、下でスクロールする本文と文字が
/// 重なって読めなくなっていた (#288)。帯の高さは上限メッセージの有無で変わるため、本文側の固定の下余白では
/// 末尾の内容 (薬の一覧の末尾カードの Switch 等) が帯の裏に隠れて操作できなくなる。本文を帯の分だけ縮めれば、
/// 呼び出し元がどの高さのボタン列を渡しても末尾までスクロールで到達できる
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

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              // 画面下端の安全領域は帯側の SafeArea が確保する。本文側にも残すと、本文の SafeArea が
              // 帯の上に同じ高さの空白を二重に作るため、本文へ渡す MediaQuery からは取り除く
              MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                child: scaffoldBody,
              ),
              // 本文と帯の境界をぼかすフェード。本文の末尾に重なるが IgnorePointer でタップは本文へ通す
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: Container(
                    // 本文の 1 行が完全には隠れず、境界が段差に見えない程度の高さ
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [backgroundColor.withValues(alpha: 0), backgroundColor],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // SafeArea を帯の内側に置き、ホームインジケーター領域まで背景色で塗る
        Container(
          width: double.infinity,
          color: backgroundColor,
          child: SafeArea(
            top: false,
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
    );
  }
}
