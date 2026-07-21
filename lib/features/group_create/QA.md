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

### **名前が空の間は作成ボタンが無効**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
グループ名未入力の状態で「グループを作成」ボタンがグレーアウト（無効）表示されている。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/16cbc603-9491-4562-b150-4142d6193709.png" width="380" />

</details>

### **アイコン 6 種（いえ / 家族 / 病院 / 薬 / 介護 / ハート相当）が表示され、選択状態がハイライトされる**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
6種のアイコン（いえ・家族・病院・薬・介護・ハート）が表示され、「家族」アイコンをタップすると選択枠がハイライトされた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/0e28fa3f-1cb9-4fe0-a016-66a020f9b77e.png" width="380" />

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

### **作成に成功すると招待コードダイアログが表示される（8 桁コード + 有効期限の表示）**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
「家族グループ」作成後、8桁コード（M7GT5ACM）と有効期限（2026/07/23 08:14）を含む招待コードダイアログが表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/8204500b-cf81-43fc-a039-868b02dfe174.png" width="380" />

</details>

### **コピーで招待コードがクリップボードに入り、確認の SnackBar が表示される**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
「コードをコピー」タップ後、「招待コードをコピーしました」の SnackBar が表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/8d43a7d2-5d64-474a-a1fb-dd1edb14b984.png" width="380" />

</details>

### **ダイアログを閉じるとグループ一覧に戻り、新しいグループが一覧に表示される**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
ダイアログを閉じるとグループ一覧に戻り、「家族グループ」が新規追加されて表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/bfbe8bf3-e95e-4af1-9f7e-0e91a3883c74.png" width="380" />

</details>

### **作成しても表示中グループ（ホームの表示対象）は切り替わらない（shoppinglist 踏襲の仕様）**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
「家族グループ」作成直後もホームの選択中グループは既定の「マイグループ」のままで、明示的にチップをタップするまで切り替わらないことを確認した。

</details>

### **Firebase Console の `/groups/{新規groupID}` に ownerUserID = 自分・memberUserIDs = [自分] が入っている**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-17**
本番 Firestore（medicalarm-prod）の `/groups/fr1HdTKYsJT55YtcwPk6`（作成した「家族グループ」）を REST API で直接読み取り、`ownerUserID` = A（uid `LnTX76H0cWhUkiD0Wa64mr9KJaa2`）、`memberUserIDs` = `[A]`、`iconName` = `family`、`name` = 「家族グループ」であることを確認した（B 削除後の現在の memberUserIDs も `[A]` で、作成時の状態と一致）。

</details>

</details>

---

## 3. 異常系

- [ ] 機内モード等で作成に失敗した場合、エラーメッセージが表示されボタンが再度押せる
  - ⏭️ スキップ: 本番 Firestore 接続シミュレータでのネットワーク遮断シナリオの再現は今回の QA スコープでは実施しなかった。招待コード参加時の異常系（存在しないコード）でエラー表示 → 再操作可能なパターンは group_invitation QA で確認済み
- [ ] （再現できれば）作成成功後に招待コード発行だけが失敗した場合、再タップで重複グループが作られない（createdGroupID 保持による再試行。再現が難しければ未確認と記録する）
  - ⏭️ スキップ: 再現が難しいため未確認（QA.md 記載の代替方針どおり）

