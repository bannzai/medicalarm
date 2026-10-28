import 'package:async_value_group/async_value_group.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/entity/group.dart';
import 'package:medicalarm/entity/group_user_profile.dart';
import 'package:medicalarm/features/group/invitation_code_dialog.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/group.dart';
import 'package:medicalarm/provider/group_invitation.dart';
import 'package:medicalarm/provider/group_user_profile.dart';
import 'package:medicalarm/theme/form.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/functions/firebase_functions.dart';

/// グループ設定画面。名前編集（オーナーのみ）・メンバー一覧・メンバー削除（オーナーのみ）・
/// 自分の表示名編集・招待コード発行を行う。
class GroupSettingPage extends HookConsumerWidget {
  final String groupID;
  const GroupSettingPage({super.key, required this.groupID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupProvider(groupID: groupID));
    final userProfiles = ref.watch(groupUserProfilesProvider(groupID: groupID));

    return Retry(
      retry: () {
        ref.invalidate(groupProvider(groupID: groupID));
        ref.invalidate(groupUserProfilesProvider(groupID: groupID));
      },
      child: AsyncValueGroup.group2(group, userProfiles).when(
        data: (data) => GroupSettingPageBody(groupID: groupID, group: data.$1, userProfiles: data.$2),
        error: (error, stackTrace) => RetryPage(exception: error),
        loading: () => const IndicatorPage(),
      ),
    );
  }
}

class GroupSettingPageBody extends HookConsumerWidget {
  final String groupID;
  final Group group;
  final List<GroupUserProfile> userProfiles;

  const GroupSettingPageBody({
    super.key,
    required this.groupID,
    required this.group,
    required this.userProfiles,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final appUserID = ref.watch(appUserIDProvider);
    final isOwner = group.ownerUserID == appUserID;
    final groupNameUpdate = ref.watch(groupNameUpdateProvider(groupID: groupID));
    final groupUserProfileUpdate = ref.watch(groupUserProfileUpdateProvider(groupID: groupID));
    final createGroupInvitation = ref.watch(createGroupInvitationProvider);
    final myProfile = userProfiles.firstWhereOrNull((profile) => profile.userID == appUserID);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: FormTheme(
        child: Scaffold(
          appBar: AppBar(title: Text(L.groupSettings, style: TextStyle(color: primaryColor))),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(L.groupName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: group.name ?? '',
                    readOnly: !isOwner,
                    decoration: InputDecoration(hintText: L.groupNameInputHint),
                    onFieldSubmitted: isOwner
                        ? (value) {
                            analytics.logEvent(name: 'group_setting_name_submitted');
                            groupNameUpdate.call(name: value);
                          }
                        : null,
                  ),
                  const SizedBox(height: 24),
                  Text(L.yourDisplayName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: myProfile?.displayName ?? '',
                    decoration: InputDecoration(hintText: L.displayNameInputHint),
                    onFieldSubmitted: (value) {
                      analytics.logEvent(name: 'group_setting_disp_name_submitted');
                      groupUserProfileUpdate.call(userID: appUserID, displayName: value);
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(L.members, style: const TextStyle(fontWeight: FontWeight.bold)),
                  for (final memberUserID in group.memberUserIDs) ...[
                    GroupMemberTile(
                      groupID: groupID,
                      memberUserID: memberUserID,
                      displayName: userProfiles.firstWhereOrNull((profile) => profile.userID == memberUserID)?.displayName,
                      isOwnerOfGroup: memberUserID == group.ownerUserID,
                      isSelf: memberUserID == appUserID,
                      // オーナーは自分以外のメンバーを削除できる。オーナー自身(=自分)は削除不可。
                      canRemove: isOwner && memberUserID != appUserID,
                    ),
                  ],
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () async {
                      analytics.logEvent(name: 'group_setting_invite_pressed');
                      try {
                        final invitation = await createGroupInvitation.call(groupID: groupID);
                        if (context.mounted) {
                          await showInvitationCodeDialog(context,
                              invitationCode: invitation.invitationCode, expiresDateTime: invitation.expiresDateTime);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          showErrorAlert(context, e.toString());
                        }
                      }
                    },
                    icon: const Icon(Icons.add_link),
                    label: Text(L.issueInvitationCode),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GroupMemberTile extends HookConsumerWidget {
  final String groupID;
  final String memberUserID;
  final String? displayName;
  final bool isOwnerOfGroup;
  final bool isSelf;
  final bool canRemove;

  const GroupMemberTile({
    super.key,
    required this.groupID,
    required this.memberUserID,
    required this.displayName,
    required this.isOwnerOfGroup,
    required this.isSelf,
    required this.canRemove,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolvedName = (displayName?.isNotEmpty ?? false) ? displayName! : L.memberFallbackName;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.person),
      title: Row(
        children: [
          Flexible(child: Text(resolvedName)),
          if (isSelf) ...[
            const SizedBox(width: 8),
            _MemberBadge(text: L.youLabel),
          ],
          if (isOwnerOfGroup) ...[
            const SizedBox(width: 8),
            _MemberBadge(text: L.ownerLabel),
          ],
        ],
      ),
      trailing: canRemove
          ? IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () async {
                analytics.logEvent(name: 'group_member_remove_pressed');
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(L.removeMemberConfirmTitle),
                    content: Text(L.removeMemberConfirmMessage(resolvedName)),
                    actions: [
                      TextButton(
                        onPressed: () {
                          analytics.logEvent(name: 'group_member_remove_cancel');
                          Navigator.pop(context, false);
                        },
                        child: Text(L.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          analytics.logEvent(name: 'group_member_remove_confirm');
                          Navigator.pop(context, true);
                        },
                        child: Text(L.delete, style: const TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirmed != true) {
                  return;
                }
                try {
                  await functions.removeGroupMember(groupID: groupID, targetUserID: memberUserID);
                } catch (e) {
                  if (context.mounted) {
                    showErrorAlert(context, e.toString());
                  }
                }
              },
            )
          : null,
    );
  }
}

class _MemberBadge extends StatelessWidget {
  final String text;
  const _MemberBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: TextStyle(fontSize: 12, color: primaryColor)),
    );
  }
}
