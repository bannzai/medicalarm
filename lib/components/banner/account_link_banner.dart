import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/button/user_delete.dart';
import 'package:medicalarm/features/account_link/sheet.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/user_groups.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

/// グループ共有中(いずれかのグループの memberUserIDs が 2 人以上)かつ未リンク(Apple / Google のいずれも未連携)のとき、
/// ホーム上部にアカウント引き継ぎを強く推奨するバナーを表示する。
///
/// 匿名認証のままアプリを削除・機種変更するとデータを失うため、共有相手に迷惑がかかる。閉じるボタンは付けず常時表示する。
class AccountLinkBanner extends ConsumerWidget {
  const AccountLinkBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShared = ref.watch(userGroupsProvider).valueOrNull?.any((group) => group.memberUserIDs.length > 1) ?? false;
    final isLinked = ref.watch(isAppleLinkedProvider) || ref.watch(isGoogleLinkedProvider);
    if (!isShared || isLinked) {
      return const SizedBox.shrink();
    }

    final primaryColor = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: () {
        analytics.logEvent(name: 'account_link_banner_tapped');
        showAccountLinkSheet(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: primaryColor.withValues(alpha: 0.8),
        child: Row(
          children: [
            const Icon(Icons.link, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                L.accountLinkBannerText,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
