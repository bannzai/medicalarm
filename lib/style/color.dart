import 'package:flutter/material.dart';

// Ref: https://saruwakakun.com/design/gallery/palette
abstract class AppColors {
  static const Color primary = Color(0xFFEE817B);
  // 画面がピンク一色になるのを避けるためのアクセントカラー (#265)。上記パレットにはピンク系以外の
  // 同伴色がないため独自選定。高彩度の補色ティール案(#009688)は目に強すぎるため不採用となり、
  // 低彩度4候補(グレー/ブルーグレー/スチールブルー/くすみティール)の実機比較でユーザーが Material Blue Grey 600 を選択した。
  // 白とのコントラスト比約5.4:1 で、選択状態インジケーターの 3:1 (WCAG 1.4.11) と小サイズ見出しの 4.5:1 (WCAG AA) をともに満たす
  // 用途: セクション見出しと選択系コントロール(Switch/Checkbox/Radio)。ブランド面(AppBar・主ボタン)は primary を維持する
  static const Color secondary = Color(0xFF546E7A);
  static const Color background = Color(0xFFFCECEA);
  static const Color formBackground = Color(0xFFF5F5F5);
  static const Color border = Color(0xFFE0E0E0);
  static const Color disabled = Color(0xFFE0E0E0);

  // カレンダー達成ドットの「未服用あり」を示す暖色 (#278)。issue #274 のデザインモックで指定された新規色で、
  // danger の赤(#B00020)より穏やかに注意を示す。達成(primary)と並べても攻撃的に見えないトーンを選んでいる
  static const Color achievementNone = Color(0xFFE8B5A8);

  static const Color sunday = Color(0xFFE17F7F);
  static const Color saturday = Color(0xFF7FB9E1);
  static const Color weekday = Color(0xFF7E7E7E);
}

abstract class TextColor {
  static const Color main = AppColors.primary;
  static const Color gray = Color(0xFF928484);
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color link = Colors.blueAccent;
  static const Color danger = Color(0xFFB00020);
  static const Color discount = Color(0xFFB00020);

  static Color highEmphasis(Color color) => color.withValues(alpha: 0.87);
  static Color mediumEmphasis(Color color) => color.withValues(alpha: 0.6);
  static Color disabled(Color color) => color.withValues(alpha: 0.37);
}
