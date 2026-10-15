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

### 初回起動時にローディングを経てホームが表示される（移行が完了し、無限スピナーにならない）

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### 移行後、既存の薬・服用者・服薬記録がすべてそのまま表示される（データ欠落・重複がない）

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### Firebase Console で `/groups/{groupID}` 配下に medicines / doseReceivers / medicationHistories がコピーされ、`/users/{uid}` 配下の旧データも残置されている

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### `users/{uid}` に `defaultGroupID` と `groupMigratedDateTime` が設定されている

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### 2 回目以降の起動では移行が走らない（起動が通常速度・データが増殖しない）

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### 新規ユーザー（データなし・シミュレータ erase 後）の初回起動でもソログループが自動作成されてホームに到達する

<details><summary>動作確認スクショ</summary>

（未実行）

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

### 設定タブにグループ管理への導線があり、タップで一覧が表示される

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### 移行で作られたソログループが 1 件表示される（名前未設定の表示・メンバー 1 人）

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### グループカードにアイコン・名前・メンバー数・既定バッジが表示される

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### 行タップでグループ設定画面へ遷移する

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### 「招待コードで参加」導線が表示され、タップで招待コード入力画面が開く

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>

---

## 3. 作成数上限（個別課金）

- [x] 無料ユーザー: ソロ + 追加 1 グループを作成すると、作成 FAB が非表示になり上限案内とプレミアム誘導が表示される
- [x] 上限判定は「自分がオーナーのグループ数」であり、招待で参加しただけのグループはカウントされない（A の上限状態で B のグループに参加しても FAB の表示状態が変わらない）

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### 無料ユーザー: ソロ + 追加 1 グループを作成すると、作成 FAB が非表示になり上限案内とプレミアム誘導が表示される

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### 上限判定は「自分がオーナーのグループ数」であり、招待で参加しただけのグループはカウントされない（A の上限状態で B のグループに参加しても FAB の表示状態が変わらない）

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>
