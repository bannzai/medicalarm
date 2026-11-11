---
status: launched          # evaluating | building | launched | pivoting | retiring | retired
decision_date: 2026-11-10 # 次の判定日 (YYYY-MM-DD)。判定のたびに cycle_days 後へ進める
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
| MRR | product-loop skill: `bash ~/.agents/skills/product-loop/scripts/read-dashboard-metric.sh --repo bannzai/medicalarm --metric mrr --field mrr` の VALUE | >= 5 | < 3 x2 | 新規顧客数が保てているのに MRR が 2 回連続で下がっていたら、プレミアム紹介画面・paywall の訴求を改善 issue の最優先にする |
| 直近14日の新規顧客数 | product-loop skill: `bash ~/.agents/skills/product-loop/scripts/read-dashboard-metric.sh --repo bannzai/medicalarm --metric new_customers --field new_customers --days 14 --agg sum` の VALUE | >= 30 | < 15 x2 | 新規顧客数が継続のしきい値を 2 回連続で下回ったら、獲得 (ASO・オンボーディング) 側の転換を検討する |

## 必要な機能

- [x] 薬の登録と服用スケジュール・頻度の設定
- [x] 服用時刻のリマインド・記録忘れのフォローアップ通知・Critical Alert
- [x] 複数の服用者の登録、グループでの共有と招待、アカウント連携
- [x] 服薬記録・履歴・カレンダー・日記
- [x] 課金転換型のオンボーディングとプレミアム紹介画面、AdMob 広告
- [x] Crashlytics のアラートの Slack 転送 (#medicalarm-notification。PR #356)
- [x] 画像から服薬する薬の予定を作る (#257。PR #267 が 2026-10-25 に main へマージ。callable `generateMedicinesFromImage` は prod にデプロイ済み (2026-10-26 に `firebase functions:list --project medicalarm-prod` で `ACTIVE` を確認)。アプリはストア未リリースで、下のリリースの項目に含まれる)
- [ ] デザインのリニューアル (#274)
- [ ] App Store の公開版 (202605.02.205812、2026-05-03。`fetch-app-metadata.sh 6740401642 --country jp` の `version` / `currentVersionReleaseDate` を 2026-11-04 に実測。main の `pubspec.yaml` は PR #502 で 202611.02.162103 になり、2026-11-02 に同名の GitHub Release もあるが、ストアの公開版は変わっていない。審査の状況は未確認) 以降に main へ入った変更 (オンボーディング、起動時のストアレビュー訴求の削除 #294、画像からの薬の登録 #267 等) のリリース (`scripts/release.sh`。作業は #423)。前提: (1) リリース前の QA ゲート。#422 (PR #431、2026-10-26 にクローズ) で QA の記録を QA データベース (tansu) に移した。ゲートを fail にしていた #427 (マナーモードでも通知) は PR #444、#428 (同時刻の通知の上書き) は PR #448 で 2026-10-28 に main へマージ済み。PR #456 (riverpod 3 への移行。#447) は 2026-10-29、PR #468 (英語表示の服用頻度のラベルの折り返し。#466) は 2026-10-30 に main へマージ済み。2026-11-04 時点の main (08a1f522) の `check_qa_gate.sh` は `GATE:fail` で、最後の記録が ng の項目は 2 件: group_list「初回起動時にローディングを経てホームが表示される」(#465・#470 の修正は PR #469 で 2026-10-30 に main へマージ済み。simulator を確保できず画面で確かめられなかった 3 項目 (アカウント削除後の起動の繰り返し・新規インストール時の初回起動・2 回目以降の起動) は「ユーザー作業の一覧」#281 に移り、2026-11-01 の `check_qa_gate.sh` では later のまま)、medications「チェック解除で取消の記録」(#467 で項目の期待値を #253 後の動作に書き換え済みで、記録のやり直し待ち)。medicine_form の ng は無くなったが、項目の検証は古くなっている (`STALE_ITEMS:16`)。#456 はアプリ全体の provider を変えたため、全項目の QA は上の修正のマージ後の main で記録し直す。(2) #340 の実機・Sandbox での確認 5 件 (購入と復元・プレミアム会員の表示・年額プランの購入ダイアログ・アカウント引き継ぎ・本番ビルドの App Check) は bannzai の作業。次の E2E の項目は済んだ
- [x] nightly E2E (`CI E2E (Flutter iOS)`) が main で通る状態 (#383 → PR #386 で iOS ビルドを直し、main の schedule の run が 2026-10-14 に success: https://github.com/bannzai/medicalarm/actions/runs/38617042800 。間欠的な失敗は #387。2026-10-27・10-28 の main の nightly は 2 回続けて `qa_verify_calendar` の `"日記" is visible` で失敗した。2026-10-29 も failure で、#456 のマージ後の 2026-10-30 の run https://github.com/bannzai/medicalarm/actions/runs/41106994226 も同じ step で失敗したため、2026-10-31 に #387 を無人実装に出した。原因 (月末に前月のグレーアウトの日付をタップする) の修正は PR #477 で 2026-10-31 に main へマージ済みで、マージ後の main (62221274) の nightly https://github.com/bannzai/medicalarm/actions/runs/41229446088 (2026-10-31 18:26Z) は success。PR #477 の作業ブランチの E2E で 1 回落ちた `toggle_switch` の取りこぼしは #480。2026-11-01 18:26Z の nightly https://github.com/bannzai/medicalarm/actions/runs/41336636939 は、1 回目が `onboarding_medication_plan_delete` (`"08:00"` が見えないことの確認の途中で XCTest が `Timed out while fetching snapshot from testmanagerd` を出し、失敗時のスクリーンショットでは 08:00 の仮カードは消えていた) で、失敗した job の再実行 (2 回目) はそのフローが通り `qa_verify_switch_snackbar` (`"お薬一覧" is visible`) で、それぞれ 9 フロー中 1 件だけ失敗した)

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
| 2026-10-26 | 無人ループ | QA の記録先を `QA.md` (ルートと `lib/features/*/QA.md`) から QA データベース (tansu) に移す (#422)。release-app skill の `check_qa_gate.sh` が tansu の記録で判定するため。項目は `QA.md` を正データにして setup-qa skill の `register_qa.sh` で登録し、以後の QA は run-qa skill で tansu に記録する。`QA.md` ファイルの削除は可逆な方を選んでこの時点では行わず、tansu での運用が 1 回回ってから別 issue で判断する | agent |
| 2026-10-27 | 判定日 | 継続。3 指標とも継続のしきい値を満たした (平均評価 4.27 / 11 件、直近 14 日の ★1〜2 レビュー 0 件、直近 14 日の FATAL issue 0 件。`documents/loop/metrics-2026-10-27.json`)。FATAL の指標は nodenv の node (`~/.anyenv/envs/nodenv/shims`) を PATH に通した `crashlytics.sh top-issues` で取れた。転換の条件「直近 14 日の新規レビューが 2 回連続 0 件」は、公開版が 202605.02 のまま未リリースのため、2026-10-13 の行のとおり今回も数えない。次の判定日は 2026-11-10 | agent |
| 2026-10-27 | 無人ループ | #422 の QA で見つかった #427〜#430 は、新しい issue を作らずにそのまま使う。#427 と #430 は同じ `notification_setting/section.dart` を変えるため 1 つにまとめ、#428 とともに無人実装に出す。#427 はリリース前ゲートの NG の項目で、#428 は同時刻の通知を取りこぼす不具合。#429 は issue 自身が「今日これ 1 件しか出せないとしても出すか」を「出さない」としているため、後に回す | agent |
| 2026-10-28 | 無人ループ | 判定基準に足す課金・獲得の指標は、dashboard の medicalarm で値が取れる MRR と直近 14 日の新規顧客数の 2 つにし、週次の承認に回した (`documents/loop/pending-proposals.md`)。D7 リテンション・paywall のファネル・DAU は dashboard に medicalarm の系列が無い (`read-dashboard-metric.sh` が `STATUS=missing`) ため提案しない | agent |
| 2026-10-30 | 無人ループ | #387 (nightly E2E の `qa_verify_calendar` の失敗) の無人実装は、open の PR #456 (riverpod 3 への移行) のマージ後に回す。2026-10-27・10-28 に 2 回続けて再発したが、#456 は失敗しているカレンダー画面を含むアプリ全体の provider の読み方を変えるため、今の main で原因を調べると #456 のマージで前提が変わる。#456 のマージ後の nightly でも失敗が続けば、その run を根拠に #387 を無人実装に出す | agent |
| 2026-10-31 | 無人ループ | 2026-10-30 の行の条件を満たした (#456 のマージ後の 2026-10-30 の nightly も `qa_verify_calendar` の `"日記" is visible` で失敗) ため、#387 を `tmux-issue-setup -a` で無人実装に出した。PR #406 (マージ済み) の worktree `issue-387` が残っていて着手中の判定に当たったため、削除せず `issue-387-pr406-merged` へ移し、ローカルのブランチ名も同じ名前に変えてから起動した (新しい実装が origin/main から始まるようにするため) | agent |
| 2026-11-02 | 無人ループ | CI の `analyze` が、`ignore_for_file: provider_dependencies` を持つ `test/provider/onboarding_medication_plan_test.dart` の `provider_dependencies` 警告で 1 回落ちた (PR #485 の run https://github.com/bannzai/medicalarm/actions/runs/41242844441 の 1 回目)。同じ main の内容で前後の run は成功し、失敗した job の再実行も成功したため、間欠的な失敗として再実行で通し、PR #485 をマージした。観測は 1 回だけのため issue にしない。同じ警告で `analyze` がもう一度落ちたら、その run を根拠に issue を作って無人実装に出す | agent |
| 2026-11-02 | 無人ループ | 2026-11-01 の nightly の失敗 (1 回目と再実行で落ちたフローが違う) は新しい issue にせず、既存の open の issue で扱う。`onboarding_medication_plan_delete` の間欠的な失敗は #387 で扱う。`qa_verify_switch_snackbar` の「お薬一覧」が見えない失敗は `full_pause_feature.yaml` の画面遷移の準備中に起きており、スイッチ操作後の SnackBar の取りこぼしを扱う #480 とは別に記録 issue #372 で追跡する。同じ準備 step の失敗が再発したら run と artifact を根拠に原因調査の issue を作る。#480 は PR #500 で 2026-11-02 にクローズ済みで、この準備 step の失敗の修正には当たらない | agent |
| 2026-11-04 | 無人ループ | リリース前の全項目の QA の記録し直しは、今は issue にしない。作業中の #495 (76 言語の arb)、PR #505 (snapshot testing)、未着手の #506 (薬の登録フォーム) が入ると root と medicine_form の検証がまた古くなり、#340 の実機確認も残っていてリリースに進めないため。#495・#505・#506 が閉じた後の実行で、`check_qa_gate.sh` の結果を根拠に issue を作る | agent |
| 2026-11-04 | 無人ループ | 2026-11-03 の nightly E2E (https://github.com/bannzai/medicalarm/actions/runs/41693915757 ) の失敗は issue にしない。フローを 1 つも実行する前に Maestro が `iOS driver not ready in time, consider increasing timeout by configuring MAESTRO_DRIVER_STARTUP_TIMEOUT env variable` で終了しており、アプリの変更が原因の失敗ではない。Simulator の起動 (`simctl bootstatus`) は 6 分 32 秒で、成功した 2026-11-02 の run の 5 分 22 秒と大きくは違わない。この失敗は 1 回しか観測しておらず、同じ文言の issue も無い。同じ文言でもう一度落ちたら、その run を根拠に `ci-e2e.yml` へ `MAESTRO_DRIVER_STARTUP_TIMEOUT` を足す issue を作る | agent |
| 2026-11-05 | 無人ループ | 2026-11-02 の行の条件 (同じ `provider_dependencies` の警告で `analyze` がもう一度落ちる) を満たした。PR #512 の CI で同じ警告 (`test/provider/onboarding_medication_plan_test.dart:43:1`) で 2 回落ち、同じ commit の再実行でも落ちた。別のセッションが原因の確定を完了条件にした #513 を起票済みのため新しい issue は作らず、#513 を無人実装に出す。`tmux-issue-setup -a 513` は medicalarm セッションの同時実行数の上限 (agent 4 個、上限 3) で exit 75 になったため、`auto-implement` label を付けて watcher の待ち行列に入れた | agent |
| 2026-11-05 | 無人ループ | #516 (新品の初回起動でスピナーのまま進まない) は単独で無人実装に出さない。原因の第一候補が open の PR #515 (#514 の修正) が初回起動の経路に足したタイムアウトの無いサーバー読み取り (`lib/provider/app_user.dart`・`lib/provider/user_groups.dart`。#516 の本文とコメントによる。ループでは再現を確かめていない) で、#515 と変更領域が重なり、#515 の作業中の window `issue-514` が起票して追跡しているため。#515 のマージ後も #516 が open のまま残っていたら、その時の実行で起動を判断する | agent |
| 2026-11-06 | 無人ループ | 週次レポート (https://github.com/bannzai/inbox/issues/84 ) で承認された 2 件の提案 (P-2026-10-28-1・P-2026-10-28-2) に従い、判定基準に「MRR」と「直近14日の新規顧客数」の行を足した。次の判定日 (2026-11-10) から 5 行で判定する | agent |
| 2026-11-06 | 無人ループ | 2026-11-04 の行の条件 (#495・PR #505・#506 が閉じる) を満たしたが、リリース前の全項目の QA を記録し直す issue は作らない。owner の指示で始まったリリース作業 #527 が QA の関門 (`check_qa_gate.sh`) を前提に含めていて、#527 のコメントによると関門の QA は司令塔が指定した別のセッションが #516 のマージ後に記録するため。#516 は PR #526 (初回起動の各段階を DEBUG ビルドで表示する) で作業中のため、このループからは起動しない | agent |
| 2026-11-06 | #529 の作業中 | 「画像から登録」で OpenAI に画像を送る前の許可 (#548。App Store Review Guidelines 5.1.2 (i) の第三者の AI への送信の明示的な許可) は、送るたびに確認のダイアログを出し、許可を端末に記憶しない方にした。記憶すると許可の取り消しの導線が要り変更範囲が広がるためで、記憶する方へは後から変えられる | agent |
| 2026-11-11 | #543 の作業中 | 文字サイズを大きくした時に横幅に収まらない文字の扱い。ホーム画面の下のタブの文字は倍率の上限を 1.0 にする (文字の倍率 3.0・幅 402 の widget test で、タブの文字に使える幅 68.5 に対し「カレンダー」は 180 必要。倍率 1.0 の 60 なら収まる。Flutter の `BottomNavigationBar` も `MediaQuery.withClampedTextScaling(maxScaleFactor: 1.0)` で同じ扱い)。週カレンダーの日付・曜日は高さを文字に合わせて伸ばし、セルの幅に収まらない時だけ `FittedBox(scaleDown)` で縮める (日付は利用者が読む内容のため大きいまま見せる)。どちらも既定の文字サイズの見た目は変わらず、外せば戻せる | agent |

## agent に任せること

文書に無い問いはすべて。課金・獲得の指標は、bannzai/dashboard が日次で集める MRR・新規顧客数を `read-dashboard-metric.sh` (product-loop skill) で API key 無しに読める。判定基準への行の追加は `documents/loop/pending-proposals.md` に積み、週次レポートで承認されたものだけを agent が足す。`CLAUDE.md` が参照する `documents/entity-parent-id-rules.md` は main に無い (リンク切れ) ため、agent が直してよい。
