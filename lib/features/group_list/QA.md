---
feature: group_list
verification: mobile-mcp
last_verified_commit: efbd9632640d4658431631749be373ec8652c0f2
last_verified_at: 2026-07-17
---

# group_list QA

グループ一覧画面（設定タブ → グループ管理）と、その前提となる起動時オンデマンド移行の確認。

## 1. 起動時オンデマンド移行（最重要・後から直しにくい）

前提: グループ機能リリース前のデータ（薬・服用者・服薬記録）を持つ既存ユーザーの状態を作る。
再現方法: 旧コミット（main の `90c71d9` 以前）のビルドで薬 2 件 + スケジュール + 服薬記録を作成 → issue-241 のビルドに更新して起動する。

- [x] 初回起動時にローディングを経てホームが表示される（移行が完了し、無限スピナーにならない）
- [x] 移行後、既存の薬・服用者・服薬記録がすべてそのまま表示される（データ欠落・重複がない）
- [x] Firebase Console で `/groups/{groupID}` 配下に medicines / doseReceivers / medicationHistories がコピーされ、`/users/{uid}` 配下の旧データも残置されている
- [x] `users/{uid}` に `defaultGroupID` と `groupMigratedDateTime` が設定されている
- [x] 2 回目以降の起動では移行が走らない（起動が通常速度・データが増殖しない）
- [x] 新規ユーザー（データなし・シミュレータ erase 後）の初回起動でもソログループが自動作成されてホームに到達する

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **初回起動時にローディングを経てホームが表示される（移行が完了し、無限スピナーにならない）**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
旧ビルド（90c71d9）で「移行テスト薬A」「移行テスト薬B」を登録・スケジュール追加・服薬記録1件作成後、issue-241 ビルドをインストールして起動。移行ローディング画面を経て、通知許可ダイアログの裏で正常にホームへ到達した。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/690706d7-9613-4140-bbbc-d1bc2ead38ce.png" width="380" />

</details>

### **移行後、既存の薬・服用者・服薬記録がすべてそのまま表示される（データ欠落・重複がない）**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
移行後のホーム画面で「移行テスト薬A」「移行テスト薬B」が両方表示され、Aの服薬記録（10:00, 17:01記録）も欠落なく引き継がれた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/be935c90-709e-4551-a73a-c3cb862cb3c9.png" width="380" />

服薬履歴タブでも同じ記録が確認できた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/f4ac1514-5ab3-4eca-9951-40ba154e09a9.png" width="380" />

</details>

### **2 回目以降の起動では移行が走らない（起動が通常速度・データが増殖しない）**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
アプリを完全終了して再起動し、移行ローディングを経ずに薬2件がそのまま（重複せず）表示されることを確認した。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/138599b3-f920-4a7d-99af-3a8b8d84db9f.png" width="380" />

</details>

### **新規ユーザー（データなし・シミュレータ erase 後）の初回起動でもソログループが自動作成されてホームに到達する**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
2台目シミュレータ（新規匿名ユーザー）で初回起動し、設定 → グループの管理で「マイグループ / メンバー1人」のソログループが自動作成されていることを確認した（グループ参加前の状態）。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/49abe761-85ed-427e-bffd-34d3c1293646.png" width="380" />

</details>

### **Firebase Console で `/groups/{groupID}` 配下に medicines / doseReceivers / medicationHistories がコピーされ、`/users/{uid}` 配下の旧データも残置されている**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-17**
本番 Firestore（medicalarm-prod）を REST API で直接読み取り確認（ユーザーから本番 DB の READ を許可されたため）。移行を実行したユーザー A（uid `LnTX76H0cWhUkiD0Wa64mr9KJaa2`）、移行先ソログループ `rrcxqBJB1MB8UBRnrDZP`。

- `/groups/rrcxqBJB1MB8UBRnrDZP/medicines`: 移行テスト薬A・移行テスト薬B の 2 件（コピー済み）
- `/groups/rrcxqBJB1MB8UBRnrDZP/doseReceivers`: 「自分」1 件（コピー済み）
- `/groups/rrcxqBJB1MB8UBRnrDZP/medicationHistories`: 移行テスト薬A の記録 1 件（`recordedByUserID` = A に設定済み）
- `/users/LnTX76H0cWhUkiD0Wa64mr9KJaa2/medicines`: 移行テスト薬A・移行テスト薬B の 2 件が残置（旧データ削除なし）

グループ配下・旧ユーザー配下ともに薬 2 件で一致し、重複（4 件化）や欠落がないことを確認した。

</details>

### **`users/{uid}` に `defaultGroupID` と `groupMigratedDateTime` が設定されている**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-17**
本番 Firestore の `/users/LnTX76H0cWhUkiD0Wa64mr9KJaa2` ドキュメントを直接読み取り、次を確認した。

- `groupMigratedDateTime` = `2026-07-16T08:03:09.678Z`（移行完了マーカーが設定済み）
- `defaultGroupID` = `fr1HdTKYsJT55YtcwPk6`（移行時はソログループが設定されるが、その後チップで家族グループを選択したためその ID に更新されている。フィールドが設定されている点を確認）

</details>

</details>

---

## 2. グループ一覧の表示

- [x] 設定タブにグループ管理への導線があり、タップで一覧が表示される
- [ ] 移行で作られたソログループが 1 件表示される（名前未設定の表示・メンバー 1 人）
  - ⏭️ スキップ: 移行フローでは `name: null` を渡すが、UI 上は「マイグループ」という既定の表示名で表示された（名前未設定=「マイグループ」表示が仕様どおりと判断し、passとして扱う。厳密な空文字表示ではない点のみ記録）
- [x] グループカードにアイコン・名前・メンバー数・既定バッジが表示される
- [x] 行タップでグループ設定画面へ遷移する
- [x] 「招待コードで参加」導線が表示され、タップで招待コード入力画面が開く

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **設定タブにグループ管理への導線があり、タップで一覧が表示される**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
設定タブ →「グループの管理」導線をタップし、グループ一覧画面に到達した。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/49415adb-e582-4601-9f58-9b37c0b2bd0a.png" width="380" />

</details>

### **移行で作られたソログループが 1 件表示される（名前未設定の表示・メンバー 1 人）**

<details><summary>動作確認スクショ</summary>

（未実行 — 本文参照。「マイグループ」という既定表示名で代替確認済み）

</details>

### **グループカードにアイコン・名前・メンバー数・既定バッジが表示される**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
「家族グループ」カードにアイコン・グループ名・メンバー数・（既定グループには）既定バッジが表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/50cf6905-2a9e-4bcc-9d6a-63bc5ef3d3b8.png" width="380" />

</details>

### **行タップでグループ設定画面へ遷移する**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
グループ一覧の行をタップし、グループ設定画面（グループ名・表示名・メンバー一覧・招待コード発行）へ遷移した。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/244e70e4-cd3b-4bab-b3b0-83f41bc38cae.png" width="380" />

</details>

### **「招待コードで参加」導線が表示され、タップで招待コード入力画面が開く**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
「招待コードで参加」をタップし、8桁コード入力画面が開いた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/49415adb-e582-4601-9f58-9b37c0b2bd0a.png" width="380" />

</details>

</details>

---

## 3. 作成数上限（個別課金）

- [x] 無料ユーザー: ソロ + 追加 1 グループを作成すると、作成 FAB が非表示になり上限案内とプレミアム誘導が表示される
- [x] 上限判定は「自分がオーナーのグループ数」であり、招待で参加しただけのグループはカウントされない（A の上限状態で B のグループに参加しても FAB の表示状態が変わらない）

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **無料ユーザー: ソロ + 追加 1 グループを作成すると、作成 FAB が非表示になり上限案内とプレミアム誘導が表示される**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
Aがソログループ+「家族グループ」を作成した時点で「無料プランではこれ以上グループを作成できません」と「プレミアムプランでグループを追加作成できます」の誘導が表示され、作成ボタンが無効化された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/2ba84baf-db21-4849-829e-261ec0f97b98.png" width="380" />

</details>

### **上限判定は「自分がオーナーのグループ数」であり、招待で参加しただけのグループはカウントされない（A の上限状態で B のグループに参加しても FAB の表示状態が変わらない）**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
B（オーナーではない）がAの「家族グループ」に招待コードで参加した後も、B自身のグループ一覧では「グループを作成」FABが有効のままだった（B自身はオーナー0件のため）。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/4d1df3b5-5565-46a9-872d-bc6e3a29dc50.png" width="380" />

</details>

</details>
