---
feature: home
verification: mobile-mcp
last_verified_commit: 263630555ac273bca24b8c4df556f018b9a8578d
last_verified_at: 2026-10-16
---

# home QA

## 1. タブの表示

- [x] **初期タブ**: 起動時は「服薬」タブ（先頭タブ）が選択された状態で表示される
- [x] **タブ構成**: 下部に「服薬」（タイマーアイコン）「履歴」（リストアイコン）「カレンダー」（カレンダーアイコン）「設定」（歯車アイコン）の4タブが左から順に並ぶ
- [x] **選択中タブの色**: 選択中タブのラベル・アイコンはプライマリカラー、未選択タブはグレーで表示される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **初期タブ**: 起動時は「服薬」タブ（先頭タブ）が選択された状態で表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
アプリを起動し直すと「服薬」タブが選択された状態で表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/d8e1b0cd-a3d8-4a20-8ad9-882f872abbab-ob12-relaunch.jpg" width="320">

</details>

### **タブ構成**: 下部に「服薬」（タイマーアイコン）「履歴」（リストアイコン）「カレンダー」（カレンダーアイコン）「設定」（歯車アイコン）の4タブが左から順に並ぶ

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
下部に「服薬」(タイマー)「履歴」(リスト)「カレンダー」(カレンダー)「設定」(歯車) の 4 タブが左から並んだ (アクセシビリティのラベルも「タブ: 1/4」〜「タブ: 4/4」)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/c0d369a6-655f-4e1e-9791-bff08015c6ab-ob11-placeholder-cards.jpg" width="320">

</details>

### **選択中タブの色**: 選択中タブのラベル・アイコンはプライマリカラー、未選択タブはグレーで表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
選択中のタブのラベル・アイコンはプライマリカラー、未選択のタブはグレーで表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/c0d369a6-655f-4e1e-9791-bff08015c6ab-ob11-placeholder-cards.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/00b1af95-7457-4c22-b0a3-f4d42321213d-cal01-month.jpg" width="320">

</details>

</details>

---

## 2. タブ切り替え

- [x] **タブタップで切替**: 各タブをタップすると、それぞれ服薬画面・服薬履歴画面・カレンダー画面・設定画面に表示が切り替わる
- [x] **スワイプ無効**: コンテンツ領域を左右スワイプしてもタブは切り替わらない（タップのみで切替可能）

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **タブタップで切替**: 各タブをタップすると、それぞれ服薬画面・服薬履歴画面・カレンダー画面・設定画面に表示が切り替わる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
各タブをタップすると、服薬画面・服薬履歴画面・カレンダー画面・設定画面に切り替わった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8d0d68de-fd86-44d6-aa03-7c00d31447a6-m01-home-cards.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/7ee6e842-142d-4b66-87f4-de2fb2851e28-mh01-revert-card.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/00b1af95-7457-4c22-b0a3-f4d42321213d-cal01-month.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/68c527f7-96ca-419b-8b85-9f7ace2f89e6-st01-settings.jpg" width="320">

</details>

### **スワイプ無効**: コンテンツ領域を左右スワイプしてもタブは切り替わらない（タップのみで切替可能）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
服薬画面の中央を右から左へスワイプしても「服薬」タブのままで、ほかのタブに切り替わらなかった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/9ac75777-9e7e-4ecf-9405-83ac163721cc-h01-after-swipe.jpg" width="320">

</details>

</details>

---

## 3. 通知許可のリクエスト

- [x] **起動時の通知許可**: HomePage 初回表示時に OS のプッシュ通知許可ダイアログがリクエストされる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **起動時の通知許可**: HomePage 初回表示時に OS のプッシュ通知許可ダイアログがリクエストされる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
新規ユーザーがオンボーディングを終えてホームに入る時に、OS のプッシュ通知の許可ダイアログ (Would Like to Send You Notifications) が表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/c0d369a6-655f-4e1e-9791-bff08015c6ab-ob11-placeholder-cards.jpg" width="320">

</details>

</details>
