import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';

class InAppReviewResolver extends HookConsumerWidget {
  const InAppReviewResolver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationHistories = ref.watch(medicationHistoriesByDateProvider(today())).asData?.value;
    useEffect(() {
      // Android では呼びすぎると無効化されてしまうためuseEffectで制限
      // 取消(revert)済みの記録しかない日はレビュー訴求しないよう、revert に打ち消されていない take だけを数える (#253)
      if (effectiveTakeMedicationHistories(medicationHistories ?? []).isNotEmpty) {
        // 画面が固まるので開発次は無効化。おそらくストアリリースしてないせい
        if (kReleaseMode) {
          unawaited(InAppReview.instance.requestReview());
        }
      }
      return null;
    }, [medicationHistories]);

    return const SizedBox.shrink();
  }
}
