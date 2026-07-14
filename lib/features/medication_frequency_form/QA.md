---
feature: medication_frequency_form
verification: mobile-mcp
last_verified_commit: ceab6b15bfd78420f8bbb9a67bd045e58f0f4362
last_verified_at: 2026-07-14
---

# medication_frequency_form QA

## 1. 頻度タイプの選択

お薬登録画面の「服用頻度」行をタップして開く。

- [x] **4つの頻度タイプ**: 「服用頻度」セクションに「毎日」「X日ごと」「特定の曜日」「周期」の4項目が表示される。「X日ごと」「特定の曜日」「周期」には説明（例:「X日ごと」→「例) 2日ごと、3日ごと」）が付く
- [x] **選択中の表示**: 現在選択中のタイプの右にチェックアイコンが表示される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **4つの頻度タイプ**: 「服用頻度」セクションに「毎日」「X日ごと」「特定の曜日」「周期」の4項目が表示される。「X日ごと」「特定の曜日」「周期」には説明（例:「X日ごと」→「例) 2日ごと、3日ごと」）が付く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/25d3eb5e-a201-4799-a12a-067c578a3f64.png" width="320">

</details>

### **選択中の表示**: 現在選択中のタイプの右にチェックアイコンが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/25d3eb5e-a201-4799-a12a-067c578a3f64.png" width="320">

</details>

</details>

---

## 2. タイプ別の詳細設定

- [x] **毎日**: 「毎日」を選ぶと詳細設定は表示されない
- [x] **X日ごと**: 「X日ごと」を選ぶと「{count}日ごと」行が表示され、タップすると数値ピッカーで間隔を変更できる
- [x] **特定の曜日**: 「特定の曜日」を選ぶと曜日リストが表示され、タップで各曜日の選択／解除ができる（選択中はチェック表示）
- [x] **周期**: 「周期」を選ぶと「{count}日服用」「{count}日休薬」行が表示され、それぞれ数値ピッカーで変更できる。加えて「おすすめアプリ」セクションに Pilll のインストール導線が表示される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **毎日**: 「毎日」を選ぶと詳細設定は表示されない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/25d3eb5e-a201-4799-a12a-067c578a3f64.png" width="320">

</details>

### **X日ごと**: 「X日ごと」を選ぶと「{count}日ごと」行が表示され、タップすると数値ピッカーで間隔を変更できる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/6a08d296-cb1d-4239-865f-cd5b099feba9.png" width="320">

</details>

### **特定の曜日**: 「特定の曜日」を選ぶと曜日リストが表示され、タップで各曜日の選択／解除ができる（選択中はチェック表示）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/e288eba0-595c-4eb9-b124-e51095bf87a4.png" width="320">

</details>

### **周期**: 「周期」を選ぶと「{count}日服用」「{count}日休薬」行が表示され、それぞれ数値ピッカーで変更できる。加えて「おすすめアプリ」セクションに Pilll のインストール導線が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/1dc3c59f-aa4d-4bc0-9aa1-db670c2632d4.png" width="320">

</details>

</details>

---

## 3. 保存

- [x] **保存**: 下部の「保存」ボタンをタップすると選択した頻度が呼び出し元（お薬登録画面）に反映され、画面が閉じる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **保存**: 下部の「保存」ボタンをタップすると選択した頻度が呼び出し元（お薬登録画面）に反映され、画面が閉じる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/d5d20de1-d05e-4b42-a2c5-e52ec33c9cb5.png" width="320">

</details>

</details>
