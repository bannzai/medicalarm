import 'package:flutter/material.dart';

abstract class AppColors {
  // デザインリニューアル (#274)。旧ピンク(#EE817B)は対白コントラスト比 2.60:1 で WCAG AA (4.5:1) を満たさず、
  // 主要テキスト(時刻・薬名)が読みにくかった。服薬管理に求める「安心・清潔」のトーンに合わせ、
  // 低彩度のティールグリーン(対白 5.59:1 で AA 適合)へ刷新した。高彩度ティールは #265 の実機比較で
  // 目に強すぎると不採用になった経緯があるため、彩度を抑えた値にしている
  static const Color primary = Color(0xFF0A7568);
  // 画面が primary 一色になるのを避けるためのアクセントカラー (#265)。当時のピンク系パレットにはピンク系以外の
  // 同伴色がないため独自選定。高彩度の補色ティール案(#009688)は目に強すぎるため不採用となり、
  // 低彩度4候補(グレー/ブルーグレー/スチールブルー/くすみティール)の実機比較でユーザーが Material Blue Grey 600 を選択した。
  // 白とのコントラスト比約5.4:1 で、選択状態インジケーターの 3:1 (WCAG 1.4.11) と小サイズ見出しの 4.5:1 (WCAG AA) をともに満たす
  // 用途: セクション見出しと選択系コントロール(Switch/Checkbox/Radio)。ブランド面(AppBar・主ボタン)は primary を維持する
  static const Color secondary = Color(0xFF546E7A);
  // 旧ピンク淡色(#FCECEA)から暖色寄りのニュートラルへ (#274)。カードの白が主役になり情報が前に出る
  static const Color background = Color(0xFFF7F5F2);
  static const Color formBackground = Color(0xFFF5F5F5);
  static const Color border = Color(0xFFE0E0E0);
  static const Color disabled = Color(0xFFE0E0E0);

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
