import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/components/loading/loading.dart';
import 'package:medicalarm/features/group/group_icon.dart';
import 'package:medicalarm/features/group/invitation_code_dialog.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/group_create.dart';
import 'package:medicalarm/provider/group_invitation.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/theme/form.dart';

/// グループを新規作成する画面。名前とアイコンを入力し、作成後に招待コードを発行して表示する。
///
/// 作成したグループは表示中グループ([currentGroupIDProvider])として切り替える。
class GroupCreatePage extends HookConsumerWidget {
  const GroupCreatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final name = useState('');
    final iconName = useState('home');
    final isLoading = useState(false);
    // createGroup は非冪等のため、成功後に招待発行が失敗した際の再試行で重複作成しないよう作成済み groupID を保持する。
    final createdGroupID = useState<String?>(null);
    final createGroup = ref.watch(createGroupProvider);
    final createGroupInvitation = ref.watch(createGroupInvitationProvider);
    final canSubmit = name.value.trim().isNotEmpty;

    Future<void> submit() async {
      if (isLoading.value) {
        return;
      }
      isLoading.value = true;
      try {
        // 作成しても表示中グループは切り替えない(shoppinglist 踏襲)。切替はグループ切替チップの責務。
        // 既に作成済み(招待発行だけ失敗して再試行)なら createGroup をスキップし、招待発行のみ再実行する。
        final groupID = createdGroupID.value ?? await createGroup.call(name: name.value.trim(), setAsDefault: false, iconName: iconName.value);
        createdGroupID.value = groupID;
        final invitation = await createGroupInvitation.call(groupID: groupID);
        if (context.mounted) {
          await showInvitationCodeDialog(context, invitationCode: invitation.invitationCode, expiresDateTime: invitation.expiresDateTime);
        }
        if (context.mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          showErrorAlert(context, e.toString());
        }
      } finally {
        isLoading.value = false;
      }
    }

    return DraggableScrollableSheet(
      initialChildSize: 1.0,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: FormTheme(
            child: Scaffold(
              appBar: AppBar(
                title: Text(L.createGroup, style: TextStyle(color: primaryColor)),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(L.groupName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextFormField(
                        autofocus: true,
                        decoration: InputDecoration(hintText: L.groupNameInputHint),
                        onChanged: (value) {
                          name.value = value;
                        },
                      ),
                      const SizedBox(height: 24),
                      Text(L.groupIcon, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          for (final selectableIconName in selectableGroupIconNames)
                            _GroupIconOption(
                              iconName: selectableIconName,
                              isSelected: iconName.value == selectableIconName,
                              onTap: () {
                                iconName.value = selectableIconName;
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: canSubmit ? submit : null,
                        child: Loading(
                          isLoading: isLoading.value,
                          child: Text(L.createGroup),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GroupIconOption extends StatelessWidget {
  final String iconName;
  final bool isSelected;
  final VoidCallback onTap;

  const _GroupIconOption({
    required this.iconName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? primaryColor : AppColors.border, width: isSelected ? 2 : 1),
        ),
        child: Icon(groupIconData(iconName), color: isSelected ? primaryColor : TextColor.gray, size: 32),
      ),
    );
  }
}

void showGroupCreateForm(BuildContext context) {
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const GroupCreatePage(),
  );
}
