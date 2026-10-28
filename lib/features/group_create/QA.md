---
feature: group_create
verification: mobile-mcp
last_verified_commit: 263630555ac273bca24b8c4df556f018b9a8578d
last_verified_at: 2026-10-16
---

# group_create QA

グループ作成画面（グループ一覧 → 作成 FAB）の確認。

## 1. 入力とバリデーション

- [x] 名前が空の間は作成ボタンが無効
- [x] アイコン 6 種（いえ / 家族 / 病院 / 薬 / 介護 / ハート相当）が表示され、選択状態がハイライトされる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### 名前が空の間は作成ボタンが無効

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
グループ名が空の間は「グループを作成」ボタンがグレーで押せない表示だった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/893c907c-75d7-4067-b5b2-bac7c5abe7d9-gc01-empty-disabled.jpg" width="320">

</details>

### アイコン 6 種（いえ / 家族 / 病院 / 薬 / 介護 / ハート相当）が表示され、選択状態がハイライトされる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
アイコンに家・家族・病院・薬・介護・ハートの 6 種が並び、選んだアイコンだけが枠線と塗りで強調された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/1aa75a80-b70a-4907-a201-b0790272f92a-gc02-icons.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/51f80ecd-3cf4-4e35-9e71-0b1f236e857b-gc07-care-icon.jpg" width="320">

</details>

</details>

---

## 2. 作成フロー

- [x] 作成に成功すると招待コードダイアログが表示される（8 桁コード + 有効期限の表示）
- [x] コピーで確認の SnackBar が表示される
- [ ] コピーで招待コードがクリップボードに入る
  - ⏭️ スキップ: simtunnel の Simulator のクリップボードの中身を読む手段を今回使っておらず、SnackBar の表示だけを確認した
- [x] ダイアログを閉じるとグループ一覧に戻り、新しいグループが一覧に表示される
- [x] 作成しても表示中グループ（ホームの表示対象）は切り替わらない（shoppinglist 踏襲の仕様）
- [ ] Firebase Console の `/groups/{新規groupID}` に ownerUserID = 自分・memberUserIDs = [自分] が入っている
  - ⏭️ スキップ: 今回は Firestore のデータを確認していない。作成したグループが本人のグループ一覧に「メンバー1人」で並ぶことだけを画面で確認した

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### 作成に成功すると招待コードダイアログが表示される（8 桁コード + 有効期限の表示）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
名前を入れて作成すると、8 桁のコードと有効期限 (7 日後) の招待コードダイアログが表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/6f0f7d3e-c08c-47bb-9b6c-dfa93525ff2c-gc03-invite-code.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/966d194e-a1db-410f-91ca-1fa29df6a5ab-gc08-created.jpg" width="320">

</details>

### コピーで確認の SnackBar が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「コードをコピー」をタップすると「招待コードをコピーしました」の SnackBar が表示された (クリップボードの中身はこの環境では読んでいない)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/a5d21905-b812-4d89-9f33-f4a54e14959a-gc04-copied.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/b07df3df-6e04-4c15-ab21-a3ec03efc18f-gc09-copied.jpg" width="320">

</details>

### ダイアログを閉じるとグループ一覧に戻り、新しいグループが一覧に表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「閉じる」でグループ一覧に戻り、作成したグループ (QA Group・Care) が一覧に並んだ。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/de2a1856-e2c1-47b3-9c0c-72f025283016-gl02-limit-reached.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/fda67974-d0f7-4f9f-966d-cb5ec88d761a-gl05-limit-d.jpg" width="320">

</details>

### 作成しても表示中グループ（ホームの表示対象）は切り替わらない（shoppinglist 踏襲の仕様）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「Care」を作成した後に服薬画面へ戻ると、選択中のチップはマイグループのままで、マイグループの薬が表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/70c08a72-d6ab-47bc-ae7e-0b86e04fca5d-gc10-home-not-switched.jpg" width="320">

</details>

### Firebase Console の `/groups/{新規groupID}` に ownerUserID = 自分・memberUserIDs = [自分] が入っている

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>

---

## 3. 異常系

- [ ] 機内モード等で作成に失敗した場合、エラーメッセージが表示されボタンが再度押せる
  - ⏭️ スキップ: simtunnel の Simulator ではネットワークを切れない。別の runner で Cloud Functions に届かなかった時に、グループ作成で NetworkException のエラーダイアログが表示され、閉じた後にボタンを押し直せたことは観測した
- [ ] （再現できれば）作成成功後に招待コード発行だけが失敗した場合、再タップで重複グループが作られない（createdGroupID 保持による再試行。再現が難しければ未確認と記録する）
  - ⏭️ スキップ: 作成の成功と招待コード発行の失敗を分けて起こす手段が無く、再現できない

