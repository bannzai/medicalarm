---
feature: preium_introduction
verification: mobile-mcp
last_verified_commit: ceab6b15bfd78420f8bbb9a67bd045e58f0f4362
last_verified_at: 2026-07-15
---

# preium_introduction QA

到達手順: 設定タブの「プレミアムプランを見る」、または各画面の登録上限到達時に表示される「プレミアムプランで上限を増やす」導線をタップすると、プレミアム紹介シートが表示される。

## 1. シート表示・ヘッダー

- [x] **ヘッダー**: シート上部に premium_header 画像とタイトル「プレミアムプラン」が表示される
- [x] **閉じる操作**: 左上の閉じるボタン（×）でシートを閉じられる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **ヘッダー**: シート上部に premium_header 画像とタイトル「プレミアムプラン」が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-15**
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260715/21831e6e-2a63-43fa-b550-d7b9586d885a.png" width="320">

</details>

### **閉じる操作**: 左上の閉じるボタン（×）でシートを閉じられる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-15**
閉じるボタンをタップし、設定画面に戻ることを確認:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260715/719b49f0-99ea-4b15-80fc-f9177f719699.png" width="320">

</details>

</details>

---

## 2. プレミアム特典の表示（非会員）

- [x] **特典リスト**: 非会員時、特典カードに「広告の非表示」「服用履歴をすべて表示」「薬の登録数を（無料上限→プレミアム上限）」「通知のスケジュール数を（無料上限→プレミアム上限）」「服用者の登録数を 2→10」が表示される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **特典リスト**: 非会員時、特典カードに「広告の非表示」「服用履歴をすべて表示」「薬の登録数を（無料上限→プレミアム上限）」「通知のスケジュール数を（無料上限→プレミアム上限）」「服用者の登録数を 2→10」が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-15**
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260715/21831e6e-2a63-43fa-b550-d7b9586d885a.png" width="320">

</details>

</details>

---

## 3. 購入プラン（非会員）

- [x] **月額プラン**: 「月額プラン」の行にストアの価格が表示される
- [x] **年額プラン・割引バッジ**: 「年額プラン」の行にストアの価格が表示され、右上に「月額より{percent}%OFF」の割引バッジが表示される（percent は月額×12と年額の価格差から算出）
- [ ] **購入導線**: 月額・年額いずれかをタップすると購入処理が開始される。購入成功時に「Medicalarmプレミアム登録完了」ダイアログが表示される（RevenueCat 購入のため、シミュレータでは購入画面の表示までを確認）
  - ❌ 失敗: 「年額プラン」をタップしても実際には月額プラン（`monthlyPackage`）の購入処理が呼ばれる。月額プランのタップは正しく月額の購入フローに入ることを確認済み。原因は `lib/features/preium_introduction/components/purchase_buttons.dart` の `AnnualPurchaseButton` の `onTap` コールバックが、引数で渡される `annualPackage` を使わず外側のクロージャの `monthlyPackage` を `_purchase` に渡していること。再現手順: 設定タブ→「プレミアムプランを見る」→年額プランをタップ→`xcrun simctl spawn <UDID> log show --last 3m --predicate 'process == "Runner"' --style compact | grep "flutter:"` でアプリログを確認すると `pressed_annual_purchase_button` イベント発火後に月額パッケージへの購入APIコールが行われる（StoreKit のサインインダイアログ自体はどちらのボタンでも同一表示のため画面上の差分では判別できない）。issue: https://github.com/bannzai/medicalarm/issues/248

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **月額プラン**: 「月額プラン」の行にストアの価格が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-15**
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260715/21831e6e-2a63-43fa-b550-d7b9586d885a.png" width="320">

</details>

### **年額プラン・割引バッジ**: 「年額プラン」の行にストアの価格が表示され、右上に「月額より{percent}%OFF」の割引バッジが表示される（percent は月額×12と年額の価格差から算出）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-15**
月額 $2.99・年額 $22.99・割引バッジ「月額より35%OFF」を確認:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260715/21831e6e-2a63-43fa-b550-d7b9586d885a.png" width="320">

</details>

### **購入導線**: 月額・年額いずれかをタップすると購入処理が開始される。購入成功時に「Medicalarmプレミアム登録完了」ダイアログが表示される（RevenueCat 購入のため、シミュレータでは購入画面の表示までを確認）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-15**
月額プランをタップし、Apple Account サインインダイアログ（StoreKit 購入フロー）まで到達することを確認（シミュレータのため実購入は未完了・キャンセルして検証終了）:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260715/47bfd2f9-419b-40fb-b070-717f36e056a3.png" width="320">

年額プランのタップは上記チェックリストの通り失敗（月額パッケージが購入される）のため未チェック。

</details>

</details>

---

## 4. フッター・購入復元

- [x] **規約リンク**: フッターの「プライバシーポリシー」「利用規約」「特定商取引法に基づく表記」をタップすると、それぞれのページがアプリ内Webビューで開く
- [x] **注意書き**: 契約期間（購入日から1ヶ月）・契約終了後の自動更新・解約方法の注意書きが表示される
- [x] **購入復元**: 「以前購入した方はこちら」をタップすると購入復元が実行され、有効な購入があれば「購入情報を復元しました」のスナックバーが表示される（RevenueCat 復元のため、シミュレータでは実行操作までを確認）

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **規約リンク**: フッターの「プライバシーポリシー」「利用規約」「特定商取引法に基づく表記」をタップすると、それぞれのページがアプリ内Webビューで開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-15**

RichText内の各リンクはテキスト全体ではなく、対象の文言（例: "プライバシーポリシー"）の実際のグリフ座標を狙ってタップする必要がある（accessibility要素は行全体やスパンの断片単位でまとまっており、リンクテキスト自体は個別要素として現れない）。

プライバシーポリシー:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260715/0fc09ec6-ebb1-4e2f-933b-cb7525447278.png" width="320">

利用規約:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260715/a58c1f8f-014d-4308-bce0-d729d4f0cae5.png" width="320">

特定商取引法に基づく表記:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260715/62b6ecac-c3d3-42f0-8e9e-6388f3daa61c.png" width="320">

</details>

### **注意書き**: 契約期間（購入日から1ヶ月）・契約終了後の自動更新・解約方法の注意書きが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-15**
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260715/21831e6e-2a63-43fa-b550-d7b9586d885a.png" width="320">

</details>

### **購入復元**: 「以前購入した方はこちら」をタップすると購入復元が実行され、有効な購入があれば「購入情報を復元しました」のスナックバーが表示される（RevenueCat 復元のため、シミュレータでは実行操作までを確認）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-15**
シミュレータには有効な購入情報が存在しないため、想定通り「不明なエラーが発生しました。以前の購入情報が見つかりません。」のエラーダイアログが表示された（復元処理自体は実行されている）:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260715/f8c02c82-b051-407d-8278-0c8984626ab4.png" width="320">

</details>

</details>

---

## 5. プレミアム会員時の表示

- [ ] **会員向け表示**: プレミアム会員（isPremium）の場合、特典カードと購入ボタンは表示されず、「プレミアムメンバーです」とお礼メッセージが表示される
  - ⏭️ スキップ: プレミアム化には RevenueCat の実購入完了（entitlement 反映）が必要で、シミュレータでは購入画面（Apple Account サインインダイアログ）の表示までしか検証できない（`lib/features/dose_receiver_form/QA.md` の「上限（プレミアム）」項目と同じ制約）。StoreKit Configuration ファイル（`ios/Runner/StoreKitConfiguration.storekit`）は存在するが、`xcrun simctl launch` 起動では適用されず、Xcode スキーム経由の実行が必要なため今回は対象外とした

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **会員向け表示**: プレミアム会員（isPremium）の場合、特典カードと購入ボタンは表示されず、「プレミアムメンバーです」とお礼メッセージが表示される

<details><summary>動作確認スクショ</summary>

（未実行 — スキップ理由はチェックリスト参照）

</details>

</details>
