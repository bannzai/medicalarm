---
feature: medicine_schedule_setting_form
verification: mobile-mcp
last_verified_commit: ceab6b15bfd78420f8bbb9a67bd045e58f0f4362
last_verified_at: 2026-07-14
---

# medicine_schedule_setting_form QA

## 1. 通知設定

お薬登録画面の各服用スケジュール行の歯車（設定）アイコンをタップして開く。設定変更は即座に反映され、保存ボタンはない。

Critical Alert（マナーモードでも通知）・AlarmKit（アラーム機能）の許可ダイアログは一度許可すると同一インストールでは二度と表示されない。`xcrun simctl privacy <UDID> reset all <bundle-id>` は通知/AlarmKit 許可を含まないため無効。再度ダイアログを表示させて確認する場合は `mobile_uninstall_app` → `mobile_install_app`（ビルド済み `.app` を再指定）でアプリを再インストールする（Firestore 上の匿名ユーザーデータ・登録済みの薬はこのシミュレータでは再インストール後も保持されていた）。

- [x] **AppBar タイトル**: AppBar に「服用スケジュール通知設定」と表示される
- [x] **服用時の通知**: 「服用時の通知を有効にする」トグル。OFF にするとフォローアップ通知も自動で OFF になる
- [x] **フォローアップ通知**: 「フォローアップ通知を有効にする」トグル。服用時の通知が OFF の間は ON にできない
- [x] **マナーモードでも通知**: 「マナーモードでも通知する」トグル。ON にすると Critical Alert の通知許可がリクエストされ、許可されなければ OFF のままになる
- [x] **音量スライダー**: 「音量」スライダーは「マナーモードでも通知する」が ON のときのみ操作できる
- [x] **アラーム機能（利用可能時）**: AlarmKit が利用可能な端末では「アラーム機能」トグルが表示され、ON 時に権限がリクエストされる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **AppBar タイトル**: AppBar に「服用スケジュール通知設定」と表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/00c10058-1c5d-46eb-82b1-e7bcc7f69845.png" width="320">

</details>

### **服用時の通知**: 「服用時の通知を有効にする」トグル。OFF にするとフォローアップ通知も自動で OFF になる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/775caccf-0588-4433-81e1-6d13d8abe6c1.png" width="320">

</details>

### **フォローアップ通知**: 「フォローアップ通知を有効にする」トグル。服用時の通知が OFF の間は ON にできない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/d9ab8efe-8398-49b4-97d3-0c7ab7f192fe.png" width="320">

</details>

### **マナーモードでも通知**: 「マナーモードでも通知する」トグル。ON にすると Critical Alert の通知許可がリクエストされ、許可されなければ OFF のままになる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/5a14ea53-500c-42d0-9082-8c8bdc516ba8.png" width="320">

</details>

### **音量スライダー**: 「音量」スライダーは「マナーモードでも通知する」が ON のときのみ操作できる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/2c6fa400-b66b-48f1-aec8-d4c5ebcc20b5.png" width="320">

</details>

### **アラーム機能（利用可能時）**: AlarmKit が利用可能な端末では「アラーム機能」トグルが表示され、ON 時に権限がリクエストされる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/8a392ebd-b3ff-482f-8f9d-967616f8375d.png" width="320">

</details>

</details>

---

## 2. Focus 連携

- [x] **ブロック設定の表示**: 「通知受信から服薬記録するまで他のアプリをブロックする」項目が表示される。連携済みはチェックアイコン、未連携は空のチェックボックスで表示される
- [x] **Focus 未インストール時**: Focus アプリが未インストールの場合、タップすると「Focusがインストールされていません」ダイアログが表示される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **ブロック設定の表示**: 「通知受信から服薬記録するまで他のアプリをブロックする」項目が表示される。連携済みはチェックアイコン、未連携は空のチェックボックスで表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/931b6298-2ada-42eb-b7b8-58e38e7aa85a.png" width="320">

</details>

### **Focus 未インストール時**: Focus アプリが未インストールの場合、タップすると「Focusがインストールされていません」ダイアログが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/aae09037-16cf-4705-86c4-b47bfe689584.png" width="320">

</details>

</details>
