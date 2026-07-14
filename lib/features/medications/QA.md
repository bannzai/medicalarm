---
feature: medications
verification: mobile-mcp
last_verified_commit: ceab6b15bfd78420f8bbb9a67bd045e58f0f4362
last_verified_at: 2026-07-14
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

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/eb1ea0a2-b7f6-4786-97eb-0ac114a6c359.png" width="320">

「お薬」/「7/12 - 7/18」が表示されている

</details>

### **週カレンダー**: 画面上部に週表示カレンダーが表示され、選択中の日付が判別できる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/eb1ea0a2-b7f6-4786-97eb-0ac114a6c359.png" width="320">

選択中の 14 がピンク背景で判別できる

</details>

### **本日バッジ**: カレンダー下に選択日を示すバッジ（TodayBadge）が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/eb1ea0a2-b7f6-4786-97eb-0ac114a6c359.png" width="320">

カレンダー下に「7/14」と前後日への矢印ボタンが表示されている

</details>

### **服薬グループの表示**: 選択日に服用予定の薬が「時刻＋服用者」ごとのカードにまとめて表示され、カードは時刻の昇順で並ぶ

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/6a033b5f-ee88-4f1a-8f1d-db6d50f4b8eb.png" width="320">

QAテスト薬A（07:00, 13:00）と QAテスト薬B（10:00）を登録し、07:00 → 10:00 → 13:00 の昇順でカードが並ぶことを確認（07:00 のカードは開発ビルド固有の AdMob native ad validator オーバーレイに隠れて画面上は見えないが、mobile-mcp のアクセシビリティツリーで y=381 に存在し、10:00(y=496)・13:00(y=611) より上に位置することを確認済み。詳細は下部の既知の制約を参照）

</details>

### **カード内容**: 各カードに時刻（プライマリカラー・太字）、服用者名、薬名と数量メモの行が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/eb1ea0a2-b7f6-4786-97eb-0ac114a6c359.png" width="320">

「13:00」（プライマリカラー・太字）、「自分」、チェックボックス＋「QAテスト薬A」が表示されている

</details>

### **予定なしの日**: 服用予定が無い日はカードが1件も表示されない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/963db522-2166-492e-b862-02132cfab201.png" width="320">

薬の服用開始日（7/14）より前の 7/12 を選択し、カードが1件も表示されないことを確認

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

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/28ccae0c-cc6b-462b-a410-b1577d4e3392.png" width="320">

カレンダーを左スワイプすると AppBar が「7/12 - 7/18」→「7/19 - 7/25」に更新される（選択日自体は 7/14 のまま変わらず、下部のカード表示も維持される仕様を確認）

</details>

### **日付選択**: カレンダー上の日付をタップすると、その日付の服薬グループ一覧に切り替わる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/f3da7d77-5afc-4ad7-8c65-81ca37ebf5eb.png" width="320">

カレンダー上の日付をタップすると選択日が切り替わり（例: 7/15）、TodayBadge と服薬グループ一覧が選択日に応じて更新される

</details>

</details>

---

## 3. 服用の記録

- [x] **チェックで記録**: 薬の行のチェックボックスをオンにすると服用記録が保存され、チェック状態が維持される
- [x] **チェック解除で削除**: チェックボックスをオフにするとその服用記録が削除される
- [x] **未来日の無効化**: 選択日が今日より後（未来）の場合、チェックボックスは操作不可（disabled）になる
- [x] **薬名タップで編集**: 薬名をタップすると、その薬の編集フォーム（お薬登録シート）が開く

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **チェックで記録**: 薬の行のチェックボックスをオンにすると服用記録が保存され、チェック状態が維持される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/eb1ea0a2-b7f6-4786-97eb-0ac114a6c359.png" width="320">

チェックボックスをオンにすると `medicationHistoryTakeProvider` により服用記録が保存され、再描画後もチェック済み状態が維持される

</details>

### **チェック解除で削除**: チェックボックスをオフにするとその服用記録が削除される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/9f13da6f-5acf-43a7-a5a5-5029e71512d7.png" width="320">

チェック済みの行をオフにすると `medicationHistoryDeleteProvider` が呼ばれ、チェックが外れた状態で表示される

</details>

### **未来日の無効化**: 選択日が今日より後（未来）の場合、チェックボックスは操作不可（disabled）になる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/fc769969-39d4-4a6b-838d-e1eef52faff8.png" width="320">

未来日 7/15 を選択してチェックボックスをタップしても値が変化しない（disabled）ことを、アクセシビリティツリー上の Switch value が "0" のまま変わらないことで確認

</details>

### **薬名タップで編集**: 薬名をタップすると、その薬の編集フォーム（お薬登録シート）が開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/0f2fa698-994e-450b-87e1-cd7869837cc0.png" width="320">

カード内の薬名「QAテスト薬A」をタップすると「お薬登録画面」（編集フォーム）が開く

</details>

</details>

---

## 4. 課金導線・広告

- [x] **バナー広告**: プレミアム未加入の場合、一覧上部に AdMob バナー広告が表示される
- [ ] **プレミアム未加入では広告あり / 加入では非表示**: プレミアム加入時は AdMob バナーが表示されない
  - ⏭️ スキップ: プレミアム化には RevenueCat の実購入完了（entitlement 反映）が必要で、シミュレータでは購入画面の表示までしか検証できない（`lib/features/preium_introduction/QA.md` の「購入導線」項目と同じ制約）。StoreKit Configuration ファイル（`ios/Runner/StoreKitConfiguration.storekit`）は存在するが、`xcrun simctl launch` 起動では適用されず、Xcode スキーム経由の実行が必要
- [ ] **トライアル中バナー**: プロモーション期間中は「現在プレミアムトライアル中です」バナーが表示され、タップするとプレミアム紹介シートが開く
  - ⏭️ スキップ: `isInPromotion` は RevenueCat の `rc_promo_Premium` プロモーションエンタイトルメントが必要（`lib/utils/purchase/purchase.dart:82`）。テスト環境でプロモーションを付与する手段がなく再現不可

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **バナー広告**: プレミアム未加入の場合、一覧上部に AdMob バナー広告が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/eb1ea0a2-b7f6-4786-97eb-0ac114a6c359.png" width="320">

非premiumの匿名ユーザーで一覧上部に「Test mode: ...」の AdMob バナーが表示されている（開発ビルドのため test ad が表示され、native ad validator の警告も併せて表示される。詳細は下部の既知の制約を参照）

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
- [x] **登録上限**: 登録数が上限に達すると「お薬は{count}つまで登録できます。」が表示され、追加ボタンが無効になる
  - ⚠️ 発見した表示崩れ: 上限到達時、FAB 上部の警告文言（「お薬は2つまで登録できます。」「プレミアムプランで上限を{count}に増やす」）は `lib/components/fab/layout.dart` の `Align(bottomCenter)` でスクロール領域の上に固定表示されるため、一覧が画面下部まで埋まっていると最後のカードの文字に重なって表示される（`lib/features/medications/page.dart` の `SingleChildScrollView` 側 `padding: bottom: 100` が警告文言込みの FAB 高さに対して不足）。重なった領域をタップすると裏のカードではなく FAB 側のボタン（プレミアム導線）が反応する。gh issue 起票を試みたが本セッションの権限設定で `gh` コマンドが承認待ちのままブロックされ、起票できなかった（後述）
- [x] **上限時の課金導線**: 上限到達かつプレミアム未加入の場合、「プレミアムプランで上限を{count}に増やす」リンクが表示され、タップでプレミアム紹介シートが開く
- [x] **編集アイコン**: AppBar 右上の編集アイコンをタップするとお薬一覧画面（MedicinesPage）に遷移する

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **追加ボタン**: 右下の FAB「お薬を追加」をタップするとお薬登録フォームが開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/963db522-2166-492e-b862-02132cfab201.png" width="320">

登録数が上限未満の状態で服薬画面下部に「＋ お薬を追加」ボタンが有効表示される。ボタン実体（`MedicalAddFloatingActionButtonChild`）は `lib/features/medicines/page.dart` と共通のため、タップでお薬登録フォームが開く挙動は同一コンポーネント経由で実施（QAテスト薬A・Bの登録に使用し、正常に動作することを確認済み）

</details>

### **登録上限**: 登録数が上限に達すると「お薬は{count}つまで登録できます。」が表示され、追加ボタンが無効になる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/6a033b5f-ee88-4f1a-8f1d-db6d50f4b8eb.png" width="320">

薬を2件（無料上限）登録した状態で「お薬は2つまで登録できます。」が表示され、「お薬を追加」ボタンをタップしてもフォームが開かない（無効化）ことを確認

</details>

### **上限時の課金導線**: 上限到達かつプレミアム未加入の場合、「プレミアムプランで上限を{count}に増やす」リンクが表示され、タップでプレミアム紹介シートが開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/00bad76a-8fbb-4d09-8344-fb2a7651750a.png" width="320">

「プレミアムプランで上限を10に増やす」リンクをタップし、プレミアム紹介シート（プレミアムプラン）が開くことを確認

</details>

### **編集アイコン**: AppBar 右上の編集アイコンをタップするとお薬一覧画面（MedicinesPage）に遷移する

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/c0e5b113-7266-4af2-9357-6699b30c69a5.png" width="320">

AppBar 右上の編集アイコンをタップすると「お薬一覧」画面（MedicinesPage）に遷移する

</details>

</details>

---

## 既知の制約・発見事項

- **AdMob native ad validator オーバーレイが操作をブロックする**: 開発ビルドで表示される AdMob native ad validator の警告（root QA.md 参照）は、画面座標 x:0-335 y:355-510 に固定表示され、この範囲に重なる要素（チェックボックス・ボタン等）へのタップを奪う。回避策: (1) 対象要素がこの範囲外（y>510）に来るよう、事前にスケジュールや薬を追加してカードの並び順を調整してから操作する。(2) 服薬画面（AdMob 広告を表示する画面）から直接開いたフォームにはオーバーレイが残るが、お薬一覧画面（MedicinesPage、広告なし）経由でフォームを開けばオーバーレイの影響を受けない
- **FAB 警告文言と最終カードの表示重なり**: 上記「登録上限」項目参照。上限到達時、`lib/components/fab/layout.dart` の固定 FAB エリアがスクロール領域の最終カードに重なる表示崩れを発見。gh issue 起票を試みたが、本セッションでは `gh` / `git remote` コマンドが承認待ちでブロックされ実行できなかった（ネットワークアクセスを伴うコマンドの許可が必要）
