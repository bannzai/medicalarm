---
feature: _root
verification: mobile-mcp
last_verified_commit: ebcfd81fb3b432696218ceb32ea3df0434611c3b
last_verified_at: 2026-10-16
---

# QA 全体ガイド

## App Check の検証範囲（2026-10-15 更新）

2026-10-15 に main の HEAD と同じアプリのコードのデバッグビルド (simtunnel の iOS Simulator) で、起動・Firestore の読み書き・Cloud Functions の呼び出し (グループ作成・招待コード発行・招待コードでの参加) が動くことを確認した。
本番ビルドの App Attest によるトークン取得と App Check のメトリクスは、配布ビルドと実機が要るため未検証 (#340 の実機確認に含む)。

## 対象環境

- Firebase project: `medicalarm-prod`（firebase/.firebaserc の default。dev 環境はなく、QA も prod に対して行う）
- 認証は匿名認証。AuthResolver は FirebaseAuth に currentUser が無い時のみ `signInAnonymously` を呼ぶため、再起動しても同じ匿名ユーザーが維持される。iOS は Firebase Auth の認証情報を Keychain に保持するため、アプリ削除 → 再インストールでも同じ匿名ユーザーが復元される（2026-07-15 に再インストール後も既存データが表示されることを実機確認済み）。新規の匿名ユーザーから始めたい場合は `xcrun simctl shutdown <UDID>` 後に `xcrun simctl erase <UDID>` でシミュレータごと初期化する（UDID は sim-boot / sim-list の出力で確認できる）。QA データは QA 用シミュレータの匿名ユーザー配下に閉じ、既存ユーザーのデータには触れないこと
- iOS アプリ（Bundle ID: `com.bannzai.medicalarm`）。QA は iOS Simulator 上で行う

## 起動方法

初回のみシークレット生成が必要:

```bash
make secret  # 環境変数 FILE_FIREBASE_IOS / REVENUE_CAT_PUBLIC_API_KEY が必要 (値の出どころは 1Password 等、リポジトリには置かない)
```

- `ios/Firebase/GoogleService-Info.plist` と `lib/secret/secret.dart` が生成される
- シミュレータ起動は /sim-manager（sim-boot）を使い、`flutter run -d <simulator>` で起動する
- git worktree 上で pod install / iOS ビルドが落ちる場合は `flutter-pod-warmup` を実行してから `flutter run` する

## ログイン方法

ログイン操作は不要。アプリ起動時に firebase_auth の匿名認証が自動で走る（lib/features/resolver/auth.dart）。テストアカウントの認証情報は存在しない。

## 動作確認手段

- /ios-simulator: iOS Simulator を扱う際の起点。シミュレータ管理は /sim-manager 前提
- /verify-ui-mobile-mcp: mobile-mcp による画面探索・タップ・スクリーンショット撮影
- /maestro-flutter: 既存 E2E フローの実行（`maestro test maestro/flows/`。実行順は `maestro/flows/config.yaml` の `executionOrder` で固定。`helpers/` 配下は単独実行の対象外）
  - `helpers/allow_notification.yaml`: 起動直後の OS ダイアログ（通知許可・ATT）とプロモーション画面（表示されている場合のみ）を閉じ、新規ユーザーの初回起動で出るオンボーディング（「はじめる」が見えた場合のみ）を `onboarding.yaml` で完走する helper。他フローの先頭から `runFlow` で呼ばれる
  - `helpers/onboarding.yaml`: 初回起動のオンボーディング（JP 短尺）を完走し、ペイウォールを閉じて服薬画面に到達する。表示条件と項目は lib/features/onboarding/QA.md
  - `onboarding_medication_plan.yaml` / `onboarding_medication_plan_delete.yaml`: 先頭で `launchApp` の `clearState: true` と `clearKeychain: true` により新規の匿名ユーザーを作ってから始める（Firebase Auth の匿名ユーザーは Keychain に保持されるため、Keychain を消すと次の起動で AppUser が新規作成されオンボーディングが出る）
  - `register_and_pause.yaml` / `full_pause_feature.yaml` / `toggle_switch.yaml` / `resume_and_edit.yaml` / `form_pause.yaml`: 薬の登録〜一時停止・再開の一連
- ユニットテスト: `flutter test` / 静的解析: `flutter analyze`

### 再現が難しい操作の手順

- 起動直後は通知許可 → ATT → プロモーション（★5 レビュー訴求。アカウント作成から1日超経過など PromotionStartResolver の条件成立時のみ）→ AdMob validator 警告（開発ビルド）の順不同でダイアログが重なる。新規の匿名ユーザー（シミュレータ初期化後の初回起動）ではこれらに加えてオンボーディング（OnboardingResolver。作成から1日以内・完了記録なし・非プレミアムで表示）がホーム画面の前に出る。mobile-mcp で手動確認する場合も、まず `maestro test maestro/flows/helpers/allow_notification.yaml` で突破してから操作を始めるのが確実
- `flutter build ios --simulator` + `xcrun simctl install/launch` でアプリを起動すると、`lib/main.dart` の `setupRemoteConfig()`（`fetchAndActivate()` の `fetchTimeout` が1分）が同期待ちのため、シミュレータのネットワーク到達性によっては最大60秒程度 LaunchImage（白画面）のまま初回フレームが描画されない。`mobile_list_elements_on_screen` で `LaunchImage` が居座っていないかを確認し、白画面でも即座に失敗と判断しない
  - 2026-09-03 の QA では、erase 直後のシミュレータへの初回起動で白画面が3〜4分続いた（`log show --predicate 'process == "Runner"'` を見ると Firebase Analytics の起動自体が launch から67秒後、resolver の解決完了はさらに後）。60秒で見切らず、`xcrun simctl launch` 後は最低でも200秒待ってからスクリーンショットで判断する。プロセスの生存は `xcrun simctl spawn <UDID> launchctl list | grep medicalarm` で確認できる（`xcrun simctl terminate` が `found nothing to terminate` を返す場合はアプリが落ちている）
- mobile-mcp（`mcp__mobile__*`）は WebDriverAgent を XCUITest として起動する（maestro のログに `Running tests...` が出る）ため、対象アプリがバックグラウンドに落ちる。その状態では `mobile_list_elements_on_screen` がアプリではなく Springboard のアイコン一覧を返し、`flutter run` の debug connection も `The OS has terminated the Flutter debug connection for being inactive in the background for too long.` で切れる。このプロジェクトの画面操作は maestro（`maestro test --udid <UDID> <flow>`）で行う。テキストラベルの無いアイコンボタンは `tapOn: point: "7%,10%"` のように割合座標で指定できる
- maestro の `takeScreenshot` は tap 後の settle 待ちを挟むため、数秒で自動遷移する演出画面（オンボーディングのプラン生成演出など）は撮り逃す。別シェルで `xcrun simctl io <UDID> screenshot` を連続実行するループを回した状態で maestro の tap flow を走らせ、後からフレームを選ぶ
- 複数行に折り返される Text ウィジェット（`\n` を含む l10n 文言。例: 「薬を飲み忘れたことは\nありますか」）は、maestro の `assertVisible` / `extendedWaitUntil` で画面表示どおりの1行の文字列として一致しない。選択肢のボタンラベルなど単一行の文言で判定する
- 非対話実行でも `flutter run -d <UDID>` はプロセスが常駐し続けるため、`run_in_background: true` で起動し、ログファイルを `grep` でポーリングして起動完了（`Flutter run key commands.` の出力）を待つ必要がある（フォアグラウンドで実行すると turn がブロックされたまま完了しない）
- AdMob native ad validator の警告（開発ビルドのみ表示）は `overlayWebView` 内の要素で `mobile_list_elements_on_screen` にテキストとして現れず、`Dismiss` ボタン座標の目視推定タップが当たりにくい。無理に閉じようとせず、下部タブバー操作は overlay の下でも独立して機能するためそのまま操作を継続してよい
  - この overlay は画面座標 x:0-335 y:355-510 に固定表示され、この範囲に重なるチェックボックス・ボタン等へのタップを奪う（`mobile_list_elements_on_screen` にはアクセシビリティ要素として現れるが、実タップは overlay 側が受け取る）。回避策: (1) 対象要素がこの範囲外（y>510）に来るよう事前に他のスケジュール・データを追加して並び順をずらす、(2) 広告を表示する画面から直接開いたモーダルには overlay が残るので、広告のない画面（例: 服薬画面ではなくお薬一覧画面）経由でフォームを開く
  - 上記の y:355-510 という座標は画面が未スクロール時の値であり、overlay はバナー広告と同様に **スクロール可能なコンテンツの一部**として配置されている（固定オーバーレイではない）。そのため「対象要素を y>510 まで下げたつもり」でも、要素追加でリスト全体の高さが変わるとバナー位置も一緒にずれ、y>510 に見えても実際には overlay の裏に隠れていることがある。確実な回避策は、対象のチェックボックス等が画面内に見える状態で一度 `mobile_swipe_on_screen`（direction: up）でリストをスクロールし、その後の `mobile_list_elements_on_screen` で `overlayWebView` の最新 y 座標と対象要素の y 座標を比較してから（overlay の y+height より対象要素の y が大きいことを確認してから）タップする

## 横断確認項目

## 1. 起動・初期化

- [x] **初回起動で服薬画面に到達**: クリーンインストール（`xcrun simctl uninstall <UDID> com.bannzai.medicalarm` でアプリ削除 → 再インストール）後の起動で、通知許可・ATT ダイアログを経て服薬画面が表示される。クリーンインストール操作は手動で行う（maestro/flows/helpers/allow_notification.yaml は `clearState: false` で表示中ダイアログの突破のみを行い、状態のリセットはしない）
- [x] **2 回目以降の起動**: 再起動時はダイアログ群が再表示されず、直接服薬画面が表示される
- [x] **匿名認証とデータ永続化**: 再起動しても登録済みの薬・服薬記録が保持されている（匿名ユーザーが維持されている）
- [x] **Swift Package Manager で取り込んだネイティブ plugin**: iOS のビルドが通り、服薬画面に AdMob の広告 (ネイティブ広告) が表示され、設定タブの「Apple でアカウントを引き継ぐ」をタップすると Apple でのサインインの OS の画面が開く（#392 で google_mobile_ads・sign_in_with_apple を SwiftPM 対応版に上げた。リンクの成功は lib/features/account_link/QA.md のとおり実機が要るため、ここでは画面遷移までを見る）

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **初回起動で服薬画面に到達**: クリーンインストール（`xcrun simctl uninstall <UDID> com.bannzai.medicalarm` でアプリ削除 → 再インストール）後の起動で、通知許可・ATT ダイアログを経て服薬画面が表示される。クリーンインストール操作は手動で行う（maestro/flows/helpers/allow_notification.yaml は `clearState: false` で表示中ダイアログの突破のみを行い、状態のリセットはしない）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
simtunnel の Simulator にアプリを新規インストールしたユーザー 5 人 (日本語 4・英語 1) それぞれで、初回起動からオンボーディング・ペイウォール・ATT・通知許可のダイアログを経て服薬画面に到達した。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/6eb92f56-685d-4e52-a955-cbef3f518bf6-ob01-welcome.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/c0d369a6-655f-4e1e-9791-bff08015c6ab-ob11-placeholder-cards.jpg" width="320">

**確認日: 2026-10-16** (#392 の SwiftPM 化の後。main の ebcfd81f を simtunnel でビルドした iPhone 17 / iOS 26.5 の Simulator)
アプリを新規インストールした Simulator で、初回起動からオンボーディング・ペイウォールを閉じた後に ATT → 通知許可のダイアログが出て、服薬画面に到達した。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/290f9350-a11d-40af-a1be-149c1f061c08-a-01-first-launch.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/90add54f-7d1a-4680-9a42-bc2ea497b70f-a-13.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8e25b01a-863b-45d1-920f-6dabe202c6cc-a-14.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/e7045fb5-7316-47e0-b630-088581234ba0-a-15.jpg" width="320">

</details>

### **2 回目以降の起動**: 再起動時はダイアログ群が再表示されず、直接服薬画面が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
アプリを終了して起動し直すと、オンボーディングとダイアログは表示されずに服薬画面が直接表示された (各ユーザーで複数回)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/d8e1b0cd-a3d8-4a20-8ad9-882f872abbab-ob12-relaunch.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/36991f7e-b918-412a-9a21-5e03d0572398-m09-chip-persisted.jpg" width="320">

**確認日: 2026-10-16** (#392 の SwiftPM 化の後。main の ebcfd81f の simtunnel の Simulator)
アプリを終了して起動し直すと、ATT・通知許可・オンボーディングは出ずに服薬画面が直接表示された (開発ビルドの AdMob validator の警告だけが出る)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/5a238fb8-3b52-4ea3-b3f6-7ffef968c3a3-a-45.jpg" width="320">

</details>

### **匿名認証とデータ永続化**: 再起動しても登録済みの薬・服薬記録が保持されている（匿名ユーザーが維持されている）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
起動し直しても、登録した薬・服薬記録・選んだグループが保持されていた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/d8e1b0cd-a3d8-4a20-8ad9-882f872abbab-ob12-relaunch.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/36991f7e-b918-412a-9a21-5e03d0572398-m09-chip-persisted.jpg" width="320">

**確認日: 2026-10-16** (#392 の SwiftPM 化の後。main の ebcfd81f の simtunnel の Simulator)
登録した薬「QA408」(10:00・容量 1tab) が、アプリを終了して起動し直した後も服薬画面に表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/5a238fb8-3b52-4ea3-b3f6-7ffef968c3a3-a-45.jpg" width="320">

</details>

### **Swift Package Manager で取り込んだネイティブ plugin**: iOS のビルドが通り、服薬画面に AdMob の広告 (ネイティブ広告) が表示され、設定タブの「Apple でアカウントを引き継ぐ」をタップすると Apple でのサインインの OS の画面が開く（#392 で google_mobile_ads・sign_in_with_apple を SwiftPM 対応版に上げた。リンクの成功は lib/features/account_link/QA.md のとおり実機が要るため、ここでは画面遷移までを見る）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-16**
main の ebcfd81f (#392 の後) を simtunnel の build job (`flutter build ios --simulator --debug`) でビルドでき (https://github.com/bannzai/medicalarm/actions/runs/38767934016 )、iPhone 17 / iOS 26.5 の Simulator で起動した。服薬画面に AdMob のテスト広告 (「Test mode: Flood-It!」) が表示された。設定タブの「Apple でアカウントを引き継ぐ」(英語表示では「Transfer with Apple」) をタップすると、OS の「Sign in to your Apple Account」のダイアログが開いた (Simulator が Apple Account に未サインインのため、OS がサインインを促す画面になる)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/e7045fb5-7316-47e0-b630-088581234ba0-a-15.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/9cb2395f-2394-49f9-b627-b6ac680b279d-a-18.jpg" width="320">

</details>

</details>

## 2. iPhone Duo (外側・内側ディスプレイ) での主要画面の表示

- [x] **主要画面が外側・内側の両方で崩れない**: iPhone Duo の Simulator (iOS 27.1) で、オンボーディング (価値宣言・質問・結果)・ペイウォール・薬登録の案内・お薬登録フォーム・服用頻度・服用者・通知設定・ホームの 4 タブ・お薬一覧を、閉じた姿勢 (外側) → 開いた姿勢 (内側) → 閉じ直した姿勢の順に撮り、見切れ・重なり・不自然な余白・固定幅による偏りが無い。オンボーディングのプラン生成は自動で進む演出のため閉じた姿勢の外側だけを撮り、内側・閉じ直しは未確認。全画面のモーダルシートが右端のステータス表示の列を避けて狭まらず、お薬一覧のカードがその列に重ならない
  - 自動化: manual (姿勢の切り替えは `~/.claude/skills/ios-simulator/scripts/duo-pose.sh` で Device Hub を操作するためローカルの Mac でのみ可能)

### 実行ナレッジ: iPhone Duo の Simulator で外側・内側ディスプレイを確認する

- 起動は `sim-boot "<名前>" "iPhone Duo"` (機種名を渡す。iOS 27.1 のランタイムが要る)。姿勢の切り替えと撮影の順は ios-simulator skill Phase 2「折りたたみ端末の外側・内側ディスプレイを切り替える」が SSOT。外側は `xcrun simctl io <UDID> screenshot --display=primary`、内側は `--display=primary-1`
- 内側ディスプレイは横向き (2853×2007 px) で描画される。時刻・Wi-Fi の表示は右端の列に置かれ、アプリの内容はその左側に収まる (OS の配置で、崩れではない)
- Device Hub の姿勢ボタンを押しても内側が有効にならなくなることがある (`duo-pose.sh set ... open` が TIMEOUT)。`xcrun simctl shutdown` → `sim-boot` で Simulator を再起動すると復旧する
- プラン生成の演出 (約 2.4 秒) は姿勢の切り替え (6〜15 秒) が間に合わないため、外側だけを連写 (`xcrun simctl io ... screenshot` のループ) で撮る

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **主要画面が外側・内側の両方で崩れない**: iPhone Duo の Simulator (iOS 27.1) で、オンボーディング (価値宣言・質問・結果)・ペイウォール・薬登録の案内・お薬登録フォーム・服用頻度・服用者・通知設定・ホームの 4 タブ・お薬一覧を、閉じた姿勢 (外側) → 開いた姿勢 (内側) → 閉じ直した姿勢の順に撮り、見切れ・重なり・不自然な余白・固定幅による偏りが無い。オンボーディングのプラン生成は自動で進む演出のため閉じた姿勢の外側だけを撮り、内側・閉じ直しは未確認。全画面のモーダルシートが右端のステータス表示の列を避けて狭まらず、お薬一覧のカードがその列に重ならない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-11**
iPhone Duo の Simulator (iOS 27.1、Xcode 27.1 27A9275) で主要画面を 3 姿勢で撮影した (プラン生成だけは外側のみ)。全画面のモーダルシート (お薬登録フォーム・服用頻度・服用者・ペイウォール) とお薬一覧の崩れを修正し、修正後に崩れが無いことを確認した。全画面のスクリーンショットと修正前後の比較は issue https://github.com/bannzai/medicalarm/issues/370 を Closes する PR に載せている。
2026-10-15 追記: 2026-10-11 の確認以降の lib/ の変更は、お薬一覧のカードの編集アイコンに Semantics identifier を付けた変更 (9f97f7ec) だけで画面の配置は変わらないため、Duo では撮り直していない。
2026-10-16 追記: その後の lib/ の変更は、容量欄の入力を入力のたびに保存する変更 (#403。行に key を付けた以外に配置の変更は無い) と、デバッグビルドで例外をログに出す変更 (#406) で、画面の配置は変わらないため Duo では撮り直していない。#392 の SwiftPM 化は依存の取り込み方の変更で、画面の配置は変わらない。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/11/67c158b5-545c-478f-bb3d-1f7ddb1f2957-duo-10-medicine-form-after-outer.png" alt="iPhone Duo 外側ディスプレイのお薬登録フォーム (修正後)" width="300" /> <img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/11/bc31f287-375f-482a-997b-7ca2a599fd0b-duo-10-medicine-form-after-inner.png" alt="iPhone Duo 内側ディスプレイのお薬登録フォーム (修正後)" width="420" />

</details>

</details>

## 機能別 QA.md

- [onboarding](lib/features/onboarding/QA.md) — 初回起動の課金転換型オンボーディング
- [medicines](lib/features/medicines/QA.md) — お薬一覧・一時停止/再開
- [medicine_form](lib/features/medicine_form/QA.md) — 薬の登録・編集・削除
- [medicine_schedule_setting_form](lib/features/medicine_schedule_setting_form/QA.md) — スケジュールごとの通知設定
- [medication_frequency_form](lib/features/medication_frequency_form/QA.md) — 服用頻度設定
- [medications](lib/features/medications/QA.md) — 服薬画面（ホーム）
- [medications_histories](lib/features/medications_histories/QA.md) — 服薬履歴
- [calendar](lib/features/calendar/QA.md) — 月間カレンダー・服薬記録と日記の振り返り
- [diary_post](lib/features/diary_post/QA.md) — 日記投稿
- [dose_receiver_form](lib/features/dose_receiver_form/QA.md) — 服用者管理
- [preium_introduction](lib/features/preium_introduction/QA.md) — プレミアム訴求・購入導線
- [settings](lib/features/settings/QA.md) — 設定
- [home](lib/features/home/QA.md) — ホームコンテナ

## QA 対象外

| feature | 理由 |
| --- | --- |
| `localization` | 文言解決の基盤（l.dart / resolver.dart）。画面を持たない |
| `resolver` | DI・匿名認証・DB 解決・課金セットアップ・強制アップデート等の基盤。起動が成功して服薬画面に到達することを横断確認項目 1 でカバー |
| `root` | レゾルバ積層と HomePage 表示のみ。横断確認項目 1 でカバー |
| `group` | グループのアイコン（group_icon.dart）と招待コードダイアログ（invitation_code_dialog.dart）の共通部品で、単独の画面を持たない。利用元の group_create・group_setting・group_list・medications（グループ切替チップ）の QA.md でカバー |
| `promotion_start` | ★5 レビュー訴求画面。表示条件は PromotionStartResolver（lib/features/promotion_start/resolver.dart）が判定する「プレミアム未加入・トライアル未使用・アカウント作成から1日超経過・前回キャンセルから7日超経過」の全成立で、クリーンインストール直後の初回起動では表示されない。時間経過に依存して安定再現できないため個別 QA.md は持たず、表示された場合に「今はしない」で閉じて服薬画面に到達できることは maestro/flows/helpers/allow_notification.yaml の条件付きタップでカバー |
