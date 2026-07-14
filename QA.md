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
