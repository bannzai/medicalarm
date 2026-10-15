---
feature: medicine_form
verification: mobile-mcp,maestro
last_verified_commit: ebcfd81fb3b432696218ceb32ea3df0434611c3b
last_verified_at: 2026-10-16
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

**確認日: 2026-10-15**
新規・編集のどちらで開いても AppBar に「お薬登録画面」と表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/677bb164-60d2-490a-872d-17b79a4118eb-mf09-new-defaults-validation.jpg" width="320">

</details>

### **新規登録時の初期値**: 新規で開くと薬の名前が空、服用頻度が「毎日」、服用開始日が当日、服用スケジュールが空、服用者が「自分」で表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
服薬画面の「お薬を追加」から開くと、薬の名前が空、服用頻度「毎日」、服用開始日が当日 (2026/10/15)、服用間隔「なし」、服用スケジュールが空、服用者「自分」で表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/677bb164-60d2-490a-872d-17b79a4118eb-mf09-new-defaults-validation.jpg" width="320">

</details>

### **編集時のプリフィル**: 既存の薬を編集で開くと各項目に登録済みの値が入り、AppBar 右上に削除アイコンが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
既存の薬を服薬画面の薬名タップとお薬一覧の編集アイコンの両方から開くと、薬名・服用頻度・服用開始日・服用間隔・スケジュールの時刻・メモ・メモ画像が入り、AppBar 右上に削除アイコンが表示された。容量欄だけは保存済みの値 (2tabs) が表示されなかった (#402。下の 2026-10-16 の確認で解消)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/41de6792-9b09-41e9-b6d6-d9636de009bf-mf04-pause-snackbar.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/5ff3e92e-4c21-4335-b478-b2d0bbe1662c-mf08-quantity-not-prefilled.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/2ddf2788-b69b-4e03-a59d-8f1dbc4d8b53-mf17-edit-memo-image.jpg" width="320">

**確認日: 2026-10-16** (#403 の後。main の ebcfd81f を simtunnel でビルドした iPhone 17 / iOS 26.5 の Simulator)
容量「1tab」を保存した薬をお薬一覧の編集アイコンから開くと、薬名・服用頻度・服用開始日・服用間隔・「服薬を有効にする」・スケジュールの時刻に加えて、容量欄にも「1tab」が入り、AppBar 右上に削除アイコンが表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/95fed0e5-08dd-472f-a763-b3fa4daa5634-a-42.jpg" width="320">

</details>

### **一時停止トグルの表示条件**: 「服薬を有効にする」トグルは編集モードのときのみ表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
新規で開いたフォームには「服薬を有効にする」トグルが無く、既存の薬の編集で開いたフォームにだけ表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/677bb164-60d2-490a-872d-17b79a4118eb-mf09-new-defaults-validation.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/41de6792-9b09-41e9-b6d6-d9636de009bf-mf04-pause-snackbar.jpg" width="320">

</details>

</details>

---

## 2. 入力項目

- [x] **薬の名前**: 「薬の名前」欄に最大50文字まで入力できる
- [x] **服用頻度**: 「服用頻度」行をタップすると服用頻度の設定画面（モーダル）が開き、選択した頻度が行に反映される
- [x] **服用開始日**: 「服用開始日」行をタップすると日付ピッカー（過去365日〜当日の範囲）が開き、選んだ日付が反映される
- [x] **服用間隔**: 「服用間隔」行（説明「前回の服用から最低限空ける時間」）は初期値が「なし」で、タップすると数値ピッカーが開く。選んだ時間が「{hours}時間以上」として反映され、0 を選ぶと「なし」に戻る (#81)
- [x] **服用スケジュールの追加**: 「服用スケジュールを追加」で時刻10:00のスケジュール行が追加される。上限到達時は「服用スケジュールは{count}つまで登録できます。」が表示され追加ボタンが無効化される
- [x] **服用スケジュールの編集・削除**: スケジュール行で時刻・容量を編集でき、ゴミ箱アイコンで行を削除できる。歯車アイコンで通知設定画面へ遷移する
- [x] **その他情報**: 服用者の選択、メモ（最大300文字）、メモ画像の設定ができる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **薬の名前**: 「薬の名前」欄に最大50文字まで入力できる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「QA Medicine」を入力すると欄の下に 11/50 と表示され、上限 50 文字のカウンターが入力に追従した。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/41de6792-9b09-41e9-b6d6-d9636de009bf-mf04-pause-snackbar.jpg" width="320">

</details>

### **服用頻度**: 「服用頻度」行をタップすると服用頻度の設定画面（モーダル）が開き、選択した頻度が行に反映される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「服用頻度」行をタップすると服用頻度の設定画面が開き、「X日ごと」を選んで保存すると行の表示が「1日ごと」に変わった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/ddbe6beb-a08c-428a-9bf1-1691a7139df6-mff01-daily.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/5f2caa1b-deff-4b3e-b470-1cac71118026-mff05-reflected.jpg" width="320">

</details>

### **服用開始日**: 「服用開始日」行をタップすると日付ピッカー（過去365日〜当日の範囲）が開き、選んだ日付が反映される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「服用開始日」行をタップすると日付ピッカーが開き、今日 (10/15) より後の日付はグレーで選べなかった。10/10 を選んで OK を押すと行が 2026/10/10 に変わった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/198dbf85-8635-4108-8760-18df985c8577-mf06-date-picker.jpg" width="320">

</details>

### **服用スケジュールの追加**: 「服用スケジュールを追加」で時刻10:00のスケジュール行が追加される。上限到達時は「服用スケジュールは{count}つまで登録できます。」が表示され追加ボタンが無効化される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「服用スケジュールを追加」で 10:00 の行が追加された。2 件になると「服用スケジュールは2つまで登録できます。」と「プレミアムプランで上限を5に増やす」が表示され、追加ボタンは押せない表示になった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/67f18292-7f72-435a-8889-cf58006db7b5-mf07-schedule-added-limit.jpg" width="320">

</details>

### **服用スケジュールの編集・削除**: スケジュール行で時刻・容量を編集でき、ゴミ箱アイコンで行を削除できる。歯車アイコンで通知設定画面へ遷移する

- 時刻ピッカー（`AppTimePicker`）は完了ボタンの外側（ピッカー本体領域）を1px でもタップすると `Navigator.pop(context)`（結果 null）でキャンセル扱いになる。mobile-mcp 等で座標タップする場合は完了ボタンの中心座標を正確に狙うこと。歯車アイコン・ゴミ箱アイコンなど48x48の`IconButton`も同様に、境界座標ではなく中心をタップしないと反応しないことがある

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
時刻をタップして 08:00 → 09:00 に変えられ、ゴミ箱で 19:00 の行を消せ、歯車で通知設定画面に進めた。容量は、改行して確定した「2tabs」はお薬一覧に表示されたが、改行せずに保存した容量は保存されず、保存済みの容量 (2tabs) がある薬を編集で開くと容量欄が空だった (#402。下の 2026-10-16 の確認で解消)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/e75cc4dd-01ee-4beb-9a09-8c39d619b02b-mf02-time-edited.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/67f18292-7f72-435a-8889-cf58006db7b5-mf07-schedule-added-limit.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/356b6dc2-2bd7-4cad-ad03-f6eaf5d8eee3-ss01-schedule-setting.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/5ff3e92e-4c21-4335-b478-b2d0bbe1662c-mf08-quantity-not-prefilled.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/9cdde3fe-3d57-4850-ae42-654fb5da5364-med05-memo-quantity.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/2ddf2788-b69b-4e03-a59d-8f1dbc4d8b53-mf17-edit-memo-image.jpg" width="320">

**確認日: 2026-10-15** (#402。容量欄の保存と編集時の初期表示)

容量に「1錠」を入力し、Return を押さずに保存をタップ:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/6acc7e26-bcef-44ff-89dc-dac4ca163635-1-typed-no-return.jpg" width="320">

お薬一覧のカードに保存した容量「1錠」が表示される:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/3f316bc0-0dac-447e-875b-a59ab3212abc-2-medicine-list.jpg" width="320">

編集で開くと容量欄に保存済みの「1錠」が初期表示される:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/802974fc-6e36-41d7-9ea3-0d754fab719c-3-edit-prefilled.jpg" width="320">

**確認日: 2026-10-16** (#403 のマージ後の main の ebcfd81f を simtunnel でビルドした iPhone 17 / iOS 26.5 の Simulator)
お薬一覧から新規登録を開き、追加したスケジュール行の容量欄に「1tab」を入力して、改行 (Return) を押さずに「保存」をタップした。お薬一覧のカードに容量「1tab」が表示され、編集で開くと容量欄に「1tab」が入っていた。アプリを起動し直した後の服薬画面にも「1tab」が表示された。時刻の編集・ゴミ箱での行の削除・歯車からの遷移は #403 で変わっていないため、2026-10-15 の確認による。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/f87ff1c0-c5db-4da5-9b99-79aaf7ee16ac-a-40.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/2374bf56-0ad1-4693-9477-24c5e8abfc95-a-41.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/95fed0e5-08dd-472f-a763-b3fa4daa5634-a-42.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/5a238fb8-3b52-4ea3-b3f6-7ffef968c3a3-a-45.jpg" width="320">

</details>

### **その他情報**: 服用者の選択、メモ（最大300文字）、メモ画像の設定ができる

- メモ画像追加ボタン（カメラアイコン）は `Row` の中で `crossAxisAlignment` が中央揃えのため、複数行メモ欄の垂直方向の中央あたりに位置する（メモ欄の上端ではない）。座標タップ時は注意する

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「その他」セクションに服用者の行とメモ欄 (0/300 → 11/300) が表示された。カメラのボタンで「カメラ」「フォトライブラリ」の選択肢が出て、フォトライブラリから写真を選ぶとボタンがその写真のサムネイルに変わった。保存した後に編集で開くと、メモとメモ画像が残っていた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/d3d23233-cb33-4187-b1d5-b864b68af859-mf10-other-info.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/eac68b33-6884-4258-93cc-c6a7a3e14526-mf12-image-picker.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8f77c3e9-3ae6-48d6-b645-f2d680c49c87-mf14-photo-library2.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/1409d8d4-eb2e-4581-bcd7-d74acada181f-mf16-image-after-wait.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/2ddf2788-b69b-4e03-a59d-8f1dbc4d8b53-mf17-edit-memo-image.jpg" width="320">

</details>

### **服用間隔**: 「服用間隔」行（説明「前回の服用から最低限空ける時間」）は初期値が「なし」で、タップすると数値ピッカーが開く。選んだ時間が「{hours}時間以上」として反映され、0 を選ぶと「なし」に戻る (#81)

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「服用間隔」行 (説明「前回の服用から最低限空ける時間」) の初期値は「なし」で、タップすると数値ピッカーが開いた。3 を選ぶと「3時間以上」と表示され、続けて 0 を選ぶと「なし」に戻った。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/26cef2f6-b5ad-45a9-bd5a-5463250c683e-mf01-form-prefilled.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/3a4d6ce4-acc3-45d7-9db6-621b2ffdd323-mf03-interval-3h.jpg" width="320">

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

**確認日: 2026-10-15**
新規で開いた直後 (名前が空・スケジュール 0 件) は「名前と服用スケジュールを入力してください」が表示され、保存ボタンは押せない表示だった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/677bb164-60d2-490a-872d-17b79a4118eb-mf09-new-defaults-validation.jpg" width="320">

</details>

### **保存**: 名前とスケジュールが揃うと保存ボタンが有効になり、タップすると薬が登録／更新されて画面が閉じる (maestro/flows/register_and_pause.yaml でカバー)

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
名前とスケジュールをそろえて「保存」をタップすると画面が閉じ、新規登録では服薬画面に薬のカードが追加され、編集では服用者・時刻の変更が服薬画面のカードに反映された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/f3ce287f-706d-4159-a8b9-ca62991f221c-ob14-registered.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/9544eb73-e069-459e-a67f-680f55c0f62a-m06-updated-cards.jpg" width="320">

</details>

</details>

---

## 4. 服薬の一時停止トグル（編集モード）

- [x] **一時停止トグルの説明**: 「服薬を有効にする」「オフにすると服薬画面・通知から除外されます」が表示される
- [x] **一時停止／再開の切替**: トグルを OFF にすると「薬の服用を一時停止しました」、ON にすると「薬の服用を再開しました」の Snackbar が表示される (maestro/flows/form_pause.yaml でカバー)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **一時停止トグルの説明**: 「服薬を有効にする」「オフにすると服薬画面・通知から除外されます」が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
編集で開いたフォームに「服薬を有効にする」「オフにすると服薬画面・通知から除外されます」が表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/41de6792-9b09-41e9-b6d6-d9636de009bf-mf04-pause-snackbar.jpg" width="320">

</details>

### **一時停止／再開の切替**: トグルを OFF にすると「薬の服用を一時停止しました」、ON にすると「薬の服用を再開しました」の Snackbar が表示される (maestro/flows/form_pause.yaml でカバー)

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
編集で開いたフォーム (モーダル) でトグルを OFF にすると「薬の服用を一時停止しました」、ON に戻すと「薬の服用を再開しました」の SnackBar がモーダルの前面に表示された (#245 の修正を確認)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/41de6792-9b09-41e9-b6d6-d9636de009bf-mf04-pause-snackbar.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/14bb4907-cabc-476c-bdb6-cc33402ce8c7-mf05-resume-snackbar.jpg" width="320">

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

**確認日: 2026-10-15**
編集モードの AppBar 右上の削除アイコンをタップすると画面が閉じ、その薬 (QA Medicine) はお薬一覧・服薬画面から消えた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/5f3c1dc6-6031-4ab4-8aa0-07a06499e75d-med02-list-two.jpg" width="320">

</details>

</details>
