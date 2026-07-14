import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/entity/group.dart';
import 'package:medicalarm/features/group/group_icon.dart';
import 'package:medicalarm/features/group_create/page.dart';
import 'package:medicalarm/features/group_invitation/page.dart';
import 'package:medicalarm/features/group_setting/page.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/preium_introduction/premium_introduction_sheet.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/user_groups.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';

/// 所属グループの一覧画面。設定画面から遷移する。
///
/// 各グループのアイコン・名前・メンバー数・既定バッジを表示し、グループ作成・招待コード参加への導線を持つ。
class GroupListPage extends HookConsumerWidget {
  const GroupListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userGroups = ref.watch(userGroupsProvider);

    return Retry(
      retry: () => ref.invalidate(userGroupsProvider),
      child: userGroups.when(
        data: (groups) => GroupListPageBody(groups: groups),
        error: (error, stackTrace) => RetryPage(exception: error),
        loading: () => const IndicatorPage(),
      ),
    );
  }
}

class GroupListPageBody extends HookConsumerWidget {
  final List<Group> groups;
  const GroupListPageBody({super.key, required this.groups});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUserID = ref.watch(appUserIDProvider);
    final defaultGroupID = ref.watch(appUserProvider).valueOrNull?.defaultGroupID;
    final hasPremiumEntitlement = ref.watch(customerInfoProvider).asData?.value.hasPremiumEntitlement ?? false;
    // 作成上限は「自分が作成した(ownerUserID == 自分)グループ数」で判定する（個別課金ポリシー）。
    final ownedGroupCount = groups.where((group) => group.ownerUserID == appUserID).length;
    final canCreateGroup = hasPremiumEntitlement || ownedGroupCount < freeAdditionalGroupCreationLimit + 1;

    return Scaffold(
      appBar: AppBar(title: Text(L.groups)),
      floatingActionButton: canCreateGroup
          ? FloatingActionButton.extended(
              onPressed: () => showGroupCreateForm(context),
              icon: const Icon(Icons.add),
              label: Text(L.createGroup),
            )
          : null,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: [
            for (final group in groups) ...[
              GroupListTile(group: group, isDefault: group.id == defaultGroupID),
              const Divider(height: 1),
            ],
            ListTile(
              leading: const Icon(Icons.login),
              title: Text(L.joinWithInvitationCode),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showGroupInvitationForm(context),
            ),
            if (!canCreateGroup) ...[
              const SizedBox(height: 16),
              const _CreationLimitBanner(),
            ],
          ],
        ),
      ),
    );
  }
}

class GroupListTile extends StatelessWidget {
  final Group group;
  final bool isDefault;
  const GroupListTile({super.key, required this.group, required this.isDefault});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return ListTile(
      leading: Icon(groupIconData(group.iconName), color: primaryColor),
      title: Text(group.name ?? L.soloGroupName),
      subtitle: Text(L.groupMemberCount(group.memberUserIDs.length)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isDefault) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(L.defaultGroupBadge, style: TextStyle(fontSize: 12, color: primaryColor)),
            ),
            const SizedBox(width: 8),
          ],
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GroupSettingPage(groupID: group.id)),
        );
      },
    );
  }
}

class _CreationLimitBanner extends ConsumerWidget {
  const _CreationLimitBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPremiumEntitlement = ref.watch(customerInfoProvider).asData?.value.hasPremiumEntitlement ?? false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text(L.groupCreationLimitReached, style: const TextStyle(color: Colors.red)),
          if (!hasPremiumEntitlement) ...[
            TextButton(
              onPressed: () => showPremiumIntroductionSheet(context),
              child: Text(
                L.increaseGroupLimitWithPremium,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
