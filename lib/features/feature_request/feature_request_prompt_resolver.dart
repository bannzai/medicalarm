import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/feature_request/page.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/shared_preferences/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// アプリ起動時に「機能要望を送ってみませんか？」ダイアログを出す Resolver。
/// 表示条件:
///   1. リリースビルドであること（kReleaseMode）。開発時は煩いため出さない。
///   2. AppUser.createdDateTime から 3 日以上経過していること。
///   3. 前回ダイアログ表示から 30 日以上経過していること（再表示頻度の上限）。
/// 表示後は SharedPreferences に表示日時 (epoch sec) を保存して再表示を抑止する。
class FeatureRequestPromptResolver extends HookConsumerWidget {
  const FeatureRequestPromptResolver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(appUserProvider).asData?.value;
    useEffect(() {
      if (!kReleaseMode) return null;
      final createdDateTime = appUser?.createdDateTime;
      if (createdDateTime == null) return null;
      unawaited(_maybeShowPrompt(context: context, createdDateTime: createdDateTime));
      return null;
    }, [appUser?.id]);
    return const SizedBox.shrink();
  }
}

/// [createdDateTime] (ユーザーの作成日時) と前回の表示日時が表示条件を満たす時だけ、ダイアログを出して表示日時を保存する。
/// 「要望を送る」が押された時は機能要望フォームを開く。
Future<void> _maybeShowPrompt({required BuildContext context, required DateTime createdDateTime}) async {
  // 3 日と 30 日は Focus アプリの LaunchPageResolver の表示条件に揃えた値 (アプリを試す前の利用者に聞かず、聞く頻度を月 1 回までにする)
  if (DateTime.now().difference(createdDateTime).inDays < 3) return;

  final prefs = await SharedPreferences.getInstance();
  // 1 行に収めると 60 文字を超える条件式になるため、前回の表示日時を変数にまとめる (CLAUDE.md の一時変数の規約)。
  // 未表示の時は epoch 0 (1970 年) として 30 日の条件を満たす扱いにする
  final lastShown =
      DateTime.fromMillisecondsSinceEpoch(((prefs.getDouble(DoubleKey.featureRequestPromptLastShownEpochSeconds) ?? 0) * 1000).toInt());
  if (DateTime.now().difference(lastShown).inDays < 30) return;

  if (!context.mounted) return;
  await prefs.setDouble(
    DoubleKey.featureRequestPromptLastShownEpochSeconds,
    DateTime.now().millisecondsSinceEpoch / 1000.0,
  );
  analytics.logEvent(name: 'feature_request_prompt_shown');

  if (!context.mounted) return;
  // showDialog の呼び出しごと条件式に入れると 60 文字を超えるため、選択結果を変数にまとめる (CLAUDE.md の一時変数の規約)
  final accepted = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(L.featureRequestPromptTitle),
      content: Text(L.featureRequestPromptMessage),
      actions: [
        TextButton(
          onPressed: () {
            analytics.logEvent(name: 'feature_request_prompt_dismissed');
            Navigator.of(dialogContext).pop(false);
          },
          child: Text(L.later),
        ),
        TextButton(
          onPressed: () {
            analytics.logEvent(name: 'feature_request_prompt_accepted');
            Navigator.of(dialogContext).pop(true);
          },
          child: Text(L.featureRequestPromptCta),
        ),
      ],
    ),
  );
  if (accepted == true && context.mounted) {
    showFeatureRequestForm(context);
  }
}
