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
    // 記録は build 中にも追記されるため listen できない。1 秒ごとに件数を見て、増えていれば描き直す
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
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 11, color: Colors.black87),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'pending: ${pendingStages.isEmpty ? '-' : pendingStages.join(', ')}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
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
