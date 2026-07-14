---
feature: home
verification: mobile-mcp
last_verified_commit: ceab6b15bfd78420f8bbb9a67bd045e58f0f4362
last_verified_at: 2026-07-14
---

# home QA

## 1. タブの表示

- [x] **初期タブ**: 起動時は「服薬」タブ（先頭タブ）が選択された状態で表示される
- [x] **タブ構成**: 下部に「服薬」（タイマーアイコン）「履歴」（リストアイコン）「設定」（歯車アイコン）の3タブが左から順に並ぶ
- [x] **選択中タブの色**: 選択中タブのラベル・アイコンはプライマリカラー、未選択タブはグレーで表示される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **初期タブ**: 起動時は「服薬」タブ（先頭タブ）が選択された状態で表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/766a3845-ad07-402e-81a2-2a1961e4056d.png" width="320">

</details>

### **タブ構成**: 下部に「服薬」（タイマーアイコン）「履歴」（リストアイコン）「設定」（歯車アイコン）の3タブが左から順に並ぶ

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/766a3845-ad07-402e-81a2-2a1961e4056d.png" width="320">

</details>

### **選択中タブの色**: 選択中タブのラベル・アイコンはプライマリカラー、未選択タブはグレーで表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/766a3845-ad07-402e-81a2-2a1961e4056d.png" width="320">

</details>

</details>

---

## 2. タブ切り替え

- [x] **タブタップで切替**: 各タブをタップすると、それぞれ服薬画面・服薬履歴画面・設定画面に表示が切り替わる
- [x] **スワイプ無効**: コンテンツ領域を左右スワイプしてもタブは切り替わらない（タップのみで切替可能）

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **タブタップで切替**: 各タブをタップすると、それぞれ服薬画面・服薬履歴画面・設定画面に表示が切り替わる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/0797fb4c-599b-460a-86da-59002185283c.png" width="320">

</details>

### **スワイプ無効**: コンテンツ領域を左右スワイプしてもタブは切り替わらない（タップのみで切替可能）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/9ef93ad2-9aab-487e-8874-908c7e850934.png" width="320">

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

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/07a9a563-4bf3-49f6-9277-0b76ee2e8861.png" width="320">

</details>

</details>
