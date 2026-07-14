---
feature: dose_receiver_form
verification: mobile-mcp
last_verified_commit: ceab6b15bfd78420f8bbb9a67bd045e58f0f4362
last_verified_at: 2026-07-14
---

# dose_receiver_form QA

到達手順: 薬の登録/編集フォームの追加情報セクションで「服用者」タイルをタップすると、服用者フォームがボトムシートで表示される。

## 1. 服用者一覧の表示

- [x] **フォーム表示**: ボトムシート上部にタイトル「服用者」が表示され、登録済みの服用者が一覧表示される
- [x] **デフォルト服用者**: 初期状態では服用者「自分」が1件存在する
- [ ] **選択状態の初期値**: フォームを開いた時点で選択中の服用者のラジオボタンが選択状態になっている
  - ❌ 失敗: 既存の薬（服用者フォームで一度も選び直したことがない薬）の編集画面から服用者フォームを開くと、現在の服用者「自分」のラジオボタンが選択状態にならない（空の丸のまま）。原因は `lib/provider/dose_receiver.dart:19-32` の `DoseReceiverAdd.call()` が `collectionRef.add()`（Firestore が別途ランダムなドキュメントIDを採番）で書き込む一方、`lib/features/resolver/database.dart:63` の読み込み時コンバータが `id` フィールドを実際のドキュメントID（ランダム文字列）で上書きするため、`lib/entity/dose_receiver.dart:29-33` の `DoseReceiver.firstUser()`（新規の薬のデフォルト値、固定値 `id: 'firstUser'`）と一覧側の実際の `id` が一致しないこと。一度ラジオボタンを選び直す（＝一覧側の実際の `id` を持つオブジェクトで上書きする）と、以降は正しく選択状態が復元される。issue: https://github.com/bannzai/medicalarm/issues/246

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **フォーム表示**: ボトムシート上部にタイトル「服用者」が表示され、登録済みの服用者が一覧表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/357b5176-5ead-46a4-a8fb-855734a8b77e.png" width="320">

</details>

### **デフォルト服用者**: 初期状態では服用者「自分」が1件存在する

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/357b5176-5ead-46a4-a8fb-855734a8b77e.png" width="320">

</details>

### **選択状態の初期値**: フォームを開いた時点で選択中の服用者のラジオボタンが選択状態になっている

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14（失敗）**

「QAテスト薬A」（服用者は初期値「自分」のまま、一度も服用者フォームで選び直していない）の編集画面から服用者フォームを開いた直後。服用者は1件（自分）のみだが、ラジオボタンが選択されていない:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/357b5176-5ead-46a4-a8fb-855734a8b77e.png" width="320">

</details>

</details>

---

## 2. 服用者の選択・名前編集

- [x] **ラジオ選択**: 服用者行のラジオボタンをタップすると選択がその服用者に切り替わり、呼び出し元のフォームに反映される
- [x] **名前編集**: 服用者名のテキストフィールドを編集して確定（onFieldSubmitted）すると、その名前で更新される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **ラジオ選択**: 服用者行のラジオボタンをタップすると選択がその服用者に切り替わり、呼び出し元のフォームに反映される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

「自分」のラジオボタンをタップすると選択状態（塗りつぶし）に切り替わり、服用者フォームを閉じた後も呼び出し元の医薬品登録フォームの「服用者」タイルに「自分」が表示され続けることを確認:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/aee2c871-8dce-4e96-995d-7d94f814a48a.png" width="320">

</details>

### **名前編集**: 服用者名のテキストフィールドを編集して確定（onFieldSubmitted）すると、その名前で更新される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

「新しい服用者」を「新しい服用者2号」に編集して確定後、画面を閉じて再度開き直しても（Firestore への反映を確認するため）名前が更新されたまま維持されていることを確認:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/6a241916-503d-4e8d-b8f8-7b699132e03c.png" width="320">

</details>

</details>

---

## 3. 服用者の追加

- [x] **追加ボタン**: 「服用者を追加」ボタンをタップすると、名前「新しい服用者」の服用者が一覧に追加される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **追加ボタン**: 「服用者を追加」ボタンをタップすると、名前「新しい服用者」の服用者が一覧に追加される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

「服用者を追加」タップ後、一覧の先頭に「新しい服用者」が追加されることを確認（この操作により服用者が2件になり、無料上限に達している）:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/9a98d8d4-93cd-42c3-ab61-8e2a9efd2791.png" width="320">

</details>

</details>

---

## 4. 登録上限とプレミアム導線

- [x] **上限文言（無料）**: 無料ユーザーは服用者2人まで。上限到達時に「服用者は最大2人まで登録できます」を赤字で表示し、「服用者を追加」ボタンが無効になる
- [x] **プレミアム導線**: 無料ユーザーが上限到達時、「プレミアムプランで上限を10に増やす」リンクを表示し、タップするとプレミアム紹介シートが表示される
- [ ] **上限（プレミアム）**: プレミアムユーザーは服用者10人まで登録できる
  - ⏭️ スキップ: プレミアム化には RevenueCat の実購入完了（entitlement 反映）が必要で、シミュレータでは購入画面の表示までしか検証できない（`lib/features/medications/QA.md` の「プレミアム未加入では広告あり / 加入では非表示」項目と同じ制約）。StoreKit Configuration ファイル（`ios/Runner/StoreKitConfiguration.storekit`）は存在するが、`xcrun simctl launch` 起動では適用されず、Xcode スキーム経由の実行が必要

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **上限文言（無料）**: 無料ユーザーは服用者2人まで。上限到達時に「服用者は最大2人まで登録できます」を赤字で表示し、「服用者を追加」ボタンが無効になる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

服用者が2件（無料上限）になると「服用者は最大2人まで登録できます」が赤字で表示され、「服用者を追加」ボタンが無効化される:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/9a98d8d4-93cd-42c3-ab61-8e2a9efd2791.png" width="320">

</details>

### **プレミアム導線**: 無料ユーザーが上限到達時、「プレミアムプランで上限を10に増やす」リンクを表示し、タップするとプレミアム紹介シートが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

「プレミアムプランで上限を10に増やす」リンクをタップし、プレミアム紹介シート（「服用者の登録数を2 → 10」を含む）が開くことを確認:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/7628f060-0c37-496d-a237-9fe973235096.png" width="320">

</details>

### **上限（プレミアム）**: プレミアムユーザーは服用者10人まで登録できる

<details><summary>動作確認スクショ</summary>

⏭️ スキップ（上記チェックリストの理由欄を参照）

</details>

</details>
