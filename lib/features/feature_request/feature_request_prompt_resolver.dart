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

Future<void> _maybeShowPrompt({required BuildContext context, required DateTime createdDateTime}) async {
  if (DateTime.now().difference(createdDateTime).inDays < 3) return;

  final prefs = await SharedPreferences.getInstance();
  final lastShownEpoch = prefs.getDouble(DoubleKey.featureRequestPromptShownDateTimeInterval) ?? 0;
  final lastShown = DateTime.fromMillisecondsSinceEpoch((lastShownEpoch * 1000).toInt());
  if (DateTime.now().difference(lastShown).inDays < 30) return;

  if (!context.mounted) return;
  await prefs.setDouble(
    DoubleKey.featureRequestPromptShownDateTimeInterval,
    DateTime.now().millisecondsSinceEpoch / 1000.0,
  );
  analytics.logEvent(name: 'feature_request_prompt_shown');

  if (!context.mounted) return;
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
