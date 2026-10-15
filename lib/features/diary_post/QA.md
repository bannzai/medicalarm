---
feature: diary_post
verification: mobile-mcp
last_verified_commit: 263630555ac273bca24b8c4df556f018b9a8578d
last_verified_at: 2026-10-16
---

# diary_post QA

到達手順: カレンダータブの日付タイルをタップして開く日付詳細シート（CalendarDayDetailSheet）の「日記を書く」ボタンまたは編集アイコンをタップすると、その日付の日記投稿画面（DiaryPostPage）がフルスクリーンダイアログで開く。

## 1. 画面表示

- [x] **日付見出し**: 画面上部に対象日付が `YYYY年M月D日` 形式で表示される
- [x] **メモ入力欄**: プレースホルダー「メモ」の入力欄が表示され、既存の日記があればそのメモが初期表示される
- [x] **閉じるボタン**: AppBar 左上に閉じる（×）アイコンが表示される
- [x] **保存ボタン**: AppBar 右上に「保存」ボタンが表示される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **日付見出し**: 画面上部に対象日付が `YYYY年M月D日` 形式で表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
カレンダーの日付詳細シートの「日記を書く」から開くと、上部に「2026年10月15日」と表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/d9934582-2f31-4e27-ac53-d9a9fa430bbc-dp01-diary-post.jpg" width="320">

</details>

### **メモ入力欄**: プレースホルダー「メモ」の入力欄が表示され、既存の日記があればそのメモが初期表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
プレースホルダー「メモ」の入力欄が表示された。日記がある日に編集アイコンから開くと、保存済みのメモ (line one / line two) が初期表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/d9934582-2f31-4e27-ac53-d9a9fa430bbc-dp01-diary-post.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/00240202-43b3-45b6-a1b1-df4c5808cc38-cal07-records-and-revert.jpg" width="320">

</details>

### **閉じるボタン**: AppBar 左上に閉じる（×）アイコンが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
AppBar 左上に閉じる (×) アイコンが表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8ccd4316-8bf6-4cb5-946e-d00ce712867b-dp02-multiline-toolbar.jpg" width="320">

</details>

### **保存ボタン**: AppBar 右上に「保存」ボタンが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
AppBar 右上に「保存」ボタンが表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8ccd4316-8bf6-4cb5-946e-d00ce712867b-dp02-multiline-toolbar.jpg" width="320">

</details>

</details>

---

## 2. メモの入力

- [x] **複数行入力**: メモ欄は複数行入力に対応する
- [ ] **文字数上限**: メモは最大120文字まで入力でき、入力欄に文字数カウンターが表示される
  - ⏭️ スキップ: 文字数カウンター (0 文字で「残り 120 文字」、17 文字で 17/120) は確認したが、120 文字を超える入力はしていない
- [x] **キーボードツールバー**: 入力欄フォーカス時にキーボード上部へ「完了」ボタンを持つツールバーが表示され、タップでキーボードが閉じる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **複数行入力**: メモ欄は複数行入力に対応する

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
改行を含めて入力すると「line one」「line two」の 2 行で表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8ccd4316-8bf6-4cb5-946e-d00ce712867b-dp02-multiline-toolbar.jpg" width="320">

</details>

### **文字数上限**: メモは最大120文字まで入力でき、入力欄に文字数カウンターが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
入力欄の下に文字数カウンター (0 文字で「残り 120 文字」、17 文字で 17/120) が表示された。120 文字を超える入力はしていない (このため項目は ⏭️ にした)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/d9934582-2f31-4e27-ac53-d9a9fa430bbc-dp01-diary-post.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8ccd4316-8bf6-4cb5-946e-d00ce712867b-dp02-multiline-toolbar.jpg" width="320">

</details>

### **キーボードツールバー**: 入力欄フォーカス時にキーボード上部へ「完了」ボタンを持つツールバーが表示され、タップでキーボードが閉じる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
入力欄にフォーカスするとキーボードの上に「完了」が表示され、タップするとキーボードが閉じた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8ccd4316-8bf6-4cb5-946e-d00ce712867b-dp02-multiline-toolbar.jpg" width="320">

</details>

</details>

---

## 3. 保存・閉じる

- [x] **保存**: 「保存」をタップするとメモが日記として保存され、画面が閉じる
- [x] **閉じる**: 閉じる（×）アイコンをタップすると保存せずに画面が閉じる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **保存**: 「保存」をタップするとメモが日記として保存され、画面が閉じる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「保存」をタップすると画面が閉じ、日付詳細シートの日記セクションに保存したメモが表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/dcdb7857-1aef-41cf-b626-dd00894149dc-cal04-diary-saved.jpg" width="320">

</details>

### **閉じる**: 閉じる（×）アイコンをタップすると保存せずに画面が閉じる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
編集で開いて「 edited」を足した後に × で閉じると、シートの日記は「line one / line two」のまま変わらなかった (保存されていない)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/dcdb7857-1aef-41cf-b626-dd00894149dc-cal04-diary-saved.jpg" width="320">

</details>

</details>
