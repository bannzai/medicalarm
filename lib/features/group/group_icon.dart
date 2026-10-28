import 'package:flutter/material.dart';

/// グループの [Group.iconName] に対応する [IconData] を返す。
///
/// 未知の識別子や既存ドキュメントの欠損時は home をフォールバックとして返す
/// （[Group.iconName] のデフォルトが home のため表示を揃える）。
IconData groupIconData(String iconName) {
  switch (iconName) {
    case 'family':
      return Icons.family_restroom;
    case 'hospital':
      return Icons.local_hospital;
    case 'medication':
      return Icons.medication;
    case 'elderly':
      return Icons.elderly;
    case 'favorite':
      return Icons.favorite;
    case 'home':
    default:
      return Icons.home;
  }
}

/// グループ作成画面でユーザーが選択できるアイコン識別子の一覧（表示順）。
const List<String> selectableGroupIconNames = [
  'home',
  'family',
  'hospital',
  'medication',
  'elderly',
  'favorite',
];
