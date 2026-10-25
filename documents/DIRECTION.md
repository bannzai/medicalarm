---
status: launched          # evaluating | building | launched | pivoting | retiring | retired
decision_date: 2026-10-27 # 次の判定日 (YYYY-MM-DD)。判定のたびに cycle_days 後へ進める
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
- [x] 画像から服薬する薬の予定を作る (#257。PR #267 が 2026-10-25 に main へマージ。callable `generateMedicinesFromImage` は prod にデプロイ済み (2026-10-26 に `firebase functions:list --project medicalarm-prod` で `ACTIVE` を確認)。アプリはストア未リリースで、下のリリースの項目に含まれる)
- [ ] デザインのリニューアル (#274)
- [ ] App Store の公開版 (202605.02.205812、2026-05-03。`fetch-app-metadata.sh 6740401642 --country jp` の `version` / `currentVersionReleaseDate` を 2026-10-11 に実測。main の `pubspec.yaml` は 202607.15 でタグもあるがストアには出ていない) 以降に main へ入った変更 (オンボーディング、起動時のストアレビュー訴求の削除 #294、画像からの薬の登録 #267 等) のリリース (`scripts/release.sh`。作業は #423)。前提: (1) リリース前の QA ゲート。2026-10-17 の `GATE:pass` (`f14b9388`) は、その後の #267 などアプリのコードを変える PR のマージで main の HEAD に当てはまらなくなり、`check_qa_gate.sh` が QA データベース (tansu) の記録で判定するため、tansu への登録と run-qa の全項目の実行を #422 で行っている。(2) #340 の実機・Sandbox での確認 5 件 (購入と復元・プレミアム会員の表示・年額プランの購入ダイアログ・アカウント引き継ぎ・本番ビルドの App Check) は bannzai の作業。次の E2E の項目は済んだ
- [x] nightly E2E (`CI E2E (Flutter iOS)`) が main で通る状態 (#383 → PR #386 で iOS ビルドを直し、main の schedule の run が 2026-10-14 に success: https://github.com/bannzai/medicalarm/actions/runs/38617042800 。間欠的な失敗は #387)

## デザインの方向

既存アプリのため Claude Design のモックは無い。現行の画面を正とする。リニューアル (#274) は着手時にモックを作り、この節を更新する。

## 決めたこと

| 日付 | 場面 | 決めたこと | 決めた人 |
| --- | --- | --- | --- |
| 2026-09-29 | 既存アプリへの後付け | 下書きを agent が作成。bannzai が直すか黙認する。しきい値は 2026-09-29 時点の実測 (平均評価 4.27 / 11 件、直近 14 日の ★1〜2 レビュー 0 件、直近 14 日の FATAL issue 0 件) を基準に「現状維持なら継続、明確に落ちたら打ち切り」で置いた | agent |
| 2026-10-11 | 無人ループ | App Store の唯一の直近レビュー (2026-08-03、★5、「ことあるごとにレビューしろと出てくる」) は公開中の 202605.02 に残る起動時のストアレビュー訴求 (`in_app_review`。#294 で削除済み、未リリース) への不満と読む。レビュー訴求の追加の変更 (プロモーション画面 `PromotionStartPage` の表示頻度) は issue にせず、#294 を含むリリース後に新しいレビューで再評価する | agent |
| 2026-10-11 | 無人ループ | リリース (release-app skill) は見送る。理由: QA.md の記録が 2026-07-16 で止まり `check_qa_gate.sh` が fail、nightly E2E が初回から全失敗で回帰を検知できない。E2E の修復 (#373) を先に出し、通ってから QA → リリースに進む | agent |
| 2026-10-11 | 無人ループ | 判定基準「直近14日の★1〜2レビュー数」の計測元 `fetch-reviews.sh` がレビュー 1 件の feed で 0 件を返す不具合を見つけ、castle 側で修正した (https://github.com/bannzai/castle/pull/1609 )。修正後のスクリプトで feed 全体のレビューは 1 件 (★5、2026-08-03) で、判定基準の値「直近 14 日の ★1〜2 レビュー数」は 0 件 | agent |
| 2026-10-13 | 判定日 | 継続。3 指標とも継続のしきい値を満たす (平均評価 4.27 / 11 件、直近 14 日の ★1〜2 レビュー 0 件、直近 14 日の FATAL issue 0 件。`documents/loop/metrics-2026-10-13.json`)。転換の条件「直近 14 日の新規レビューが 2 回連続 0 件」は、新規レビューが無い状態が公開版 202605.02 のまま続いているため今回は数えず (未リリースの改善が届いていない状態での獲得側の転換は早い)、リリース後の判定日から数える。次の判定日は 2026-10-27 | agent |
| 2026-10-14 | 無人ループ | 判定日の文書の変更 (判定の行・判定日の前進・指標の記録) と日次の分析の変更 (必要な機能の E2E の項目) を、同じファイルへの PR を 2 本重ねて競合させないため 1 本の PR `product-loop/2026-10-13` にまとめた | agent |
| 2026-10-15 | 無人ループ | リリース前の QA (#393) は現在の main を対象にし、open の #392 (google_mobile_ads・sign_in_with_apple の SwiftPM 対応版への更新) のマージを待たない。#386 で CI の iOS ビルドは直っており、#392 はストアのビルドの前提ではない。#392 が後でマージされて QA のゲートが再び fail になったら、次のリリースの前に差分の QA をし直す | agent |
| 2026-10-15 | 無人ループ | 判定基準「直近14日のFATALクラッシュissue数」は、このマシンの firebase CLI に認証済みアカウントが無く (`firebase login:list` が `No authorized accounts`) 取得できなかったため UNMEASURED とした。`firebase login` は対話認証で bannzai にしかできない。判定日 (2026-10-27) までに戻らなければ、その指標を除いて判定する | agent |
| 2026-10-16 | 無人ループ | QA で 1 回だけ観測した「メンバーの再参加がオーナーの画面に反映されない」(#404) の ❌ は、#404 を閉じるかの判断と切り離して扱う。無人実装の調査 (ローカルの Simulator 2 台で 5 回) で再現せず、アプリ側の原因が見つかっていないため、リリース前の差分の QA で同じ QA 項目を simtunnel で実行し直し、再現しなければ ✅ に書き換えて未再現の回数を #404 に記録する。再現したら ❌ のままにしてリリースを止める | agent |
| 2026-10-17 | 無人ループ | 判定基準「直近14日のFATALクラッシュissue数」の取得の失敗の原因が変わった。`crashlytics.sh top-issues` は ADC (`ai-agent@bannzai.iam.gserviceaccount.com`) で認証が通り、quota project 339671052451 (medicalarm-prod) で Firebase Crashlytics API が無効のため HTTP 403 `SERVICE_DISABLED` で失敗した。スクリプトが示す対処 `gcloud services enable firebasecrashlytics.googleapis.com --project medicalarm-prod` は、同スクリプトが「確認を取ってから実行する」としており、確認の経路が無い無人ループでは実行しない。bannzai の作業として「ユーザー作業の一覧」#281 に記録し、2026-10-15 の行のとおり判定日 (2026-10-27) までに戻らなければこの指標を除いて判定する | agent |

## agent に任せること

文書に無い問いはすべて。RevenueCat の課金指標は、`metrics/overview` を読める v2 API key が `.envrc` に入った時に agent が判定基準へ足す。`CLAUDE.md` が参照する `documents/entity-parent-id-rules.md` は main に無い (リンク切れ) ため、agent が直してよい。
