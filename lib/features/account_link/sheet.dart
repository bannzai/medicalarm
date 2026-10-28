import 'package:flutter/material.dart';
import 'package:medicalarm/features/account_link/tiles.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/style/color.dart';

/// アカウント引き継ぎ(Apple / Google リンク)の選択シートを表示する。
///
/// ホームの [AccountLinkBanner] のタップから開く。設定画面の「アカウント引き継ぎ」セクションと同じ [AccountLinkTiles] を共用する。
void showAccountLinkSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (context) => const _AccountLinkSheet(),
  );
}

class _AccountLinkSheet extends StatelessWidget {
  const _AccountLinkSheet();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(L.accountLink, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(L.accountLinkDescription, style: const TextStyle(fontSize: 14, color: TextColor.gray)),
            ),
            const SizedBox(height: 16),
            const AccountLinkTiles(),
          ],
        ),
      ),
    );
  }
}
