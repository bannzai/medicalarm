---
feature: medicines
verification: mobile-mcp,maestro
last_verified_commit: 263630555ac273bca24b8c4df556f018b9a8578d
last_verified_at: 2026-10-16
---

# medicines QA

## 1. お薬一覧の表示

服薬画面 AppBar 右上の編集アイコン（ツールチップ「薬を編集」）→ お薬一覧に遷移する。(maestro/flows/full_pause_feature.yaml でカバー)

- [x] **AppBar タイトル**: AppBar に「お薬一覧」と表示される
- [x] **お薬カードの表示**: 登録済みの薬がカードで並び、各カードに薬名・服用者名・服用スケジュールの時刻が表示される
- [x] **容量メモ・メモの表示**: スケジュールに容量メモがある場合は時刻の右側に、薬にメモがある場合はカード下部に表示される
- [ ] **アーカイブ済みの除外**: archivedDateTime が設定された薬はお薬一覧に表示されない
  - ⏭️ スキップ: アプリに薬をアーカイブする操作が無く、archivedDateTime の付いた薬を画面操作では作れない。Firestore に直接書き込む準備は今回行っていない

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **AppBar タイトル**: AppBar に「お薬一覧」と表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
服薬画面の AppBar 右上の編集アイコンから開くと、AppBar に「お薬一覧」と表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/5f3c1dc6-6031-4ab4-8aa0-07a06499e75d-med02-list-two.jpg" width="320">

</details>

### **お薬カードの表示**: 登録済みの薬がカードで並び、各カードに薬名・服用者名・服用スケジュールの時刻が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
登録済みの薬がカードで並び、薬名・服用者名・スケジュールの時刻 (QA Medicine: 新しい服用者 / 12:00・10:00、QA Second: 自分 / 10:00) が表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8be022fe-907b-45c2-bde2-2bf09c65088e-med01-medicines-list.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/5f3c1dc6-6031-4ab4-8aa0-07a06499e75d-med02-list-two.jpg" width="320">

</details>

### **容量メモ・メモの表示**: スケジュールに容量メモがある場合は時刻の右側に、薬にメモがある場合はカード下部に表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
08:00 の容量に「2tabs」(改行で確定)、メモに「after meals」を入れて保存すると、お薬一覧のカードで 08:00 の右に「2tabs」、カード下部に「after meals」が表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/9cdde3fe-3d57-4850-ae42-654fb5da5364-med05-memo-quantity.jpg" width="320">

✅ 2026-10-15: 上記の不具合は #402 で修正済み (入力のたびに反映し、編集時に保存済みの値を初期表示する)。確認結果は `lib/features/medicine_form/QA.md` の「服用スケジュールの編集・削除」に記録した。

</details>

### **アーカイブ済みの除外**: archivedDateTime が設定された薬はお薬一覧に表示されない

<details><summary>動作確認スクショ</summary>

（未実行）

⏭️ スキップ: 上記チェックリストの通り、アプリ内に archivedDateTime を設定する手段がないため検証不可

</details>

</details>

---

## 2. 薬の追加・編集への導線

- [x] **お薬を追加**: 画面下部の「お薬を追加」ボタンで新規のお薬登録画面（モーダル）が開く
- [ ] **登録上限**: 登録数が上限に達すると「お薬は{count}つまで登録できます。」が表示され「お薬を追加」ボタンが押せなくなる。無料ユーザーには「プレミアムプランで上限を{count}に増やす」リンクが表示される。上限メッセージは画面下部の不透明な帯の上に表示され、カードの文字と重ならない。末尾までスクロールすると末尾カード右下の Switch が帯より上に完全に見える (#288)
  - ⏭️ スキップ: 上限の文言・リンク・追加ボタンの無効化と、文言がカードと重ならないことは確認したが、お薬一覧はカード 2 枚でスクロールせず、末尾までスクロールした時の Switch の見え方はこの画面では確かめられなかった
- [x] **カードの編集アイコン**: カード右上の編集アイコン（ツールチップ「薬を編集」）で対象の薬のお薬登録画面（編集モード）が開く

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **お薬を追加**: 画面下部の「お薬を追加」ボタンで新規のお薬登録画面（モーダル）が開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
お薬一覧の下部の「お薬を追加」をタップすると、空の新規お薬登録画面 (モーダル) が開いた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/fdff9733-855f-4377-a7d0-c92bdbb584af-med06-add-from-list.jpg" width="320">

</details>

### **登録上限**: 登録数が上限に達すると「お薬は{count}つまで登録できます。」が表示され「お薬を追加」ボタンが押せなくなる。無料ユーザーには「プレミアムプランで上限を{count}に増やす」リンクが表示される。上限メッセージは画面下部の不透明な帯の上に表示され、カードの文字と重ならない。末尾までスクロールすると末尾カード右下の Switch が帯より上に完全に見える (#288)

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
2 件目を登録すると、お薬一覧に「お薬は2つまで登録できます。」と「プレミアムプランで上限を10に増やす」が表示され、「お薬を追加」ボタンはグレーで押せない表示になった。文言はカードの文字・Switch と重ならなかった。カード 2 枚ではスクロールしないため、末尾までスクロールした時の確認はしていない (このため項目は ⏭️ にした)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/dc4f59da-1768-476d-bf67-37d395070ba7-med07-limit.jpg" width="320">

</details>

### **カードの編集アイコン**: カード右上の編集アイコン（ツールチップ「薬を編集」）で対象の薬のお薬登録画面（編集モード）が開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
カード右上の編集アイコン (識別子 medicine_edit_button) をタップすると、その薬の編集モードのお薬登録画面が開いた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8be022fe-907b-45c2-bde2-2bf09c65088e-med01-medicines-list.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/5ff3e92e-4c21-4335-b478-b2d0bbe1662c-mf08-quantity-not-prefilled.jpg" width="320">

</details>

</details>

---

## 3. 服薬の一時停止・再開（Switch）

Snackbar はデフォルトの表示時間が短く、`tapOn` → `screenshot` を別々のツール呼び出し（mobile-mcp 等）で行うと往復のレイテンシで表示が消えてから撮影されることが多い。maestro flow 内で `tapOn` → `extendedWaitUntil`（Snackbar 文言の出現待ち。ポーリングのため出現した時点で即座に返る）→ `takeScreenshot` の順に置くと、Firestore 書き込み完了前の空振り撮影を避けつつ表示時間内に確実に捕捉できる。`maestro/flows/qa_verify_switch_snackbar.yaml` に手順を残した（テスト薬の登録〜お薬一覧への遷移は flow 内で行うため単体実行可。`medicine_pause_switch` の Semantics identifier はカードごとに重複しており、テスト薬以外のカードがあると `tapOn: {id: ...}` が意図しないカードを操作する）。

- [ ] **Switch を OFF**: カード右下の Switch を OFF にすると「薬の服用を一時停止しました」の Snackbar が表示され、服薬画面からその薬が消える (maestro/flows/toggle_switch.yaml でカバー)
  - ⏭️ スキップ: SnackBar の表示は確認したが、服薬画面からその薬が消えることは今回見ていない
- [ ] **Switch を ON**: 一時停止中の Switch を ON に戻すと「薬の服用を再開しました」の Snackbar が表示され、服薬画面に薬が戻る (maestro/flows/resume_and_edit.yaml でカバー)
  - ⏭️ スキップ: SnackBar の表示は確認したが、服薬画面に薬が戻ることは今回見ていない

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **Switch を OFF**: カード右下の Switch を OFF にすると「薬の服用を一時停止しました」の Snackbar が表示され、服薬画面からその薬が消える (maestro/flows/toggle_switch.yaml でカバー)

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
カード右下の Switch を OFF にすると「薬の服用を一時停止しました」の SnackBar が表示された。服薬画面から消えることは見ていない (このため項目は ⏭️ にした)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/9b17c352-a618-4f37-9015-6f9f9e20ac60-med03-switch-off.jpg" width="320">

</details>

### **Switch を ON**: 一時停止中の Switch を ON に戻すと「薬の服用を再開しました」の Snackbar が表示され、服薬画面に薬が戻る (maestro/flows/resume_and_edit.yaml でカバー)

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
一時停止中の Switch を ON に戻すと「薬の服用を再開しました」の SnackBar が表示された。服薬画面に戻ることは見ていない (このため項目は ⏭️ にした)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/c5a5c8bb-7110-470d-b4f7-6c87e3215b89-med04-switch-on.jpg" width="320">

</details>

</details>
