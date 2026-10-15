---
feature: group_list
verification: mobile-mcp
last_verified_commit: b28392fae518a7b8dc861588de798f90678346d6
last_verified_at: 2026-10-15
---

# group_list QA

グループ一覧画面（設定タブ → グループ管理）と、その前提となる起動時オンデマンド移行の確認。

## 1. 起動時オンデマンド移行（最重要・後から直しにくい）

前提: グループ機能リリース前のデータ（薬・服用者・服薬記録）を持つ既存ユーザーの状態を作る。
再現方法: 旧コミット（main の `90c71d9` 以前）のビルドで薬 2 件 + スケジュール + 服薬記録を作成 → issue-241 のビルドに更新して起動する。

- [ ] 初回起動時にローディングを経てホームが表示される（移行が完了し、無限スピナーにならない）
  - ⏭️ スキップ: グループ移行前の旧形式のデータを持つユーザーを今回用意していない (新規ユーザーだけで確認した)。移行のコード (lib/features/resolver/group_migration.dart) は 2026-07-16 の確認以降変わっていない
- [ ] 移行後、既存の薬・服用者・服薬記録がすべてそのまま表示される（データ欠落・重複がない）
  - ⏭️ スキップ: 同上
- [ ] Firebase Console で `/groups/{groupID}` 配下に medicines / doseReceivers / medicationHistories がコピーされ、`/users/{uid}` 配下の旧データも残置されている
  - ⏭️ スキップ: 同上
- [ ] `users/{uid}` に `defaultGroupID` と `groupMigratedDateTime` が設定されている
  - ⏭️ スキップ: 同上
- [ ] 2 回目以降の起動では移行が走らない（起動が通常速度・データが増殖しない）
  - ⏭️ スキップ: 同上
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

**確認日: 2026-10-15**
新規インストールした 5 人のユーザーすべてで、初回起動からオンボーディングを経てホームに到達し、グループ一覧に「マイグループ メンバー1人 既定」が 1 件作られていた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/c0d369a6-655f-4e1e-9791-bff08015c6ab-ob11-placeholder-cards.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/88c10974-1338-4f53-805a-f8cdd9caeb08-gl01-list-solo.jpg" width="320">

</details>

</details>

---

## 2. グループ一覧の表示

- [x] 設定タブにグループ管理への導線があり、タップで一覧が表示される
- [ ] 移行で作られたソログループが 1 件表示される（名前未設定の表示・メンバー 1 人）
  - ⏭️ スキップ: 移行前のデータを持つユーザーを用意していない。新規ユーザーで自動作成されたグループは「マイグループ メンバー1人」と表示された
- [x] グループカードにアイコン・名前・メンバー数・既定バッジが表示される
- [x] 行タップでグループ設定画面へ遷移する
- [x] 「招待コードで参加」導線が表示され、タップで招待コード入力画面が開く

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### 設定タブにグループ管理への導線があり、タップで一覧が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
設定タブの「グループ」セクションの「グループの管理」をタップするとグループ一覧が開いた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/68c527f7-96ca-419b-8b85-9f7ace2f89e6-st01-settings.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/88c10974-1338-4f53-805a-f8cdd9caeb08-gl01-list-solo.jpg" width="320">

</details>

### 移行で作られたソログループが 1 件表示される（名前未設定の表示・メンバー 1 人）

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### グループカードにアイコン・名前・メンバー数・既定バッジが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
グループの行に家のアイコン・「マイグループ」・「メンバー1人」・「既定」のバッジが表示された。参加先のグループでは「メンバー2人」と表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/88c10974-1338-4f53-805a-f8cdd9caeb08-gl01-list-solo.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/a85b5e23-d7f3-4aae-8c97-02ae6087211a-gi03-joined-list.jpg" width="320">

</details>

### 行タップでグループ設定画面へ遷移する

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
グループの行をタップするとグループ設定画面が開いた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/7a97a5b1-2ec3-4543-b036-55fcc54633a5-gs03-mygroup-setting.jpg" width="320">

</details>

### 「招待コードで参加」導線が表示され、タップで招待コード入力画面が開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
一覧の「招待コードで参加」をタップすると「グループに参加」の入力画面が開いた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/2fa7ccfc-69e5-429e-95e6-e70060cbd113-gi01-short-lowercase.jpg" width="320">

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

**確認日: 2026-10-15**
自分のグループに加えて 1 つ作成すると、「グループを作成」ボタンが消えて「プレミアムプランでグループを追加作成できます」が表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/de2a1856-e2c1-47b3-9c0c-72f025283016-gl02-limit-reached.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/fda67974-d0f7-4f9f-966d-cb5ec88d761a-gl05-limit-d.jpg" width="320">

</details>

### 上限判定は「自分がオーナーのグループ数」であり、招待で参加しただけのグループはカウントされない（A の上限状態で B のグループに参加しても FAB の表示状態が変わらない）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
自分のグループと招待で参加したグループの 2 つに所属する B のグループ一覧には、「グループを作成」ボタンが表示されたままだった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/a85b5e23-d7f3-4aae-8c97-02ae6087211a-gi03-joined-list.jpg" width="320">

</details>

</details>
