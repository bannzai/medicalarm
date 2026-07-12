import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/components/button/buttons.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/style/color.dart';

/// 発行済みの招待コードと有効期限を表示し、クリップボードへコピーできるダイアログ。
///
/// グループ作成直後([group_create])とグループ設定画面([group_setting])の
/// 招待コード発行から共通で呼び出す。
Future<void> showInvitationCodeDialog(
  BuildContext context, {
  required String invitationCode,
  required DateTime expiresDateTime,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(L.invitationCode),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(L.invitationCodeShareDescription, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            Center(
              child: SelectableText(
                invitationCode,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 4),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              L.invitationCodeExpiresAt(DateFormat('yyyy/MM/dd HH:mm').format(expiresDateTime)),
              style: const TextStyle(fontSize: 12, color: TextColor.gray),
            ),
          ],
        ),
        actions: [
          AlertButton(
            text: L.copyInvitationCode,
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: invitationCode));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(L.invitationCodeCopied)),
                );
              }
            },
          ),
          AlertButton(
            text: L.close,
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
