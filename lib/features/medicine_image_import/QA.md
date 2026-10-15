---
feature: medicine_image_import
verification: mobile-mcp
last_verified_commit: 418d2945918380b93f5e789206be79229d5a9c78
last_verified_at: 2026-10-15
---

# medicine_image_import QA

お薬手帳・処方箋・薬袋などの画像から薬の登録候補を AI（Cloud Functions の `generateMedicinesFromImage`）で抽出し、レビューシートで取捨選択して一括登録する機能。

## 関連リンク

- 仕様: 仕様なし QA（起票元 issue に仕様の正データはなく、「bannzai/shoppinglist の画像から買い物リストを作る機能を参考に」という方針のみ）
- 関連: https://github.com/bannzai/medicalarm/issues/257 / https://github.com/bannzai/medicalarm/pull/267

## テスト画像

実物の調剤帳票（じほう社の服薬指導せん印刷見本）を参考に作成した 3 枚を `scripts/e2e/fixtures/` に置いている。それぞれ `<画像名>_expected.json` が期待する抽出結果の正で、`fixtures/src/` の HTML と `render.sh` から再生成できる。

- `medication_guide.png` — お薬の説明書（薬 4 種: 朝のみ / 朝・夕 / 朝・昼・夕 / 就寝前。錠剤写真・服用時点表・薬の作用・注意事項つきの帳票）
- `medicine_notebook_seal.png` — お薬手帳に貼るシールの写真（毎食後 / 就寝前 / 頓服の 3 種。頓服「発熱時・頭痛時に服用」は時刻なし = アプリで仮時刻 10:00 になるエッジケース）
- `medicine_bag.png` — 薬袋の写真（単剤・1日2回 朝・夕食後）

シミュレータの写真ライブラリへの取り込み:

```bash
xcrun simctl addmedia <UDID> scripts/e2e/fixtures/*.png
```

アプリを介さず Functions の抽出結果だけを確認したい場合は次を使う（実行のたびに OpenAI の課金と月間利用回数の消費が発生する）:

```bash
bash scripts/e2e/generate_medicines_from_image.sh
```

抽出結果は AI の出力のため毎回完全一致するとは限らない。薬名の表記ゆれ（規格の有無等）は許容し、薬の件数・服用時刻・服用量が期待結果と一致することを見る。

---

## 1. 画像から登録の導線

お薬一覧（服薬画面 AppBar 右上の編集アイコンから遷移）の「お薬を追加」ボタンの下に配置される。

- [x] **ボタンの表示**: お薬一覧の「お薬を追加」ボタンの下に「画像から登録」ボタンが表示される
  - 自動化: manual（写真ライブラリからの画像選択が OS のピッカー経由で maestro から安定操作できないため、mobile-mcp で目視確認する）
- [x] **画像選択ダイアログ**: タップすると「カメラ」「フォトライブラリ」を選ぶダイアログが表示され、「閉じる」で何も起きずに閉じる
  - 自動化: manual（同上）
- [ ] **登録数上限時の無効化**: 自分が作成した薬が上限（無料 2 件 / プレミアム 10 件）に達していると「画像から登録」ボタンが無効になる
  - 自動化: manual（上限到達状態を手で作る必要があるため）
  - ⏭️ スキップ: 上限到達状態（無料 2 件）の作り込みを今回は行っていない。残り枠の判定ロジックは test/features/medicine_image_import/review_sheet_test.dart と import_button.dart の再計算ガードでカバー

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **ボタンの表示**: お薬一覧の「お薬を追加」ボタンの下に「画像から登録」ボタンが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
ローカル sim-boot（SIMSLIM_EXCEPT=store,photos）の iPhone シミュレータで確認
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/be17aca9-dd49-43d0-abed-ed9e6eb2d2e1-13_medicines_list.png" width="320">

</details>

### **画像選択ダイアログ**: タップすると「カメラ」「フォトライブラリ」を選ぶダイアログが表示され、「閉じる」で何も起きずに閉じる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
ダイアログ表示:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/65954818-ff5c-49f8-9450-add971306987-09_after_dismiss2.png" width="320">
「閉じる」タップ後（何も起きずお薬一覧に戻る）:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/6b5c1976-a4a8-4bc9-9b19-ab688e5cb676-14_after_dialog_close.png" width="320">

</details>

### **登録数上限時の無効化**: 自分が作成した薬が上限（無料 2 件 / プレミアム 10 件）に達していると「画像から登録」ボタンが無効になる

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>

---

## 2. 画像の読み取りとレビューシートの表示

- [x] **読み取り中の表示**: 画像を選ぶとボタンがローディング表示になり、二重実行できない
  - 自動化: manual（AI 呼び出し中の一時的な表示のため）
- [ ] **レビューシートの表示**: 読み取りが終わるとシートが開き、テスト画像（medication_guide.png）の薬 4 種が候補として並び、それぞれ薬名・「毎日」・服用時刻・服用量が表示される
  - 自動化: manual（写真ライブラリからの画像選択を伴うため）
  - ⏭️ スキップ: 月間利用回数の消費を抑えるため medication_guide.png（4 種）は未実施。シートの表示自体（薬名・「毎日」・服用時刻・服用量）は medicine_bag.png（1 種）の読み取りで 2026-10-15 に確認済み（下の「初期選択」のスクショ）
- [ ] **抽出結果の妥当性**: 表示される内容が `scripts/e2e/fixtures/medication_guide_expected.json` と一致する（アムロジピン 8:00、ロキソプロフェンNa 8:00/19:00、酸化マグネシウム 8:00/12:00/19:00、ゾルピデム 22:00。ただし無料ユーザーはスケジュール上限 2 件で切り捨てられる）
  - 自動化: manual（AI の出力内容の照合のため）
  - ⏭️ スキップ: 同上の理由で medication_guide.png は未実施。medicine_bag.png では `medicine_bag_expected.json`（クラリスロマイシン錠200mg「サワイ」 08:00/19:00 各1錠）との一致を 2026-10-15 に確認済み
- [ ] **仮時刻の注意書き**: 服用時刻を読み取れなかった候補には「服用時刻を読み取れなかったため仮の時刻です。登録後に編集できます」が表示され、時刻が 10:00 になる
  - 自動化: manual（medicine_notebook_seal.png の頓服薬カロナールで再現する）
  - ⏭️ スキップ: 月間利用回数の消費を抑えるため今回は未実施
- [ ] **除外された服用時刻の注意書き**: スケジュール上限を超える候補には「上限を超えた服用時刻N件は登録されません」が表示され、表示されている時刻と実際に登録される時刻が一致する
  - 自動化: manual（無料ユーザーで medication_guide.png を読み取ると酸化マグネシウム（3 件）で再現する）
  - ⏭️ スキップ: 月間利用回数の消費を抑えるため今回は未実施。表示ロジックは test/features/medicine_image_import/review_sheet_test.dart でカバー
- [ ] **読み取れなかった場合**: 薬が写っていない画像を選ぶと「画像からお薬を読み取れませんでした」が表示され、「閉じる」で何も登録されずに閉じる
  - 自動化: manual（薬が写っていない画像を別途用意して確認する）
  - ⏭️ スキップ: 月間利用回数の消費を抑えるため今回は未実施。空候補の表示は test/features/medicine_image_import/review_sheet_test.dart でカバー

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **読み取り中の表示**: 画像を選ぶとボタンがローディング表示になり、二重実行できない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「画像から登録」ボタン内にローディングが表示される（二重実行はこのローディングと同じ isLoading ガードで抑止。連打の再現は未実施）
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/3f468a61-696f-40e9-bfb7-5fb422effb55-05_after_select_photo.png" width="320">

</details>

### **レビューシートの表示**: 読み取りが終わるとシートが開き、テスト画像（medication_guide.png）の薬 4 種が候補として並び、それぞれ薬名・「毎日」・服用時刻・服用量が表示される

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **抽出結果の妥当性**: 表示される内容が `scripts/e2e/fixtures/medication_guide_expected.json` と一致する（アムロジピン 8:00、ロキソプロフェンNa 8:00/19:00、酸化マグネシウム 8:00/12:00/19:00、ゾルピデム 22:00。ただし無料ユーザーはスケジュール上限 2 件で切り捨てられる）

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **仮時刻の注意書き**: 服用時刻を読み取れなかった候補には「服用時刻を読み取れなかったため仮の時刻です。登録後に編集できます」が表示され、時刻が 10:00 になる

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **除外された服用時刻の注意書き**: スケジュール上限を超える候補には「上限を超えた服用時刻N件は登録されません」が表示され、表示されている時刻と実際に登録される時刻が一致する

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **読み取れなかった場合**: 薬が写っていない画像を選ぶと「画像からお薬を読み取れませんでした」が表示され、「閉じる」で何も登録されずに閉じる

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>

---

## 3. 候補の選択・編集と登録

- [x] **初期選択**: 候補は残りの登録枠の範囲で初期選択され、確定ボタンに選択件数が表示される
  - 自動化: manual（レビューシートの選択ロジックは test/features/medicine_image_import/review_sheet_test.dart でもカバー）
- [ ] **選択の切り替え**: チェックを外すと確定ボタンの件数が減り、外した候補は登録されない
  - 自動化: manual（同上）
  - ⏭️ スキップ: シミュレータでは未実施。test/features/medicine_image_import/review_sheet_test.dart でカバー
- [ ] **名前の編集**: 候補の名前を編集でき、50 文字を超えて入力できない
  - 自動化: manual（同上）
  - ⏭️ スキップ: シミュレータでは未実施。test/features/medicine_image_import/review_sheet_test.dart でカバー
- [ ] **名前が空の候補の除外**: 名前を空にした候補は選択されていても登録されない
  - 自動化: manual（同上）
  - ⏭️ スキップ: シミュレータでは未実施。test/features/medicine_image_import/review_sheet_test.dart でカバー
- [ ] **名前を入れ直した候補の選択解除**: 選択済み候補の名前を空にして空いた枠で別の候補を選択した後、元の候補に名前を入れ直すとその候補のチェックが外れ、確定件数が上限を超えない
  - 自動化: manual（レビューシートの選択ロジックは test/features/medicine_image_import/review_sheet_test.dart でもカバー）
  - ⏭️ スキップ: シミュレータでは未実施。test/features/medicine_image_import/review_sheet_test.dart でカバー
- [x] **登録の実行**: 「N件を追加」で登録され、「N件のお薬を登録しました」の SnackBar が表示された後、お薬一覧に登録した薬が並ぶ
  - 自動化: manual（写真ライブラリからの画像選択を伴うため）
- [x] **登録内容**: 登録された薬を編集で開くと、服用頻度が「毎日」、服用者が「自分」、服用開始日が当日、最低服用間隔が未設定で、シートに表示されていた時刻・服用量が入っている
  - 自動化: manual（同上）
- [x] **通知の登録**: 登録した薬の服用時刻に通知が登録される（服薬画面に該当時刻の枠が表示される）
  - 自動化: manual（ローカル通知の登録結果を画面で確認する）
- [ ] **キャンセル**: シートを「キャンセル」で閉じると 1 件も登録されない
  - 自動化: manual（同上）
  - ⏭️ スキップ: シミュレータでは未実施。test/features/medicine_image_import/review_sheet_test.dart でカバー

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **初期選択**: 候補は残りの登録枠の範囲で初期選択され、確定ボタンに選択件数が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
medicine_bag.png の読み取り結果。候補が初期選択され、確定ボタンに「1件を追加」が表示される（薬名・「毎日 08:00 1錠 / 19:00 1錠」の表示もこのスクショで確認）
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/409c3af5-ff1a-41b0-ab7b-f9e7be132c03-11_review_sheet.png" width="320">

</details>

### **選択の切り替え**: チェックを外すと確定ボタンの件数が減り、外した候補は登録されない

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **名前の編集**: 候補の名前を編集でき、50 文字を超えて入力できない

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **名前が空の候補の除外**: 名前を空にした候補は選択されていても登録されない

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **名前を入れ直した候補の選択解除**: 選択済み候補の名前を空にして空いた枠で別の候補を選択した後、元の候補に名前を入れ直すとその候補のチェックが外れ、確定件数が上限を超えない

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **登録の実行**: 「N件を追加」で登録され、「N件のお薬を登録しました」の SnackBar が表示された後、お薬一覧に登録した薬が並ぶ

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「1件を追加」で登録され、服薬画面とお薬一覧に反映されることを確認（SnackBar は表示が一瞬で撮影できず未確認）。
服薬画面への反映:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/abc70ee7-5d26-4488-b383-b07950e80980-12_after_add.png" width="320">
お薬一覧への反映:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/be17aca9-dd49-43d0-abed-ed9e6eb2d2e1-13_medicines_list.png" width="320">

</details>

### **登録内容**: 登録された薬を編集で開くと、服用頻度が「毎日」、服用者が「自分」、服用開始日が当日、最低服用間隔が未設定で、シートに表示されていた時刻・服用量が入っている

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
編集画面で頻度「毎日」・開始日 2026/10/15（当日）・服用間隔「なし」・時刻 08:00/19:00 を確認。服用量は編集画面の容量欄が initialValue を持たない main 由来の既存実装のため、お薬一覧の「1錠」表示で確認（服用者「自分」も一覧で確認）
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/f747b81d-a2cc-45c3-8ac9-802b3d462167-15_edit_form.png" width="320">

</details>

### **通知の登録**: 登録した薬の服用時刻に通知が登録される（服薬画面に該当時刻の枠が表示される）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
服薬画面に 08:00・19:00 の枠が表示される
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/abc70ee7-5d26-4488-b383-b07950e80980-12_after_add.png" width="320">

</details>

### **キャンセル**: シートを「キャンセル」で閉じると 1 件も登録されない

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>

---

## 4. 上限・エラーケース

- [ ] **登録枠を超える候補**: 残りの登録枠より候補が多い場合、超過分は初期未選択かつ選択不可になり、「登録できるのは残りN件までです」が表示される
  - 自動化: manual（残り枠 1 件の状態で medication_guide.png（4 候補）を読み取ると再現する）
  - ⏭️ スキップ: 月間利用回数の消費を抑えるため今回は未実施。選択上限ロジックは test/features/medicine_image_import/review_sheet_test.dart でカバー
- [ ] **月間利用回数の上限**: 読み取りを無料 5 回 / プレミアム 50 回まで行うと「画像読み取りの月間利用回数（N回）に達しました」がアラートで表示される
  - 自動化: manual（上限まで実行すると OpenAI の課金が発生するため、必要時のみ実施する）
  - ⏭️ スキップ: 項目の注記どおり課金が発生するため未実施。上限判定は firebase/functions/src/functions/generateMedicinesFromImage/function.test.ts でカバー
- [ ] **通信エラー**: 機内モードなどオフライン状態で画像を選ぶと、エラーアラートが表示され、ローディングが解除される
  - 自動化: manual（シミュレータのネットワークを落として確認する）
  - ⏭️ スキップ: 今回は未実施（レビューシートの layout 修正の通し確認が目的のため）
- [ ] **処理中のグループ切替**: 画像の読み取り中またはレビューシート表示中にグループを切り替えると「グループが切り替わったため登録を中止しました」が表示され、どちらのグループにも薬が登録されない
  - 自動化: manual（複数グループ所属のアカウントで、読み取り中にグループチップをタップして再現する）
  - ⏭️ スキップ: 複数グループ所属アカウントの作り込みを今回は行っていない

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **登録枠を超える候補**: 残りの登録枠より候補が多い場合、超過分は初期未選択かつ選択不可になり、「登録できるのは残りN件までです」が表示される

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **月間利用回数の上限**: 読み取りを無料 5 回 / プレミアム 50 回まで行うと「画像読み取りの月間利用回数（N回）に達しました」がアラートで表示される

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **通信エラー**: 機内モードなどオフライン状態で画像を選ぶと、エラーアラートが表示され、ローディングが解除される

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### **処理中のグループ切替**: 画像の読み取り中またはレビューシート表示中にグループを切り替えると「グループが切り替わったため登録を中止しました」が表示され、どちらのグループにも薬が登録されない

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>
