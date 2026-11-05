import 'package:flutter/foundation.dart';

/// 起動の段階の記録 1 件。
///
/// 初回起動がスピナーのまま止まった時に、どの段階で止まったかを DEBUG ビルドの画面 (IndicatorPage) から読み取るために使う (#516)。
/// [kind] は start (非同期の処理の開始)・done (完了)・fail (失敗)・reached (Resolver を通過した、stream の最初の値が届いた等の到達点) のいずれか。
typedef LaunchStageEntry = ({Duration elapsed, String kind, String stage, String? detail});

/// アプリの起動からの経過時間。最初の記録の時点から計る (Dart のトップレベル変数は初回参照で初期化されるため)。
final Stopwatch _launchStopwatch = Stopwatch()..start();

/// DEBUG ビルドで記録した起動の段階。記録の順に並ぶ。release ビルドでは空のまま。
///
/// build 中にも追記するため、listen させる ValueNotifier にはしない。表示側が定期的に読み直す。
final List<LaunchStageEntry> launchStageEntries = [];

/// [stage] の到達を記録する。[detail] は uid など、段階の補足。DEBUG ビルドでだけ記録する。
void recordLaunchStage({required String kind, required String stage, String? detail}) {
  if (!kDebugMode) {
    return;
  }
  final entry = (elapsed: _launchStopwatch.elapsed, kind: kind, stage: stage, detail: detail);
  launchStageEntries.add(entry);
  debugPrint('[LAUNCH] ${launchStageEntryText(entry: entry)}');
}

/// [stage] の到達を、同じ [stage] でまだ記録していない時だけ記録する。build のたびに呼ばれる到達点に使う。
void recordLaunchStageOnce({required String stage, String? detail}) {
  if (launchStageEntries.any((entry) => entry.kind == 'reached' && entry.stage == stage)) {
    return;
  }
  recordLaunchStage(kind: 'reached', stage: stage, detail: detail);
}

/// [operation] の開始・完了・失敗を [stage] として記録して、[operation] の結果をそのまま返す。例外もそのまま投げ直す。
Future<T> traceLaunchStage<T>({required String stage, required Future<T> Function() operation}) async {
  recordLaunchStage(kind: 'start', stage: stage);
  try {
    final result = await operation();
    recordLaunchStage(kind: 'done', stage: stage);
    return result;
  } catch (error) {
    recordLaunchStage(kind: 'fail', stage: stage, detail: '$error');
    rethrow;
  }
}

/// [entries] のうち、完了も失敗もしていない実行が残っている段階を、残っている実行を最後に開始した順に返す。
///
/// 同じ段階が並行して動くことがある (例: firstDoseReceiverAdd の実行中に doseReceivers が再度流れる) ため、
/// 段階ごとに start の数から done・fail の数を引いた残りで判定する。
List<String> pendingLaunchStages({required List<LaunchStageEntry> entries}) {
  final runningCountByStage = <String, int>{};
  for (final entry in entries) {
    switch (entry.kind) {
      case 'start':
        runningCountByStage[entry.stage] = (runningCountByStage.remove(entry.stage) ?? 0) + 1;
      case 'done' || 'fail':
        runningCountByStage[entry.stage] = (runningCountByStage[entry.stage] ?? 0) - 1;
    }
  }
  return [
    for (final stageAndCount in runningCountByStage.entries)
      if (stageAndCount.value > 0) stageAndCount.key,
  ];
}

/// [entry] を「経過秒 kind stage (detail)」の 1 行にする。
String launchStageEntryText({required LaunchStageEntry entry}) {
  final detail = entry.detail;
  return '${(entry.elapsed.inMilliseconds / 1000).toStringAsFixed(1)}s ${entry.kind} ${entry.stage}${detail == null ? '' : ' ($detail)'}';
}
