---
feature: medicines
verification: mobile-mcp,maestro
last_verified_commit: null
last_verified_at: null
---

# medicines QA

## 1. お薬一覧の表示

服薬画面 AppBar 右上の編集アイコン（ツールチップ「薬を編集」）→ お薬一覧に遷移する。(maestro/flows/full_pause_feature.yaml でカバー)

- [ ] **AppBar タイトル**: AppBar に「お薬一覧」と表示される
- [ ] **お薬カードの表示**: 登録済みの薬がカードで並び、各カードに薬名・服用者名・服用スケジュールの時刻が表示される
- [ ] **容量メモ・メモの表示**: スケジュールに容量メモがある場合は時刻の右側に、薬にメモがある場合はカード下部に表示される
- [ ] **アーカイブ済みの除外**: archivedDateTime が設定された薬はお薬一覧に表示されない

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **AppBar タイトル**: AppBar に「お薬一覧」と表示される

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **お薬カードの表示**: 登録済みの薬がカードで並び、各カードに薬名・服用者名・服用スケジュールの時刻が表示される

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **容量メモ・メモの表示**: スケジュールに容量メモがある場合は時刻の右側に、薬にメモがある場合はカード下部に表示される

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **アーカイブ済みの除外**: archivedDateTime が設定された薬はお薬一覧に表示されない

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>

---

## 2. 薬の追加・編集への導線

- [ ] **お薬を追加**: 画面下部の「お薬を追加」ボタンで新規のお薬登録画面（モーダル）が開く
- [ ] **登録上限**: 登録数が上限に達すると「お薬は{count}つまで登録できます。」が表示され「お薬を追加」ボタンが押せなくなる。無料ユーザーには「プレミアムプランで上限を{count}に増やす」リンクが表示される
- [ ] **カードの編集アイコン**: カード右上の編集アイコン（ツールチップ「薬を編集」）で対象の薬のお薬登録画面（編集モード）が開く

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **お薬を追加**: 画面下部の「お薬を追加」ボタンで新規のお薬登録画面（モーダル）が開く

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **登録上限**: 登録数が上限に達すると「お薬は{count}つまで登録できます。」が表示され「お薬を追加」ボタンが押せなくなる。無料ユーザーには「プレミアムプランで上限を{count}に増やす」リンクが表示される

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **カードの編集アイコン**: カード右上の編集アイコン（ツールチップ「薬を編集」）で対象の薬のお薬登録画面（編集モード）が開く

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>

---

## 3. 服薬の一時停止・再開（Switch）

- [ ] **Switch を OFF**: カード右下の Switch を OFF にすると「薬の服用を一時停止しました」の Snackbar が表示され、服薬画面からその薬が消える (maestro/flows/toggle_switch.yaml でカバー)
- [ ] **Switch を ON**: 一時停止中の Switch を ON に戻すと「薬の服用を再開しました」の Snackbar が表示され、服薬画面に薬が戻る (maestro/flows/resume_and_edit.yaml でカバー)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **Switch を OFF**: カード右下の Switch を OFF にすると「薬の服用を一時停止しました」の Snackbar が表示され、服薬画面からその薬が消える (maestro/flows/toggle_switch.yaml でカバー)

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **Switch を ON**: 一時停止中の Switch を ON に戻すと「薬の服用を再開しました」の Snackbar が表示され、服薬画面に薬が戻る (maestro/flows/resume_and_edit.yaml でカバー)

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>
