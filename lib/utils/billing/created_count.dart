/// 個別課金ポリシー: グループ共有では他メンバーが作成したデータが一覧に混ざるため、
/// Medicine / DoseReceiver 等の作成上限は一覧の総数ではなく「自分が作成した件数」で判定する。
int countCreatedByUser<T>({
  required Iterable<T> items,
  required String userID,
  required String Function(T item) creatorUserID,
}) =>
    items.where((item) => creatorUserID(item) == userID).length;
