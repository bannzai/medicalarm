import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/components/loading/loading.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/current_group_id.dart';
import 'package:medicalarm/provider/group_invitation.dart';
import 'package:medicalarm/theme/form.dart';
import 'package:medicalarm/utils/invitation_code_validator.dart';

/// 招待コードを入力してグループに参加する画面。
///
/// 8 文字のコードを入力し、[acceptGroupInvitationProvider] で参加した上で、
/// 参加先を表示中グループ([currentGroupIDProvider])に切り替えて閉じる。
class GroupInvitationPage extends HookConsumerWidget {
  const GroupInvitationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final invitationCode = useState('');
    final isLoading = useState(false);
    final acceptGroupInvitation = ref.watch(acceptGroupInvitationProvider);
    final canSubmit = isValidInvitationCode(invitationCode.value);

    Future<void> submit() async {
      if (isLoading.value) {
        return;
      }
      isLoading.value = true;
      try {
        final groupID = await acceptGroupInvitation.call(invitationCode: invitationCode.value);
        ref.read(currentGroupIDProvider.notifier).update(groupID);
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
      initialChildSize: 0.8,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: FormTheme(
            child: Scaffold(
              appBar: AppBar(
                title: Text(L.joinGroup, style: TextStyle(color: primaryColor)),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(L.invitationCodeInputLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextFormField(
                        autofocus: true,
                        maxLength: 8,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [_UpperCaseTextInputFormatter()],
                        decoration: InputDecoration(hintText: L.invitationCodeInputHint, counterText: ''),
                        onChanged: (value) {
                          invitationCode.value = value;
                        },
                        onFieldSubmitted: (_) {
                          if (canSubmit) {
                            submit();
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: canSubmit ? submit : null,
                        child: Loading(
                          isLoading: isLoading.value,
                          child: Text(L.join),
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

/// 入力文字を大文字化する。招待コードは大文字英数字（`ABCDEFGHJKMNPQRSTVWXY3456789`）のため。
class _UpperCaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

void showGroupInvitationForm(BuildContext context) {
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const GroupInvitationPage(),
  );
}
