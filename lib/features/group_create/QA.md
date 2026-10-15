---
feature: group_create
verification: mobile-mcp
last_verified_commit: efbd9632640d4658431631749be373ec8652c0f2
last_verified_at: 2026-07-17
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

（未実行）

</details>

### アイコン 6 種（いえ / 家族 / 病院 / 薬 / 介護 / ハート相当）が表示され、選択状態がハイライトされる

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>

---

## 2. 作成フロー

- [x] 作成に成功すると招待コードダイアログが表示される（8 桁コード + 有効期限の表示）
- [x] コピーで招待コードがクリップボードに入り、確認の SnackBar が表示される
- [x] ダイアログを閉じるとグループ一覧に戻り、新しいグループが一覧に表示される
- [x] 作成しても表示中グループ（ホームの表示対象）は切り替わらない（shoppinglist 踏襲の仕様）
- [x] Firebase Console の `/groups/{新規groupID}` に ownerUserID = 自分・memberUserIDs = [自分] が入っている

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### 作成に成功すると招待コードダイアログが表示される（8 桁コード + 有効期限の表示）

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### コピーで招待コードがクリップボードに入り、確認の SnackBar が表示される

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### ダイアログを閉じるとグループ一覧に戻り、新しいグループが一覧に表示される

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### 作成しても表示中グループ（ホームの表示対象）は切り替わらない（shoppinglist 踏襲の仕様）

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### Firebase Console の `/groups/{新規groupID}` に ownerUserID = 自分・memberUserIDs = [自分] が入っている

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>

---

## 3. 異常系

- [ ] 機内モード等で作成に失敗した場合、エラーメッセージが表示されボタンが再度押せる
  - ⏭️ スキップ: 本番 Firestore 接続シミュレータでのネットワーク遮断シナリオの再現は今回の QA スコープでは実施しなかった。招待コード参加時の異常系（存在しないコード）でエラー表示 → 再操作可能なパターンは group_invitation QA で確認済み
- [ ] （再現できれば）作成成功後に招待コード発行だけが失敗した場合、再タップで重複グループが作られない（createdGroupID 保持による再試行。再現が難しければ未確認と記録する）
  - ⏭️ スキップ: 再現が難しいため未確認（QA.md 記載の代替方針どおり）

