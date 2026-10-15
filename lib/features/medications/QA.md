---
feature: medications
verification: mobile-mcp
last_verified_commit: b28392fae518a7b8dc861588de798f90678346d6
last_verified_at: 2026-10-15
---

# medications QA

## 1. 服薬一覧の表示

- [x] **AppBar タイトル**: 上段に「お薬」、下段に表示中の週の日付範囲（例: `07/08 - 07/14`）が表示される
- [x] **週カレンダー**: 画面上部に週表示カレンダーが表示され、選択中の日付が判別できる
- [x] **本日バッジ**: カレンダー下に選択日を示すバッジ（TodayBadge）が表示される
- [x] **服薬グループの表示**: 選択日に服用予定の薬が「時刻＋服用者」ごとのカードにまとめて表示され、カードは時刻の昇順で並ぶ
- [x] **カード内容**: 各カードに時刻（プライマリカラー・太字）、服用者名、薬名と数量メモの行が表示される
- [x] **予定なしの日**: 服用予定が無い日はカードが1件も表示されない

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **AppBar タイトル**: 上段に「お薬」、下段に表示中の週の日付範囲（例: `07/08 - 07/14`）が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
上段に「お薬」、下段に表示中の週の範囲「10/11 - 10/17」が表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8d0d68de-fd86-44d6-aa03-7c00d31447a6-m01-home-cards.jpg" width="320">

</details>

### **週カレンダー**: 画面上部に週表示カレンダーが表示され、選択中の日付が判別できる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
上部に週表示のカレンダーが表示され、選択中の 15 が丸で強調された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8d0d68de-fd86-44d6-aa03-7c00d31447a6-m01-home-cards.jpg" width="320">

</details>

### **本日バッジ**: カレンダー下に選択日を示すバッジ（TodayBadge）が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
カレンダーの下に選択日のバッジ「10/15」が表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8d0d68de-fd86-44d6-aa03-7c00d31447a6-m01-home-cards.jpg" width="320">

</details>

### **服薬グループの表示**: 選択日に服用予定の薬が「時刻＋服用者」ごとのカードにまとめて表示され、カードは時刻の昇順で並ぶ

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
服用予定の薬が「時刻＋服用者」ごとのカードにまとまり、12:00 → 19:00 (編集後は 10:00 → 12:00) と時刻の昇順で並んだ。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8d0d68de-fd86-44d6-aa03-7c00d31447a6-m01-home-cards.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/9544eb73-e069-459e-a67f-680f55c0f62a-m06-updated-cards.jpg" width="320">

</details>

### **カード内容**: 各カードに時刻（プライマリカラー・太字）、服用者名、薬名と数量メモの行が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
各カードに時刻 (プライマリカラー・太字)、服用者名、薬名の行が表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8d0d68de-fd86-44d6-aa03-7c00d31447a6-m01-home-cards.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/830f4cae-a115-4fd8-af93-3946d74e7887-sync02-a-both-records.jpg" width="320">

</details>

### **予定なしの日**: 服用予定が無い日はカードが1件も表示されない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
服用開始日 (10/15) より前の 10/14 を選ぶとカードが 1 件も表示されなかった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/47ec725c-d1a0-4085-a19b-9eb00474e2dd-m05-no-schedule-day.jpg" width="320">

</details>

</details>

---

## 2. 日付の切り替え

- [x] **週送り**: 週カレンダーを左右にページ送りすると AppBar の日付範囲表示が対象週に更新される
- [x] **日付選択**: カレンダー上の日付をタップすると、その日付の服薬グループ一覧に切り替わる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **週送り**: 週カレンダーを左右にページ送りすると AppBar の日付範囲表示が対象週に更新される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
週カレンダーを左へスワイプすると次の週 (18〜24) に切り替わり、AppBar の範囲が「10/18 - 10/24」に変わった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/ec83b804-6668-41e1-bc3c-470acd1896ba-m04-next-week.jpg" width="320">

</details>

### **日付選択**: カレンダー上の日付をタップすると、その日付の服薬グループ一覧に切り替わる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
カレンダーの日付 (17・14) をタップすると、その日付の服薬グループ一覧とバッジに切り替わった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/cf82c6ed-7117-459c-972d-85195ab83236-m03-future-disabled.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/47ec725c-d1a0-4085-a19b-9eb00474e2dd-m05-no-schedule-day.jpg" width="320">

</details>

</details>

---

## 3. 服用の記録

- [x] **チェックで記録**: 薬の行のチェックボックスをオンにすると服用記録が保存され、チェック状態が維持される
- [x] **チェック解除で取消の記録**: チェックボックスをオフにすると取消(revert)が追記され、未チェック表示になる。SnackBar の「元に戻す」でチェック済みに戻せる
- [x] **未来日の無効化**: 選択日が今日より後（未来）の場合、チェックボックスは操作不可（disabled）になる
- [x] **薬名タップで編集**: 薬名をタップすると、その薬の編集フォーム（お薬登録シート）が開く
- [x] **服用間隔の注意**: お薬登録フォームで服用間隔（「{hours}時間以上」）を設定した薬は、前回の服用から設定時間が空いていない状態で別のスケジュールをチェックすると「服用間隔が空いていません」ダイアログが表示される。「キャンセル」では記録されず、「記録する」で記録される (#81)
  - 自動化: manual (同じ薬に 2 つのスケジュールを登録し、1 つ目をチェックした直後に 2 つ目をチェックして確認する)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **チェックで記録**: 薬の行のチェックボックスをオンにすると服用記録が保存され、チェック状態が維持される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
12:00 の QA Medicine のチェックボックスをオンにすると「12:09 服用済」と表示され、チェック状態が維持された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/10487a52-caa4-4c79-8268-b7fb18a54601-m02-checked.jpg" width="320">

</details>

### **チェック解除で取消の記録**: チェックボックスをオフにすると取消(revert)が追記され、未チェック表示になる。SnackBar の「元に戻す」でチェック済みに戻せる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
19:00 のチェックを外すと未チェック表示になり「服薬記録を取り消しました」と「元に戻す」の SnackBar が表示され、履歴に取消のカードが並んだ。08:00 のチェックを外した直後に「元に戻す」をタップすると、元の記録時刻 (20:17 服用済) のチェック済み表示に戻った。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/31aaf02d-c352-4386-9363-a35719ed1dd8-md03-uncheck-snackbar.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/e483bc23-6ef3-407f-96fc-7c92b96a3525-md05-undo-before.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/4c511bf9-8c20-47f3-920c-4db6f6707897-md05-undo-after.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/7ee6e842-142d-4b66-87f4-de2fb2851e28-mh01-revert-card.jpg" width="320">

</details>

### **未来日の無効化**: 選択日が今日より後（未来）の場合、チェックボックスは操作不可（disabled）になる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
未来日の 10/17 を選ぶとチェックボックスをタップしても未チェックのままだった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/cf82c6ed-7117-459c-972d-85195ab83236-m03-future-disabled.jpg" width="320">

</details>

### **薬名タップで編集**: 薬名をタップすると、その薬の編集フォーム（お薬登録シート）が開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
薬名「QA Medicine」をタップすると、その薬の編集モードのお薬登録画面が開いた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/41de6792-9b09-41e9-b6d6-d9636de009bf-mf04-pause-snackbar.jpg" width="320">

</details>

### **服用間隔の注意**: お薬登録フォームで服用間隔（「{hours}時間以上」）を設定した薬は、前回の服用から設定時間が空いていない状態で別のスケジュールをチェックすると「服用間隔が空いていません」ダイアログが表示される。「キャンセル」では記録されず、「記録する」で記録される (#81)

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
服用間隔を「6時間以上」にした薬で 08:00 をチェックした直後に 19:00 をチェックすると、「服用間隔が空いていません」「20:17 に服用済みです。前回の服用から6時間以上空ける設定になっています。それでも記録しますか？」のダイアログが表示された。「キャンセル」では未チェックのままで、もう一度チェックして「記録する」を選ぶと記録された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/fb8ce372-a740-4702-bd2d-a3640282a766-md01-dose-interval-warning.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/93c18282-26be-44a6-a55c-b47a26483472-md02-recorded-anyway.jpg" width="320">

</details>

</details>

---

## 4. 課金導線・広告

- [x] **バナー広告**: プレミアム未加入の場合、一覧上部に AdMob バナー広告が表示される
- [ ] **プレミアム未加入では広告あり / 加入では非表示**: プレミアム加入時は AdMob バナーが表示されない
  - ⏭️ スキップ: 未加入で広告が出ることは確認した (「バナー広告」の項目)。加入時に消えることはプレミアム会員の状態を Simulator で作れないため #340 の Sandbox 購入の項目に含めた
- [ ] **トライアル中バナー**: プロモーション期間中は「現在プレミアムトライアル中です」バナーが表示され、タップするとプレミアム紹介シートが開く
  - ⏭️ スキップ: プロモーション期間中の状態は、アカウント作成から 1 日以上の経過などの条件が要り、新規ユーザーの Simulator では作れない

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **バナー広告**: プレミアム未加入の場合、一覧上部に AdMob バナー広告が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
プレミアム未加入で、一覧の上部に AdMob の広告 (Test mode) が表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8d0d68de-fd86-44d6-aa03-7c00d31447a6-m01-home-cards.jpg" width="320">

</details>

### **プレミアム未加入では広告あり / 加入では非表示**: プレミアム加入時は AdMob バナーが表示されない

<details><summary>動作確認スクショ</summary>

⏭️ スキップ（上記チェックリストの理由欄を参照）

</details>

### **トライアル中バナー**: プロモーション期間中は「現在プレミアムトライアル中です」バナーが表示され、タップするとプレミアム紹介シートが開く

<details><summary>動作確認スクショ</summary>

⏭️ スキップ（上記チェックリストの理由欄を参照）

</details>

</details>

---

## 5. お薬の追加・編集導線

- [x] **追加ボタン**: 右下の FAB「お薬を追加」をタップするとお薬登録フォームが開く
- [x] **登録上限**: 登録数が上限に達すると「お薬は{count}つまで登録できます。」が表示され、追加ボタンが無効になる。上限メッセージは画面下部の不透明な帯の上に表示され、一覧のカードの文字と重ならない。末尾までスクロールすると末尾カードのチェックボックスが帯より上に完全に見える (#288)
  - 過去の発見: 上限到達時に警告文言が最後のカードの文字に重なる表示崩れ (issue #288)。`lib/components/fab/layout.dart` をボタン列を本文の下に置く構成に変えて解消した (PR #291)
- [x] **上限時の課金導線**: 上限到達かつプレミアム未加入の場合、「プレミアムプランで上限を{count}に増やす」リンクが表示され、タップでプレミアム紹介シートが開く
- [x] **編集アイコン**: AppBar 右上の編集アイコンをタップするとお薬一覧画面（MedicinesPage）に遷移する

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **追加ボタン**: 右下の FAB「お薬を追加」をタップするとお薬登録フォームが開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
下部の「お薬を追加」をタップすると新規のお薬登録フォームが開いた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/677bb164-60d2-490a-872d-17b79a4118eb-mf09-new-defaults-validation.jpg" width="320">

</details>

### **登録上限**: 登録数が上限に達すると「お薬は{count}つまで登録できます。」が表示され、追加ボタンが無効になる。上限メッセージは画面下部の不透明な帯の上に表示され、一覧のカードの文字と重ならない。末尾までスクロールすると末尾カードのチェックボックスが帯より上に完全に見える (#288)

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
薬を 2 件登録すると「お薬は2つまで登録できます。」が表示され、「お薬を追加」ボタンはグレーで押せない表示になった。末尾までスクロールすると、上限の文言は下部の帯の上に表示され、末尾のカードのチェックボックスは帯より上に完全に見えた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/82e69638-d73a-406a-bd89-010512186e83-m07-limit-band.jpg" width="320">

</details>

### **上限時の課金導線**: 上限到達かつプレミアム未加入の場合、「プレミアムプランで上限を{count}に増やす」リンクが表示され、タップでプレミアム紹介シートが開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
薬を 2 件登録すると服薬画面に「プレミアムプランで上限を10に増やす」が表示され、タップするとプレミアム紹介シートが開いた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/dc4f59da-1768-476d-bf67-37d395070ba7-med07-limit.jpg" width="320">

</details>

### **編集アイコン**: AppBar 右上の編集アイコンをタップするとお薬一覧画面（MedicinesPage）に遷移する

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
AppBar 右上の編集アイコンをタップするとお薬一覧画面に遷移した。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/5f3c1dc6-6031-4ab4-8aa0-07a06499e75d-med02-list-two.jpg" width="320">

</details>

</details>

---

## 6. グループ切替チップ（#241 グループ機能）

- [x] 所属グループが 1 つの間、ホーム上部にチップが表示されない
- [x] 2 グループ以上でホーム上部に切替チップが表示され、選択中がハイライトされる
- [x] チップで切り替えると表示される薬・記録がそのグループのものに切り替わる
- [x] 切替後にアプリを再起動しても選択したグループが維持される（defaultGroupID 永続化）

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### 所属グループが 1 つの間、ホーム上部にチップが表示されない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
所属グループが 1 つのユーザー (A) のホームにはグループ切替チップが表示されなかった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8d0d68de-fd86-44d6-aa03-7c00d31447a6-m01-home-cards.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/de917326-27e9-45fa-afcd-6a9ef8eba2e4-sync01-a-sees-c-record.jpg" width="320">

</details>

### 2 グループ以上でホーム上部に切替チップが表示され、選択中がハイライトされる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
自分のグループと参加先の 2 グループに所属する B のホーム上部にチップが 2 つ並び、選択中のチップがグレーで強調された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/4c0d7322-84c6-4150-8b51-aeb4333732a3-c01-medications-joined.jpg" width="320">

</details>

### チップで切り替えると表示される薬・記録がそのグループのものに切り替わる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
マイグループのチップでは Memo Med・Second Med が表示され、作成した「Care」のチップに切り替えると薬が 1 件も無い表示に切り替わった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/70c08a72-d6ab-47bc-ae7e-0b86e04fca5d-gc10-home-not-switched.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/603ad4b3-ecc9-4cd5-82f8-1ecbc63eaebf-m08-chip-care.jpg" width="320">

</details>

### 切替後にアプリを再起動しても選択したグループが維持される（defaultGroupID 永続化）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「Care」に切り替えた状態でアプリを終了して起動し直すと、「Care」のチップが選択されたままだった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/36991f7e-b918-412a-9a21-5e03d0572398-m09-chip-persisted.jpg" width="320">

</details>

</details>

---

## 7. 服用者の識別色アバターと記録者表示（#277）

- [x] 時刻グループカードのヘッダーで、服用者名の先頭に識別色の円形アバター（先頭 1 文字）が表示される
- [x] 服用者ごとにアバターの色が分かれ、同一服用者は履歴画面でも同じ色になる
- [x] 自分が記録した服用済み行には記録者名が表示されない（記録時刻のみ）
- [x] 他メンバーが記録した服用済み行に「◯◯が記録」が併記される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### 時刻グループカードのヘッダーで、服用者名の先頭に識別色の円形アバター（先頭 1 文字）が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
カードのヘッダーで、服用者名「自分」の前に識別色の円形アバター (「自」) が表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8d0d68de-fd86-44d6-aa03-7c00d31447a6-m01-home-cards.jpg" width="320">

</details>

### 服用者ごとにアバターの色が分かれ、同一服用者は履歴画面でも同じ色になる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「新しい服用者」は青、「自分」は茶色のアバターで色が分かれ、「自分」は履歴画面でも同じ茶色だった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/9544eb73-e069-459e-a67f-680f55c0f62a-m06-updated-cards.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/82e69638-d73a-406a-bd89-010512186e83-m07-limit-band.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/7ee6e842-142d-4b66-87f4-de2fb2851e28-mh01-revert-card.jpg" width="320">

</details>

### 自分が記録した服用済み行には記録者名が表示されない（記録時刻のみ）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
自分でチェックした行には記録時刻 (12:09 服用済) だけが表示され、記録者名は表示されなかった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/10487a52-caa4-4c79-8268-b7fb18a54601-m02-checked.jpg" width="320">

</details>

### 他メンバーが記録した服用済み行に「◯◯が記録」が併記される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
A の画面で B が記録した行に「13:36 服用済 · メンバーさんが記録」、B の画面で A が記録した行に「13:37 服用済 · Momさんが記録」と併記された (#253 で失敗していた共有の記録が消えないことも確認)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/de917326-27e9-45fa-afcd-6a9ef8eba2e4-sync01-a-sees-c-record.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/e96697fd-a474-47a8-9e90-0b8b94abe911-sync03-c-both-records.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/303c210a-1c2f-46d1-bb58-9b45b37a3336-sync06-c-name-reflected.jpg" width="320">

</details>

</details>

---

## 8. 白文字を載せる塗り面のコントラスト（#287）

- [x] **AppBar の塗り**: 服薬画面・お薬一覧の AppBar が `AppColors.primaryFilled`（#BA4F49。白文字と 4.88:1）で塗られ、白のタイトル・アイコンが読める
- [x] **週カレンダーの選択円**: 選択中の日付の丸背景が primaryFilled で、白の日付数字が読める
- [x] **主ボタン**: 「お薬を追加」FAB とお薬登録フォームの「保存」ボタンの背景が primaryFilled で、白のラベルが読める
- [x] **プレミアム紹介シートのヘッダー・割引バッジ**: ヘッダー背景と「月額より{percent}%OFF」バッジが primaryFilled で塗られる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **AppBar の塗り**: 服薬画面・お薬一覧の AppBar が `AppColors.primaryFilled`（#BA4F49。白文字と 4.88:1）で塗られ、白のタイトル・アイコンが読める

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
服薬画面・お薬一覧の AppBar が赤茶色 (primaryFilled) で塗られ、白のタイトル・アイコンが読めた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8d0d68de-fd86-44d6-aa03-7c00d31447a6-m01-home-cards.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/5f3c1dc6-6031-4ab4-8aa0-07a06499e75d-med02-list-two.jpg" width="320">

</details>

### **週カレンダーの選択円**: 選択中の日付の丸背景が primaryFilled で、白の日付数字が読める

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
選択中の日付 (15) の丸背景が primaryFilled で、白の数字が読めた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8d0d68de-fd86-44d6-aa03-7c00d31447a6-m01-home-cards.jpg" width="320">

</details>

### **主ボタン**: 「お薬を追加」FAB とお薬登録フォームの「保存」ボタンの背景が primaryFilled で、白のラベルが読める

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「お薬を追加」とお薬登録フォームの「保存」の背景が primaryFilled で、白のラベルが読めた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8d0d68de-fd86-44d6-aa03-7c00d31447a6-m01-home-cards.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/677bb164-60d2-490a-872d-17b79a4118eb-mf09-new-defaults-validation.jpg" width="320">

</details>

### **プレミアム紹介シートのヘッダー・割引バッジ**: ヘッダー背景と「月額より{percent}%OFF」バッジが primaryFilled で塗られる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
今回の simtunnel では offerings を取得でき、プレミアム紹介シートのヘッダー背景と「月額より35%OFF」のバッジが primaryFilled で塗られていることを確認した。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/a3a225e3-5805-44a8-84af-ff2297e8432c-pi01-paywall.jpg" width="320">

</details>

</details>

---

## 既知の制約・発見事項

- **AdMob native ad validator オーバーレイが操作をブロックする**: 開発ビルドで表示される AdMob native ad validator の警告（root QA.md 参照）は、画面座標 x:0-335 y:355-510 に固定表示され、この範囲に重なる要素（チェックボックス・ボタン等）へのタップを奪う。回避策: (1) 対象要素がこの範囲外（y>510）に来るよう、事前にスケジュールや薬を追加してカードの並び順を調整してから操作する。(2) 服薬画面（AdMob 広告を表示する画面）から直接開いたフォームにはオーバーレイが残るが、お薬一覧画面（MedicinesPage、広告なし）経由でフォームを開けばオーバーレイの影響を受けない
- **FAB 警告文言と最終カードの表示重なり (解消済み)**: 上限到達時に `lib/components/fab/layout.dart` の固定 FAB エリアがスクロール領域の最終カードに重なる表示崩れ。issue #288 として起票され、PR #291 でボタン列を本文の下に置く構成に変えて解消した (上記「登録上限」項目の 2026-09-08 のエビデンス参照)

## 未登録の服薬時刻

- [x] **仮カードの表示と保持**: オンボーディングを「あとで」で完了すると回答回数に応じた時刻の仮カードを表示する。服用者はデフォルトの服用者で、薬名と服薬チェック欄は持たない。再起動しても残る
  - 自動化: auto (maestro/flows/onboarding_medication_plan.yaml)
- [x] **仮カードから登録**: お薬を追加から時刻を初期入力したフォームへ進める。登録後は全仮カードが消えて実際の薬のカードになる
  - 自動化: auto (maestro/flows/onboarding_medication_plan.yaml)
- [x] **時刻ごとの削除**: 仮カードの削除ボタンでその時刻と通知だけを削除し、残りの時刻は保持する。最後のカードを削除すると再起動後も表示されない
  - 自動化: auto (maestro/flows/onboarding_medication_plan_delete.yaml)
- [x] **登録案内の通知**: 通知一覧に仮カードと同数の薬登録案内が表示される。Critical Alertや服薬記録のアクションは持たない。削除・薬登録後に対象の通知が消える
  - 自動化: auto (maestro/flows/onboarding_medication_plan.yaml / onboarding_medication_plan_delete.yaml)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **仮カードの表示と保持**: オンボーディングを「あとで」で完了すると回答回数に応じた時刻の仮カードを表示する。服用者はデフォルトの服用者で、薬名と服薬チェック欄は持たない。再起動しても残る

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
オンボーディングを「あとで」で終えると、2回の回答に応じた 08:00・19:00 の仮カードが表示された。服用者はデフォルトの服用者で、薬名と服薬チェック欄は無く、アプリを起動し直しても残った。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/c0d369a6-655f-4e1e-9791-bff08015c6ab-ob11-placeholder-cards.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/d8e1b0cd-a3d8-4a20-8ad9-882f872abbab-ob12-relaunch.jpg" width="320">

</details>

### **仮カードから登録**: お薬を追加から時刻を初期入力したフォームへ進める。登録後は全仮カードが消えて実際の薬のカードになる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
仮カードの「お薬を追加」から時刻入りのフォームへ進み、登録すると仮カードがすべて消えて実際の薬のカードになった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/26cef2f6-b5ad-45a9-bd5a-5463250c683e-mf01-form-prefilled.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/f3ce287f-706d-4159-a8b9-ca62991f221c-ob14-registered.jpg" width="320">

</details>

### **時刻ごとの削除**: 仮カードの削除ボタンでその時刻と通知だけを削除し、残りの時刻は保持する。最後のカードを削除すると再起動後も表示されない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
仮カードの「削除する」でその時刻のカードだけが消え、残りの時刻のカードは残った (別の新規ユーザー 2 人で確認)。最後のカードの削除と再起動は今回は行っていない (2026-09-08 の記録で確認済み)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/c35f0f4d-3b9b-486a-aef2-6423baaf748b-ob17-placeholder-deleted.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/c96b940e-c3c9-4a2d-9bed-a56638a3df9a-b02-after-delete.jpg" width="320">

</details>

### **登録案内の通知**: 通知一覧に仮カードと同数の薬登録案内が表示される。Critical Alertや服薬記録のアクションは持たない。削除・薬登録後に対象の通知が消える

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
DEBUG の Local Notifications に、仮カード 2 枚に対して「お薬を追加」の通知が 2 件 (payload 空) 予約されていた。仮カードを 1 枚削除すると 1 件に減った。薬を登録したユーザーでは、薬登録案内の通知は無く、服薬リマインダー (お薬の時間です / 服薬記録をつけ忘れていませんか？) だけが予約されていた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/a75420f1-e111-4992-b53a-fe054aa002da-b01-placeholder-notifications.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/88f4ae74-453b-455e-aef7-8cf1603257d7-b03-notifications-after-delete.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/0057582a-e389-4285-886a-8c78f2b849df-st08-local-notifications.jpg" width="320">

</details>

</details>

## 2026-09-08の追加実装の検証

対象コード: `c4e57849`。iOS 26.5の専用シミュレータで今回の追加部分を検証した。既存項目全体は再検証していないため、frontmatterの最終検証コミットは更新していない。

- 2回を回答し、ペイウォールを閉じると08:00・19:00の登録案内が表示された。「あとで」で仮カードを表示し、再起動後も保持された
- 仮カードから開いた登録フォームに08:00・19:00が初期入力された。保存せず閉じても仮カードが残った。時刻を編集する操作と、登録案内から直接フォームへ進む経路は今回のシミュレータでは未検証
- 薬名「Onboarding QA」の保存後に実薬のカードと服薬チェック欄が表示され、仮カードが消えた。通知一覧も実薬の通知に切り替わった
- 別の専用シミュレータで08:00だけを削除すると19:00が残り、最後の時刻の削除と再起動後は仮カードと通知が消えた。通知一覧で薬登録案内の文面を確認した。指定時刻の実際の通知受信は未検証
- Maestroの通し実行は登録側が保存ボタン検出、削除側が広告オーバーレイ等でexit 1。分割した追検証は登録後・通知解除と最後の手動削除・再起動をそれぞれexit 0で確認した。通しテスト成功とは扱わない
- ローカルログ: `tmp/onboarding-followup-maestro-registration.log`、`tmp/onboarding-followup-maestro-registration-finish.log`、`tmp/onboarding-followup-maestro-delete-last-dismiss.log`
- 画像: https://github.com/bannzai/medicalarm/pull/273 の「今回の検証」へ添付
