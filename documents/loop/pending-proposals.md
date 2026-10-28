# 週次の承認を待つ方向性の文書への変更提案

product-loop skill が積み、weekly-product-report skill の週次レポートでチェックされた提案だけを `documents/DIRECTION.md` に反映する。

- [P-2026-10-28-1] 判定基準の行の追加: 指標「MRR」、計測元 `bash ~/.agents/skills/product-loop/scripts/read-dashboard-metric.sh --repo bannzai/medicalarm --metric mrr --field mrr` の VALUE、継続のしきい値 `>= 5`、打ち切り条件 `< 3 x2`、転換の条件「新規顧客数が保てているのに MRR が 2 回連続で下がっていたら、プレミアム紹介画面・paywall の訴求を改善 issue の最優先にする」 / 背景: 仮説は収益化をプレミアム (RevenueCat) と AdMob に置いているが、判定基準は評価・低評価レビュー・クラッシュの 3 行だけで収益を判定できない。bannzai/dashboard が medicalarm の MRR を日次で集めるようになり API key 無しで読めるため足す。直近 28 日はほぼ横ばいで、しきい値は現状維持なら継続、半減したら打ち切りに置いた
- [P-2026-10-28-2] 判定基準の行の追加: 指標「直近14日の新規顧客数」、計測元 `bash ~/.agents/skills/product-loop/scripts/read-dashboard-metric.sh --repo bannzai/medicalarm --metric new_customers --field new_customers --days 14 --agg sum` の VALUE、継続のしきい値 `>= 30`、打ち切り条件 `< 15 x2`、転換の条件「新規顧客数が継続のしきい値を 2 回連続で下回ったら、獲得 (ASO・オンボーディング) 側の転換を検討する」 / 背景: 既存の転換の条件は獲得の衰えを「新規レビューが 0 件」で代わりに見ているが、レビューは公開版が 202605.02 のまま 1 件しか無く獲得の判定に使えない。dashboard の新規顧客数で獲得を直接見る。直近 14 日はその前の 14 日より大きく増えており、しきい値はその山ではなく増える前の水準に置いた
