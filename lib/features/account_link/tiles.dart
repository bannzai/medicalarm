import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/button/user_delete.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/auth/account_link.dart';
import 'package:medicalarm/utils/push_notification/fcm_notification.dart';

/// Apple / Google のアカウント引き継ぎ(リンク)行をまとめて表示する。
///
/// 設定画面の「アカウント引き継ぎ」セクションと、ホームバナーから開くシートの両方で共用する。
/// リンク済み判定は firebase_auth の userChanges を購読する [isAppleLinkedProvider] / [isGoogleLinkedProvider]
/// を参照するため、リンク完了後に自動で表示が更新される。
class AccountLinkTiles extends ConsumerWidget {
  const AccountLinkTiles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _AccountLinkTile(
          isLinked: ref.watch(isAppleLinkedProvider),
          linkedLabel: L.accountLinkedWithApple,
          linkLabel: L.linkWithApple,
          onLink: () {
            analytics.logEvent(name: 'account_link_apple_tapped');
            return ref.read(appleAccountLinkProvider).call();
          },
        ),
        _AccountLinkTile(
          isLinked: ref.watch(isGoogleLinkedProvider),
          linkedLabel: L.accountLinkedWithGoogle,
          linkLabel: L.linkWithGoogle,
          onLink: () {
            analytics.logEvent(name: 'account_link_google_tapped');
            return ref.read(googleAccountLinkProvider).call();
          },
        ),
      ],
    );
  }
}

class _AccountLinkTile extends HookWidget {
  final bool isLinked;
  final String linkedLabel;
  final String linkLabel;

  /// Apple / Google どちらのリンク処理を実行するかを親から渡す。状態共有ではなくアクションの委譲のためコールバックを用いる。
  /// リンクした場合は true、ユーザーがキャンセルした場合は false を返す。
  final Future<bool> Function() onLink;

  const _AccountLinkTile({
    required this.isLinked,
    required this.linkedLabel,
    required this.linkLabel,
    required this.onLink,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);

    if (isLinked) {
      return ListTile(
        title: Text(linkedLabel, style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      );
    }

    return ListTile(
      title: Text(linkLabel, style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
      trailing:
          isLoading.value ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.chevron_right),
      onTap: isLoading.value
          ? null
          : () async {
              isLoading.value = true;
              try {
                if (await onLink()) {
                  scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(content: Text(L.accountLinkedSnackbar)));
                }
              } catch (e) {
                if (context.mounted) {
                  showErrorAlert(context, e.toString());
                }
              } finally {
                isLoading.value = false;
              }
            },
    );
  }
}
