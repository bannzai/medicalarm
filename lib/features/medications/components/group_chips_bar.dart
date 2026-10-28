import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/group/group_icon.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/current_group_id.dart';
import 'package:medicalarm/provider/default_group_update.dart';
import 'package:medicalarm/provider/user_groups.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

/// 服薬一覧画面の上部に表示する、表示中グループを切り替えるチップの列。
///
/// 所属グループが 1 つ以下のときは何も表示しない。チップをタップすると表示中グループ
/// ([currentGroupIDProvider]) を切り替え、併せて既定グループ ([defaultGroupUpdateProvider]) を更新する。
class GroupChipsBar extends HookConsumerWidget {
  const GroupChipsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(userGroupsProvider).valueOrNull ?? [];
    final currentGroupID = ref.watch(currentGroupIDProvider);

    if (groups.length <= 1) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          for (final group in groups) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                avatar: Icon(groupIconData(group.iconName), size: 18),
                label: Text(group.name ?? L.soloGroupName),
                selected: group.id == currentGroupID,
                onSelected: (_) {
                  analytics.logEvent(name: 'group_chip_selected');
                  // 既に選択中のグループの再選択は無視する(冗長な書き込みを避ける)。
                  if (group.id == currentGroupID) {
                    return;
                  }
                  ref.read(currentGroupIDProvider.notifier).update(group.id);
                  unawaited(ref.read(defaultGroupUpdateProvider).call(groupID: group.id));
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
