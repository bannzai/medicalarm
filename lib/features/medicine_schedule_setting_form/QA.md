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

**確認日: 2026-10-15**
お薬登録画面 (編集) のスケジュール行の歯車から開くと、AppBar に「服用スケジュール通知設定」と表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/356b6dc2-2bd7-4cad-ad03-f6eaf5d8eee3-ss01-schedule-setting.jpg" width="320">

</details>

### **服用時の通知**: 「服用時の通知を有効にする」トグル。OFF にするとフォローアップ通知も自動で OFF になる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
フォローアップ通知を ON にした状態で「服用時の通知を有効にする」を OFF にすると、フォローアップ通知も OFF になった (アクセシビリティの値で確認)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/356b6dc2-2bd7-4cad-ad03-f6eaf5d8eee3-ss01-schedule-setting.jpg" width="320">

</details>

### **フォローアップ通知**: 「フォローアップ通知を有効にする」トグル。服用時の通知が OFF の間は ON にできない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
服用時の通知が OFF の間に「フォローアップ通知を有効にする」をタップしても OFF のままだった。服用時の通知を ON に戻すと ON にできた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/356b6dc2-2bd7-4cad-ad03-f6eaf5d8eee3-ss01-schedule-setting.jpg" width="320">

</details>

### **マナーモードでも通知**: 「マナーモードでも通知する」トグル。ON にすると Critical Alert の通知許可がリクエストされ、許可されなければ OFF のままになる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「マナーモードでも通知する」を ON にすると OS の Critical Alerts の許可ダイアログが表示され、Allow を選ぶと ON になった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/bd0d9cd8-7ac2-483f-87ea-f17d466445f0-ss02-critical-alert-request.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/20d34788-fa37-4596-ade3-3c69953baf1d-ss03-critical-on-slider.jpg" width="320">

</details>

### **音量スライダー**: 「音量」スライダーは「マナーモードでも通知する」が ON のときのみ操作できる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「マナーモードでも通知する」が OFF の間は音量スライダーが操作できない要素 (値 50% の表示だけ) で、ON にすると操作できる色のスライダーに変わった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/356b6dc2-2bd7-4cad-ad03-f6eaf5d8eee3-ss01-schedule-setting.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/20d34788-fa37-4596-ade3-3c69953baf1d-ss03-critical-on-slider.jpg" width="320">

</details>

### **アラーム機能（利用可能時）**: AlarmKit が利用可能な端末では「アラーム機能」トグルが表示され、ON 時に権限がリクエストされる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
iOS 26 の Simulator で「アラーム機能」トグルが表示され、ON にすると OS の「alarms and timers」の許可ダイアログが表示された。Don't Allow を選ぶと OFF のままだった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/b7d59b70-8b50-4b17-844a-6918001f6853-ss04-alarmkit-request.jpg" width="320">

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

**確認日: 2026-10-15**
「通知受信から服薬記録するまで他のアプリをブロックする」項目が未連携の空のチェックボックスで表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/20d34788-fa37-4596-ade3-3c69953baf1d-ss03-critical-on-slider.jpg" width="320">

</details>

### **Focus 未インストール時**: Focus アプリが未インストールの場合、タップすると「Focusがインストールされていません」ダイアログが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
Focus アプリが入っていない Simulator で項目をタップすると「Focusがインストールされていません」ダイアログが表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/4f775d10-16f7-4c85-8443-2757edb1b55d-ss05-focus-not-installed.jpg" width="320">

</details>

</details>
