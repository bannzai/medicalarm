---
feature: medicines
verification: mobile-mcp,maestro
last_verified_commit: ceab6b15bfd78420f8bbb9a67bd045e58f0f4362
last_verified_at: 2026-07-14
---

# medicines QA

## 1. お薬一覧の表示

服薬画面 AppBar 右上の編集アイコン（ツールチップ「薬を編集」）→ お薬一覧に遷移する。(maestro/flows/full_pause_feature.yaml でカバー)

- [x] **AppBar タイトル**: AppBar に「お薬一覧」と表示される
- [x] **お薬カードの表示**: 登録済みの薬がカードで並び、各カードに薬名・服用者名・服用スケジュールの時刻が表示される
- [x] **容量メモ・メモの表示**: スケジュールに容量メモがある場合は時刻の右側に、薬にメモがある場合はカード下部に表示される
- [ ] **アーカイブ済みの除外**: archivedDateTime が設定された薬はお薬一覧に表示されない
  - ⏭️ スキップ: `archivedDateTime` を設定する UI 導線がアプリ内に存在しない（`lib/`・`firebase/` 全体を grep しても書き込み箇所はエンティティ定義と `activeMedicinesProvider` のフィルタ条件のみ）。Firestore への直接書き込みでの検証はアプリの動作確認の範囲を超えるためスキップ

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **AppBar タイトル**: AppBar に「お薬一覧」と表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/2ecb9f22-de81-4272-a53b-369219d4a983.png" width="320">

</details>

### **お薬カードの表示**: 登録済みの薬がカードで並び、各カードに薬名・服用者名・服用スケジュールの時刻が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/2ecb9f22-de81-4272-a53b-369219d4a983.png" width="320">

</details>

### **容量メモ・メモの表示**: スケジュールに容量メモがある場合は時刻の右側に、薬にメモがある場合はカード下部に表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/94dd70dc-462a-4ed5-9ed2-d66e26361062.png" width="320">

容量欄に「1錠」、薬メモに「QAメモテスト」を設定し、時刻右側とカード下部にそれぞれ表示されることを確認（テスト薬名: QAテスト薬A）。

⚠️ 動作確認中に発見した不具合: 容量欄（`MedicineScheduleQuantityMemoTextField`）は `onFieldSubmitted`（キーボード return/done 押下）でしか親の状態に反映されない実装で、他の欄（薬メモ等）と異なり `onChanged` を使っていない。入力後に return を押さず他要素をタップしてフォーカスを外すと、保存時に入力内容が破棄される。さらに編集画面を再度開いても容量欄は常に空欄で表示され、保存済みの値がプリフィルされない（`TextFormField` に `initialValue`/`controller` が設定されていないため）。GitHub issue 起票を試みたが `gh issue list` 等の確認コマンドが権限承認待ちでブロックされ、issue 作成の成否を確認できていない。詳細は本 QA セッションの完了報告を参照。

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
- [x] **登録上限**: 登録数が上限に達すると「お薬は{count}つまで登録できます。」が表示され「お薬を追加」ボタンが押せなくなる。無料ユーザーには「プレミアムプランで上限を{count}に増やす」リンクが表示される
- [x] **カードの編集アイコン**: カード右上の編集アイコン（ツールチップ「薬を編集」）で対象の薬のお薬登録画面（編集モード）が開く

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **お薬を追加**: 画面下部の「お薬を追加」ボタンで新規のお薬登録画面（モーダル）が開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/9a965121-c8cb-45ae-bd17-64cebcf4f30a.png" width="320">

上限に達した状態ではボタンが無効化されるため、登録数を一時的に1件へ減らした状態で確認した。

</details>

### **登録上限**: 登録数が上限に達すると「お薬は{count}つまで登録できます。」が表示され「お薬を追加」ボタンが押せなくなる。無料ユーザーには「プレミアムプランで上限を{count}に増やす」リンクが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/2ecb9f22-de81-4272-a53b-369219d4a983.png" width="320">

無料ユーザーの上限（2件）に到達した状態で「お薬は2つまで登録できます。」「プレミアムプランで上限を10に増やす」が表示され、「お薬を追加」ボタンが無効化されることを確認（`Medicine.maxCount`: free=2, premium=10）。

</details>

### **カードの編集アイコン**: カード右上の編集アイコン（ツールチップ「薬を編集」）で対象の薬のお薬登録画面（編集モード）が開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/7c03fe6a-18d4-451d-9c80-ad8fbc162516.png" width="320">

</details>

</details>

---

## 3. 服薬の一時停止・再開（Switch）

Snackbar はデフォルトの表示時間が短く、`tapOn` → `screenshot` を別々のツール呼び出し（mobile-mcp 等）で行うと往復のレイテンシで表示が消えてから撮影されることが多い。maestro flow 内で `tapOn` → `extendedWaitUntil`（Snackbar 文言の出現待ち。ポーリングのため出現した時点で即座に返る）→ `takeScreenshot` の順に置くと、Firestore 書き込み完了前の空振り撮影を避けつつ表示時間内に確実に捕捉できる。`maestro/flows/qa_verify_switch_snackbar.yaml` に手順を残した（テスト薬の登録〜お薬一覧への遷移は flow 内で行うため単体実行可。`medicine_pause_switch` の Semantics identifier はカードごとに重複しており、テスト薬以外のカードがあると `tapOn: {id: ...}` が意図しないカードを操作する）。

- [x] **Switch を OFF**: カード右下の Switch を OFF にすると「薬の服用を一時停止しました」の Snackbar が表示され、服薬画面からその薬が消える (maestro/flows/toggle_switch.yaml でカバー)
- [x] **Switch を ON**: 一時停止中の Switch を ON に戻すと「薬の服用を再開しました」の Snackbar が表示され、服薬画面に薬が戻る (maestro/flows/resume_and_edit.yaml でカバー)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **Switch を OFF**: カード右下の Switch を OFF にすると「薬の服用を一時停止しました」の Snackbar が表示され、服薬画面からその薬が消える (maestro/flows/toggle_switch.yaml でカバー)

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/ce4e07f9-a7a5-4d1d-973a-baeec8630442.png" width="320">

服薬画面のアクセシビリティツリー上でも Switch OFF 後にカードが表示されないことを確認（AdMob ネイティブ広告のテスト用オーバーレイが画面を覆っており、目視のスクリーンショットでは確認できなかったため `mobile_list_elements_on_screen` で確認）。

</details>

### **Switch を ON**: 一時停止中の Switch を ON に戻すと「薬の服用を再開しました」の Snackbar が表示され、服薬画面に薬が戻る (maestro/flows/resume_and_edit.yaml でカバー)

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/1a401d1a-978b-418f-9336-f6bddbdf039f.png" width="320">

服薬画面のアクセシビリティツリー上で Switch ON 後にカードが再表示されることを確認。

</details>

</details>
