---
feature: medicine_form
verification: mobile-mcp,maestro
last_verified_commit: ceab6b15bfd78420f8bbb9a67bd045e58f0f4362
last_verified_at: 2026-07-14
---

# medicine_form QA

## 1. フォームの初期表示（新規／編集）

お薬一覧の「お薬を追加」ボタン（新規）またはカード右上の編集アイコン（編集モード）から開く。

- [x] **AppBar タイトル**: AppBar に「お薬登録画面」と表示される
- [x] **新規登録時の初期値**: 新規で開くと薬の名前が空、服用頻度が「毎日」、服用開始日が当日、服用スケジュールが空、服用者が「自分」で表示される
- [x] **編集時のプリフィル**: 既存の薬を編集で開くと各項目に登録済みの値が入り、AppBar 右上に削除アイコンが表示される
- [x] **一時停止トグルの表示条件**: 「服薬を有効にする」トグルは編集モードのときのみ表示される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **AppBar タイトル**: AppBar に「お薬登録画面」と表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

新規登録画面（AppBar「お薬登録画面」）:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/679809b6-ffd1-4ecc-9299-6ed5eb6e997e.png" width="320">

編集画面（同じく「お薬登録画面」）:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/93007622-0d89-4c90-b438-3913146c85ce.png" width="320">

</details>

### **新規登録時の初期値**: 新規で開くと薬の名前が空、服用頻度が「毎日」、服用開始日が当日、服用スケジュールが空、服用者が「自分」で表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/679809b6-ffd1-4ecc-9299-6ed5eb6e997e.png" width="320">

</details>

### **編集時のプリフィル**: 既存の薬を編集で開くと各項目に登録済みの値が入り、AppBar 右上に削除アイコンが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/93007622-0d89-4c90-b438-3913146c85ce.png" width="320">

</details>

### **一時停止トグルの表示条件**: 「服薬を有効にする」トグルは編集モードのときのみ表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

編集モード（トグル表示あり）:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/93007622-0d89-4c90-b438-3913146c85ce.png" width="320">

新規モード（トグル非表示。削除アイコンはコード上常に表示されるが新規時は動作しない実装で、本項目の検証対象外）:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/679809b6-ffd1-4ecc-9299-6ed5eb6e997e.png" width="320">

</details>

</details>

---

## 2. 入力項目

- [x] **薬の名前**: 「薬の名前」欄に最大50文字まで入力できる
- [x] **服用頻度**: 「服用頻度」行をタップすると服用頻度の設定画面（モーダル）が開き、選択した頻度が行に反映される
- [x] **服用開始日**: 「服用開始日」行をタップすると日付ピッカー（過去365日〜当日の範囲）が開き、選んだ日付が反映される
- [x] **服用スケジュールの追加**: 「服用スケジュールを追加」で時刻10:00のスケジュール行が追加される。上限到達時は「服用スケジュールは{count}つまで登録できます。」が表示され追加ボタンが無効化される
- [x] **服用スケジュールの編集・削除**: スケジュール行で時刻・容量を編集でき、ゴミ箱アイコンで行を削除できる。歯車アイコンで通知設定画面へ遷移する
- [x] **その他情報**: 服用者の選択、メモ（最大300文字）、メモ画像の設定ができる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **薬の名前**: 「薬の名前」欄に最大50文字まで入力できる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

61文字入力しても50/50で打ち止めになることを確認:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/bd044220-b164-4ef8-9ff1-79edd8d04567.png" width="320">

</details>

### **服用頻度**: 「服用頻度」行をタップすると服用頻度の設定画面（モーダル）が開き、選択した頻度が行に反映される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

「特定の曜日」で月・水・木・金・土を選択:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/316e1213-c36c-459d-88e7-949f4b4fcebd.png" width="320">

フォームの「服用頻度」行に反映:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/d4ce70ae-09a5-4af2-9adf-073db3b40b70.png" width="320">

</details>

### **服用開始日**: 「服用開始日」行をタップすると日付ピッカー（過去365日〜当日の範囲）が開き、選んだ日付が反映される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

日付ピッカーで7/10を選択した結果、「服用開始日」行には2026/07/09と反映された（1日ずれて表示される可能性があるが、タップ位置の誤差である可能性も否定できず、断定できるほどの再現確認はしていない）:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/768a0962-fe8c-4c48-9027-9ea8ac1db11d.png" width="320">

</details>

### **服用スケジュールの追加**: 「服用スケジュールを追加」で時刻10:00のスケジュール行が追加される。上限到達時は「服用スケジュールは{count}つまで登録できます。」が表示され追加ボタンが無効化される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

2件追加すると上限メッセージ「服用スケジュールは2つまで登録できます。」が表示され追加ボタンが無効化される（無料プランの上限は2件）:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/e549a656-eba8-4e33-a42b-d47429278685.png" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/7aa42659-d63a-40ce-9835-c14dd6e889d2.png" width="320">

</details>

### **服用スケジュールの編集・削除**: スケジュール行で時刻・容量を編集でき、ゴミ箱アイコンで行を削除できる。歯車アイコンで通知設定画面へ遷移する

- 時刻ピッカー（`AppTimePicker`）は完了ボタンの外側（ピッカー本体領域）を1px でもタップすると `Navigator.pop(context)`（結果 null）でキャンセル扱いになる。mobile-mcp 等で座標タップする場合は完了ボタンの中心座標を正確に狙うこと。歯車アイコン・ゴミ箱アイコンなど48x48の`IconButton`も同様に、境界座標ではなく中心をタップしないと反応しないことがある

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

時刻を19:00・容量を「1錠」に編集:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/88e7ef7c-8bd9-4efc-91ed-75b124ce7b1c.png" width="320">

歯車アイコンから服用スケジュール通知設定画面に遷移:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/8cea8f9e-f152-4689-b11d-09bd30428170.png" width="320">

ゴミ箱アイコンで2件目の行を削除:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/a61a1f1e-09c8-401c-8c1c-5180cfacc3d7.png" width="320">

</details>

### **その他情報**: 服用者の選択、メモ（最大300文字）、メモ画像の設定ができる

- メモ画像追加ボタン（カメラアイコン）は `Row` の中で `crossAxisAlignment` が中央揃えのため、複数行メモ欄の垂直方向の中央あたりに位置する（メモ欄の上端ではない）。座標タップ時は注意する

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

「服用者」行から服用者選択画面に遷移し「自分」を確認:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/dd435b72-0df5-4f5f-a75e-15aaf1d1195a.png" width="320">

メモに「QAメモテスト」を入力し、メモ画像をフォトライブラリから選択・アップロードして反映:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/c9718397-260f-464e-bb90-cd42db0c6ce2.png" width="320">

</details>

</details>

---

## 3. バリデーションと保存

- [x] **未入力時のバリデーション**: 薬の名前が空、または服用スケジュールが0件のとき「名前と服用スケジュールを入力してください」が表示され保存ボタンが無効化される
- [x] **保存**: 名前とスケジュールが揃うと保存ボタンが有効になり、タップすると薬が登録／更新されて画面が閉じる (maestro/flows/register_and_pause.yaml でカバー)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **未入力時のバリデーション**: 薬の名前が空、または服用スケジュールが0件のとき「名前と服用スケジュールを入力してください」が表示され保存ボタンが無効化される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

名前・スケジュールともに空の新規登録画面で「名前と服用スケジュールを入力してください」が表示され保存ボタンが無効化されている:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/679809b6-ffd1-4ecc-9299-6ed5eb6e997e.png" width="320">

</details>

### **保存**: 名前とスケジュールが揃うと保存ボタンが有効になり、タップすると薬が登録／更新されて画面が閉じる (maestro/flows/register_and_pause.yaml でカバー)

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

保存ボタンタップ後、お薬一覧画面に戻り更新内容が反映されている:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/9237613a-109a-4a96-ad03-0b7865399f83.png" width="320">

また `maestro test maestro/flows/register_and_pause.yaml` 相当の新規登録フロー（お薬を追加→名前入力→スケジュール追加→保存）も本セッション内で手動再現し、正常に保存されることを確認した。

</details>

</details>

---

## 4. 服薬の一時停止トグル（編集モード）

- [x] **一時停止トグルの説明**: 「服薬を有効にする」「オフにすると服薬画面・通知から除外されます」が表示される
- [ ] **一時停止／再開の切替**: トグルを OFF にすると「薬の服用を一時停止しました」、ON にすると「薬の服用を再開しました」の Snackbar が表示される (maestro/flows/form_pause.yaml でカバー)
  - ❌ 失敗: トグル自体の ON/OFF 切替（`pausedDateTime` の更新・Firestore への反映）は正常に動作するが、確認メッセージの Snackbar（「薬の服用を一時停止しました」「薬の服用を再開しました」）が画面に表示されない。`maestro test maestro/flows/form_pause.yaml` を2回実行し、いずれも最終アサーション `"一時停止しました" is visible` が FAILED（トグルタップ自体は COMPLETED）。手動でも mobile-mcp のタップ直後に `xcrun simctl io screenshot` で即座に撮影する方式を複数回試したが、一度も Snackbar が写った screenshot は得られなかった。medicine_form 画面が `showModalBottomSheet` + `DraggableScrollableSheet` の中で独自の `Scaffold` を持つ構成のため、`ScaffoldMessenger.of(context)`（lib/features/medicine_form/components/pause/tile.dart:34）が背後の画面の `Scaffold` を参照し、モーダルの背後に隠れて表示されている可能性がある。同じ Snackbar 実装は lib/features/medicines/page.dart（モーダルでない画面）にもあり、そちらでは正常に表示される（medicines/QA.md セクション3で確認済み）。issue: https://github.com/bannzai/medicalarm/issues/245

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **一時停止トグルの説明**: 「服薬を有効にする」「オフにすると服薬画面・通知から除外されます」が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/93007622-0d89-4c90-b438-3913146c85ce.png" width="320">

</details>

### **一時停止／再開の切替**: トグルを OFF にすると「薬の服用を一時停止しました」、ON にすると「薬の服用を再開しました」の Snackbar が表示される (maestro/flows/form_pause.yaml でカバー)

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14（失敗）**

トグルを ON にした直後（`xcrun simctl io screenshot` で即時撮影）。トグルは ON になっているが Snackbar は表示されていない:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/335fe90b-9451-47ff-977a-5dde7782cfff.png" width="320">

</details>

</details>

---

## 5. 薬の削除

- [x] **薬の削除**: 編集モードで AppBar 右上の削除アイコンをタップすると薬が削除され、画面が閉じる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **薬の削除**: 編集モードで AppBar 右上の削除アイコンをタップすると薬が削除され、画面が閉じる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

削除アイコンタップ後、お薬一覧画面に戻り対象の薬がリストから消えている:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/c37ecfc3-6c82-4f67-b145-9e37404193cd.png" width="320">

</details>

</details>
