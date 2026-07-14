---
feature: _root
verification: mobile-mcp
last_verified_commit: null
last_verified_at: null
---

# QA 全体ガイド

## 対象環境

- Firebase project: `medicalarm-prod`（firebase/.firebaserc の default。dev 環境はなく、QA も prod に対して行う）
- 匿名認証で起動のたびに新規ユーザーを作れるため、QA データは匿名ユーザー配下に閉じる。既存ユーザーのデータには触れないこと
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
- /maestro-flutter: 既存 E2E フローの実行（`maestro test maestro/flows/`）
  - `allow_notification.yaml`: 起動直後の OS ダイアログ（通知許可・ATT）と初回プロモーションを閉じる helper。他フローの先頭から `runFlow` で呼ばれる
  - `register_and_pause.yaml` / `full_pause_feature.yaml` / `toggle_switch.yaml` / `resume_and_edit.yaml` / `form_pause.yaml`: 薬の登録〜一時停止・再開の一連
- ユニットテスト: `flutter test` / 静的解析: `flutter analyze`

### 再現が難しい操作の手順

- 起動直後は通知許可 → ATT → 初回プロモーション（★5 レビュー訴求）→ AdMob validator 警告（開発ビルド）の順不同でダイアログが重なる。mobile-mcp で手動確認する場合も、まず `maestro test maestro/flows/allow_notification.yaml` で突破してから操作を始めるのが確実
- `flutter build ios --simulator` + `xcrun simctl install/launch` でアプリを起動すると、`lib/main.dart` の `setupRemoteConfig()`（`fetchAndActivate()` の `fetchTimeout` が1分）が同期待ちのため、シミュレータのネットワーク到達性によっては最大60秒程度 LaunchImage（白画面）のまま初回フレームが描画されない。`mobile_list_elements_on_screen` で `LaunchImage` が居座っていないかを確認し、白画面でも即座に失敗と判断しない
- 非対話実行でも `flutter run -d <UDID>` はプロセスが常駐し続けるため、`run_in_background: true` で起動し、ログファイルを `grep` でポーリングして起動完了（`Flutter run key commands.` の出力）を待つ必要がある（フォアグラウンドで実行すると turn がブロックされたまま完了しない）
- AdMob native ad validator の警告（開発ビルドのみ表示）は `overlayWebView` 内の要素で `mobile_list_elements_on_screen` にテキストとして現れず、`Dismiss` ボタン座標の目視推定タップが当たりにくい。無理に閉じようとせず、下部タブバー操作は overlay の下でも独立して機能するためそのまま操作を継続してよい
  - この overlay は画面座標 x:0-335 y:355-510 に固定表示され、この範囲に重なるチェックボックス・ボタン等へのタップを奪う（`mobile_list_elements_on_screen` にはアクセシビリティ要素として現れるが、実タップは overlay 側が受け取る）。回避策: (1) 対象要素がこの範囲外（y>510）に来るよう事前に他のスケジュール・データを追加して並び順をずらす、(2) 広告を表示する画面から直接開いたモーダルには overlay が残るので、広告のない画面（例: 服薬画面ではなくお薬一覧画面）経由でフォームを開く
  - 上記の y:355-510 という座標は画面が未スクロール時の値であり、overlay はバナー広告と同様に **スクロール可能なコンテンツの一部**として配置されている（固定オーバーレイではない）。そのため「対象要素を y>510 まで下げたつもり」でも、要素追加でリスト全体の高さが変わるとバナー位置も一緒にずれ、y>510 に見えても実際には overlay の裏に隠れていることがある。確実な回避策は、対象のチェックボックス等が画面内に見える状態で一度 `mobile_swipe_on_screen`（direction: up）でリストをスクロールし、その後の `mobile_list_elements_on_screen` で `overlayWebView` の最新 y 座標と対象要素の y 座標を比較してから（overlay の y+height より対象要素の y が大きいことを確認してから）タップする

## 横断確認項目

## 1. 起動・初期化

- [ ] **初回起動で服薬画面に到達**: クリーンインストール後の起動で、通知許可・ATT ダイアログと初回プロモーション画面（「今はしない」で閉じる）を経て服薬画面が表示される（maestro/flows/allow_notification.yaml でカバー）
- [ ] **2 回目以降の起動**: 再起動時はダイアログ群が再表示されず、直接服薬画面が表示される
- [ ] **匿名認証とデータ永続化**: 再起動しても登録済みの薬・服薬記録が保持されている（匿名ユーザーが維持されている）

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **初回起動で服薬画面に到達**: クリーンインストール後の起動で、通知許可・ATT ダイアログと初回プロモーション画面（「今はしない」で閉じる）を経て服薬画面が表示される（maestro/flows/allow_notification.yaml でカバー）

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **2 回目以降の起動**: 再起動時はダイアログ群が再表示されず、直接服薬画面が表示される

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **匿名認証とデータ永続化**: 再起動しても登録済みの薬・服薬記録が保持されている（匿名ユーザーが維持されている）

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>

## 機能別 QA.md

- [medicines](lib/features/medicines/QA.md) — お薬一覧・一時停止/再開
- [medicine_form](lib/features/medicine_form/QA.md) — 薬の登録・編集・削除
- [medicine_schedule_setting_form](lib/features/medicine_schedule_setting_form/QA.md) — スケジュールごとの通知設定
- [medication_frequency_form](lib/features/medication_frequency_form/QA.md) — 服用頻度設定
- [medications](lib/features/medications/QA.md) — 服薬画面（ホーム）
- [medications_histories](lib/features/medications_histories/QA.md) — 服薬履歴
- [diary_post](lib/features/diary_post/QA.md) — 日記投稿
- [dose_receiver_form](lib/features/dose_receiver_form/QA.md) — 服用者管理
- [preium_introduction](lib/features/preium_introduction/QA.md) — プレミアム訴求・購入導線
- [settings](lib/features/settings/QA.md) — 設定
- [home](lib/features/home/QA.md) — ホームコンテナ

## QA 対象外

- `localization`: 文言解決の基盤（l.dart / resolver.dart）。画面を持たない
- `resolver`: DI・匿名認証・DB 解決・課金セットアップ・強制アップデート等の基盤。起動が成功して服薬画面に到達することを横断確認項目 1 でカバー
- `root`: レゾルバ積層と HomePage 表示のみ。横断確認項目 1 でカバー
- `promotion_start`: 初回起動時のみ表示される★5 レビュー訴求画面で、表示条件が特殊なため個別 QA.md は持たない。「今はしない」で閉じて服薬画面に到達することを横断確認項目 1 でカバー
