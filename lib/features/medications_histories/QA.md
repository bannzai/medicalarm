---
feature: medications_histories
verification: mobile-mcp
last_verified_commit: ceab6b15bfd78420f8bbb9a67bd045e58f0f4362
last_verified_at: 2026-07-14
---

# medications_histories QA

## 1. 服薬履歴一覧の表示

- [x] **AppBar タイトル**: 「服薬履歴」が表示される
- [x] **週カレンダー・本日バッジ**: 画面上部に週表示カレンダーと選択日を示すバッジ（TodayBadge）が表示される
- [x] **履歴カード**: 選択日に服用記録がある場合、記録ごとにカードが一覧表示される
- [x] **カード内容**: 各カードに薬名（プライマリカラー・太字）、数量メモ（右寄せ）、服用者名、「予定時刻」（月日＋スケジュール時刻）、「記録時間」（月日＋記録時刻）が表示される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **AppBar タイトル**: 「服薬履歴」が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/be5f2b42-fc79-4cd4-95fd-deb45dc64363.png" width="320">

AppBar に「服薬履歴」が表示されている

</details>

### **週カレンダー・本日バッジ**: 画面上部に週表示カレンダーと選択日を示すバッジ（TodayBadge）が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/be5f2b42-fc79-4cd4-95fd-deb45dc64363.png" width="320">

週表示カレンダー（12〜18の日付、14が選択中でハイライト）と、選択日を示す「← 7/14 →」バッジが表示されている

</details>

### **履歴カード**: 選択日に服用記録がある場合、記録ごとにカードが一覧表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/be5f2b42-fc79-4cd4-95fd-deb45dc64363.png" width="320">

服薬画面（medications タブ）でQAテスト薬Aの11:00スケジュールにチェックを入れて服用記録を作成した後、服薬履歴タブで7/14を選択するとカードが1件表示される

</details>

### **カード内容**: 各カードに薬名（プライマリカラー・太字）、数量メモ（右寄せ）、服用者名、「予定時刻」（月日＋スケジュール時刻）、「記録時間」（月日＋記録時刻）が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/be5f2b42-fc79-4cd4-95fd-deb45dc64363.png" width="320">

「QAテスト薬A」（プライマリカラー・太字）、「自分」、「予定時刻: 7月14日 11:00」、「記録時間: 7月14日 22:54」が表示されている（このスケジュールは数量メモ未設定のため数量メモ欄は空）

</details>

</details>

---

## 2. 空状態

- [x] **記録なし表示**: 選択日に服用記録が無い場合、中央に「服薬履歴がありません」と表示される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **記録なし表示**: 選択日に服用記録が無い場合、中央に「服薬履歴がありません」と表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/4a416033-bc50-4f99-8a7a-26240b79296f.png" width="320">

服用記録の無い7/16を選択すると中央に「服薬履歴がありません」と表示される

</details>

</details>

---

## 3. 日付の切り替え

- [x] **週送り**: 週カレンダーを左右にページ送りできる
- [x] **日付選択**: カレンダー上の日付をタップすると、その日付の服薬履歴一覧に切り替わる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **週送り**: 週カレンダーを左右にページ送りできる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/e94f1d88-f263-4dda-81b4-c68946256e16.png" width="320">

週カレンダーを左にスワイプすると 7/12〜7/18 の週から 7/19〜7/25 の週にページが切り替わった

</details>

### **日付選択**: カレンダー上の日付をタップすると、その日付の服薬履歴一覧に切り替わる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/da1d9b31-397d-49a9-9c2f-8a24536f01ae.png" width="320">

7/16選択状態から週内の「14」をタップすると、7/14の服薬履歴一覧（QAテスト薬Aのカード）に切り替わった

</details>

</details>

---

## 4. メモの編集

- [x] **メモ未設定表示**: メモが空の履歴カードには「メモなし」と表示される
- [x] **メモ編集シート**: カード右下の編集アイコンをタップするとテキスト編集シートが開き、既存メモが初期表示される
- [x] **メモ保存**: 編集シートで「保存」をタップするとメモが更新され、カードの表示に反映される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **メモ未設定表示**: メモが空の履歴カードには「メモなし」と表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/be5f2b42-fc79-4cd4-95fd-deb45dc64363.png" width="320">

メモ未入力の履歴カードに「メモなし」と表示されている

</details>

### **メモ編集シート**: カード右下の編集アイコンをタップするとテキスト編集シートが開き、既存メモが初期表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/7d0c1f5b-73c7-4c9e-a518-6afe93d84675.png" width="320">

カード右下の編集アイコンをタップするとテキスト編集シートが開く（既存メモが空のため初期表示は空欄）

</details>

### **メモ保存**: 編集シートで「保存」をタップするとメモが更新され、カードの表示に反映される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/ac0cf1d9-bf32-4880-9ef6-75d2bcf6471a.png" width="320">

「QA確認用メモ」と入力して保存すると、カードのメモ表示が「メモなし」から「QA確認用メモ」に更新された

</details>

</details>

---

## 5. 過去日の閲覧制限（課金）

- [x] **過去日のブラー制限**: プレミアム未加入かつ選択日が今日より前の場合、一覧にブラーがかかり「プレミアムプランの加入で閲覧が可能です」リンクが表示される
- [x] **課金導線**: 制限表示のリンクをタップするとプレミアム紹介シートが開く
- [x] **当日以降は制限なし**: 今日以降の日付、またはプレミアム加入時はブラー制限が表示されない

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **過去日のブラー制限**: プレミアム未加入かつ選択日が今日より前の場合、一覧にブラーがかかり「プレミアムプランの加入で閲覧が可能です」リンクが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/23efa350-4b7a-4d7f-8a50-65b36aac820e.png" width="320">

今日（7/14）より前の7/13を選択すると、一覧全体にブラーがかかり「プレミアムプランの加入で閲覧が可能です」リンクが中央に表示される

</details>

### **課金導線**: 制限表示のリンクをタップするとプレミアム紹介シートが開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/69c2efe4-266c-486c-a461-7fbbd985de31.png" width="320">

「プレミアムプランの加入で閲覧が可能です」リンクをタップするとプレミアム紹介シートが開き、特典の一つとして「服用履歴をすべて表示」が示される

</details>

### **当日以降は制限なし**: 今日以降の日付、またはプレミアム加入時はブラー制限が表示されない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/be5f2b42-fc79-4cd4-95fd-deb45dc64363.png" width="320">

今日（7/14）を選択した状態ではブラー制限がかからず、履歴カードがそのまま表示される（項目2で確認した未来日7/16でも同様に制限なし）

</details>

</details>
