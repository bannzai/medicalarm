import 'package:flutter/material.dart';

/// 画面の上端 (ステータスバー) だけを避けて全画面に広がるモーダルボトムシートを表示する。
///
/// showModalBottomSheet の useSafeArea は上だけでなく左右の safe area も避けるため、iPhone Duo のように
/// 右端にステータス表示の列 (右側の safe area) がある端末では、シートがその分だけ狭まり、空いた列にモーダルの
/// バリア (暗い帯) が見えていた (#370)。他の全画面の Scaffold と同じく、シートは左右の safe area の下まで広げ、
/// 中身の Scaffold / SafeArea が左右を避ける。上端の余白は useSafeArea と同じ高さにするため、祖先の Scaffold や
/// SafeArea が消費した後の MediaQuery ではなく、View から端末の値を直接読む。
Future<T?> showFullScreenModalBottomSheet<T>({required BuildContext context, required WidgetBuilder builder}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: false,
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(top: MediaQueryData.fromView(View.of(sheetContext)).padding.top),
      child: builder(sheetContext),
    ),
  );
}
