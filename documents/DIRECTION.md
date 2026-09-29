---
status: launched          # evaluating | building | launched | pivoting | retiring | retired
decision_date: 2026-10-13 # 次の判定日 (YYYY-MM-DD)。判定のたびに cycle_days 後へ進める
cycle_days: 14            # 判定の周期 (7 または 14)
veto_wait_hours: 12       # 公開後の無人ループの拒否権の待ち時間 (既定 12)
daily_issue_cap: 3        # 1 日に生成してよい改善 issue の上限 (意味の門。既定 3)
launched_at: 2025-03-04   # 公開日 (YYYY-MM-DD)。App Store の初回公開日
---

# 方向性: medicalarm

## 仮説

自分だけでなく子どもなど他人の服薬も管理する人の「薬を飲ませ忘れたかも」という不安を、複数の服用者登録・服用時刻のリマインド・記録忘れのフォローアップ通知・マナーモードでも鳴る Critical Alert で解消する。プレミアム (RevenueCat) と AdMob で収益化する (出典: `README.md` 1〜3 行、`ios/fastlane/metadata/ja/description.txt`、`CLAUDE.md` 3 行目)。

## 判定基準

| 指標 | 計測元 (skill / コマンド) | 継続のしきい値 | 打ち切り条件 | 転換の条件 |
| --- | --- | --- | --- | --- |
| App Store JP 平均評価 | appstore-research skill: `bash ~/.agents/skills/appstore-research/scripts/fetch-app-metadata.sh 6740401642 --country jp` の `averageUserRating` | >= 4.0 | < 3.5 x2 | 評価は保てているが直近 14 日の新規レビューが 2 回連続 0 件なら、獲得 (ASO・オンボーディング) 側の転換を検討する |
| 直近14日の★1〜2レビュー数 | appstore-research skill: `bash ~/.agents/skills/appstore-research/scripts/fetch-reviews.sh 6740401642 --country jp --pages 1` の出力で `date` が直近 14 日かつ `rating` が 2 以下の行数 | <= 1 | >= 3 x2 | 低評価の内容が同じ機能 (通知・記録) に集中していたら、その機能の作り直しを改善 issue の最優先にする |
| 直近14日のFATALクラッシュissue数 | firebase-crashlytics-triage skill: `bash ~/.agents/skills/firebase-crashlytics-triage/scripts/crashlytics.sh top-issues --config ios/Firebase/GoogleService-Info.plist --days 14 --error-types FATAL` の topIssues の行数 | <= 5 | > 30 x2 | 上位 issue のイベント数が 1 件で 100 を超えていたら、機能追加より先にその修正 issue を出す |

## 必要な機能

- [x] 薬の登録と服用スケジュール・頻度の設定
- [x] 服用時刻のリマインド・記録忘れのフォローアップ通知・Critical Alert
- [x] 複数の服用者の登録、グループでの共有と招待、アカウント連携
- [x] 服薬記録・履歴・カレンダー・日記
- [x] 課金転換型のオンボーディングとプレミアム紹介画面、AdMob 広告
- [x] Crashlytics のアラートの Slack 転送 (#medicalarm-notification。PR #356)
- [ ] 画像から服薬する薬の予定を作る (#257。PR #267)
- [ ] デザインのリニューアル (#274)
- [ ] 2026-07-15 以降に main へ入った変更 (オンボーディング等) のリリース (`scripts/release.sh`)

## デザインの方向

既存アプリのため Claude Design のモックは無い。現行の画面を正とする。リニューアル (#274) は着手時にモックを作り、この節を更新する。

## 決めたこと

| 日付 | 場面 | 決めたこと | 決めた人 |
| --- | --- | --- | --- |
| 2026-09-29 | 既存アプリへの後付け | 下書きを agent が作成。bannzai が直すか黙認する。しきい値は 2026-09-29 時点の実測 (平均評価 4.27 / 11 件、直近 14 日の ★1〜2 レビュー 0 件、直近 14 日の FATAL issue 0 件) を基準に「現状維持なら継続、明確に落ちたら打ち切り」で置いた | agent |

## agent に任せること

文書に無い問いはすべて。RevenueCat の課金指標は、`metrics/overview` を読める v2 API key が `.envrc` に入った時に agent が判定基準へ足す。`CLAUDE.md` が参照する `documents/entity-parent-id-rules.md` は main に無い (リンク切れ) ため、agent が直してよい。
