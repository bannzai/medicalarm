import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:medicalarm/utils/launch/launch_stage.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(
          Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class IndicatorPage extends StatelessWidget {
  const IndicatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Indicator(),
          // 初回起動がスピナーのまま止まった時に、止まった段階をスクリーンショットから読めるようにする (#516)
          if (kDebugMode) const _LaunchStageDebugView(),
        ],
      ),
    );
  }
}

/// DEBUG ビルドで、起動の段階の記録 ([launchStageEntries]) と完了していない段階をスピナーの下に表示する。
class _LaunchStageDebugView extends HookWidget {
  const _LaunchStageDebugView();

  /// 表示する記録の件数。スクリーンショット 1 枚で読める文字の大きさに収まる件数にする。
  static const int _visibleEntryCount = 15;

  @override
  Widget build(BuildContext context) {
    // 記録は build 中にも追記されるため listen できない。件数を定期的に見て、増えていれば描き直す。
    // 間隔の 1 秒は、止まった時に撮るスクリーンショット (固まりは数分続く) に最新の記録が載るには十分で、
    // 描き直しの負荷も無視できる長さとして選んだ
    final entryCount = useState(launchStageEntries.length);
    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (entryCount.value != launchStageEntries.length) {
          entryCount.value = launchStageEntries.length;
        }
      });
      return timer.cancel;
    }, []);

    final entries = launchStageEntries.take(entryCount.value).toList();
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }
    final pendingStages = pendingLaunchStages(entries: entries);
    return Align(
      alignment: Alignment.bottomLeft,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          // 11pt・1 行 1 件は、iPhone SE (高さ 667pt) でも 15 件と pending の行がスピナーに重ならず収まり、
          // スクリーンショットで読める大きさとして選んだ。長いエラーは 1 行に切り詰め、画面からはみ出させない
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 11, color: Colors.black87),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'pending: ${pendingStages.isEmpty ? '-' : pendingStages.join(', ')}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  // 完了していない段階は止まった場所そのものなので、複数あっても読めるよう 3 行まで出す
                  maxLines: 3,
                ),
                for (final entry in entries.skip(entries.length > _visibleEntryCount ? entries.length - _visibleEntryCount : 0))
                  Text(launchStageEntryText(entry: entry)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
