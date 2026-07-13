import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_group_id.g.dart';

/// 現在表示中のグループ ID。アプリ全体で 1 つだけ保持する選択状態。
///
/// 既定値(appUser.defaultGroupID)の初期化は CurrentGroupResolver が行う。
/// ここで appUserProvider を読まないのは、appUser の更新ごとに build が再実行され
/// ユーザーの手動グループ切替がリセットされるのを避けるため。
@riverpod
class CurrentGroupID extends _$CurrentGroupID {
  @override
  String? build() => null;

  /// 表示中グループを切り替える。
  void update(String groupID) => state = groupID;

  /// 表示中グループの選択を解除する。所属グループが 1 つも無い等、有効な選択先が無い場合に使う。
  void reset() => state = null;
}
