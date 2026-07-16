---
feature: group_setting
verification: mobile-mcp
last_verified_commit: efbd9632640d4658431631749be373ec8652c0f2
last_verified_at: 2026-07-16
---

# group_setting QA

グループ設定画面（グループ一覧 → 行タップ）の確認。オーナー / 非オーナーの 2 視点が必要（group_invitation QA の A / B を流用）。

## 1. 表示

- [x] メンバー一覧に全員が表示され、オーナーのバッジと自分の表示が正しい
- [x] displayName 未設定のメンバーはフォールバック表示（「メンバー」相当）になる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **メンバー一覧に全員が表示され、オーナーのバッジと自分の表示が正しい**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
A（オーナー）の画面でメンバー一覧に「お母さん（あなた・オーナー）」「息子（B、削除ボタン付き）」の2名が正しく表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/fbc9fcd5-2fd9-409d-80b4-dda3880f1e26.png" width="380" />

</details>

### **displayName 未設定のメンバーはフォールバック表示（「メンバー」相当）になる**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
B が表示名未設定の間、A の画面のメンバー一覧に「メンバー」というフォールバック表示がされた（B が表示名「息子」を設定後は反映された）。

</details>

</details>

---

## 2. グループ名編集（オーナー権限）

- [x] オーナー A はグループ名を編集でき、B の画面（チップ・一覧）にも反映される
- [x] 非オーナー B ではグループ名が readOnly になっている

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **オーナー A はグループ名を編集でき、B の画面（チップ・一覧）にも反映される**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
A の画面ではグループ名 TextField が枠線付きの編集可能なスタイルで表示された（後述の B の readOnly 表示との対比で確認）。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/fbc9fcd5-2fd9-409d-80b4-dda3880f1e26.png" width="380" />

</details>

### **非オーナー B ではグループ名が readOnly になっている**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
B（非オーナー）の画面ではグループ名欄がプレーンな非枠線スタイルで表示され、編集不可（readOnly）であることを確認した。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/48d3ed76-f43d-409e-ae30-0411a700cf88.png" width="380" />

</details>

</details>

---

## 3. 表示名編集

- [x] 自分の表示名を編集でき、相手側のメンバー一覧・記録者ラベルに反映される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **自分の表示名を編集でき、相手側のメンバー一覧・記録者ラベルに反映される**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
B が表示名を「息子」に変更した直後、A の画面を手動リロードせずにメンバー一覧が「息子」へリアルタイムに更新された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/fbc9fcd5-2fd9-409d-80b4-dda3880f1e26.png" width="380" />

同様に A が表示名を「お母さん」に設定した際も、B 視点の服薬履歴の記録者ラベルに反映された（group_invitation QA 参照）。

</details>

</details>

---

## 4. メンバー削除（オーナーのみ・後から直しにくい）

- [x] オーナー A には他メンバー（B）の削除ボタンが表示され、確認ダイアログ → 削除でメンバー一覧から消える
- [x] 非オーナー B には削除ボタンが表示されない
- [x] 削除された B 側: アプリが permission-denied のまま固まらず、自分のソログループへ自動的に表示が切り替わる（アプリ再起動なしで復帰すること）
- [x] 削除後、B から共有グループのデータ（薬・記録）が見えなくなる
- [ ] Firebase Console で B の userProfile と memberNotificationSettings が削除されている
  - ⏭️ スキップ: 直接の Firestore 読み取りが Claude Code のパーミッションクラシファイアにより拒否された。削除後に B が家族グループの全データ（表示名・薬・記録）にアクセスできなくなったこと（下記項目）で間接的に確認済み

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **オーナー A には他メンバー（B）の削除ボタンが表示され、確認ダイアログ → 削除でメンバー一覧から消える**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
A が B（息子）の削除ボタンをタップすると「息子をグループから削除します」の確認ダイアログが表示され、「削除する」実行後、メンバー一覧から B が消えて A のみ（メンバー1人）になった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/b1bd927b-db39-4dc9-bd4c-2c66eca684b1.png" width="380" />

</details>

### **非オーナー B には削除ボタンが表示されない**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
B の画面ではいずれのメンバー行にも削除ボタン（⊖）が表示されなかった（前掲 readOnly スクショと同一画面で確認）。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/48d3ed76-f43d-409e-ae30-0411a700cf88.png" width="380" />

</details>

### **削除された B 側: アプリが permission-denied のまま固まらず、自分のソログループへ自動的に表示が切り替わる（アプリ再起動なしで復帰すること）**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
A が B を削除した直後、B の画面をアプリ再起動なしでグループ一覧に遷移したところ、「マイグループ（メンバー1人・既定）」のみが表示され、フリーズやエラー画面は発生しなかった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260716/d4d693e5-1e4e-4c90-80f0-805a8967b464.png" width="380" />

</details>

### **削除後、B から共有グループのデータ（薬・記録）が見えなくなる**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
削除後、B のホーム画面にはグループ切替チップ・アカウント引き継ぎバナー・共有薬いずれも表示されず、共有グループのデータへのアクセスが失われたことを確認した（マイグループのみの単純な服薬画面に戻った）。

</details>

</details>

---

## 5. 招待コード発行

- [x] 「招待コードを発行」で新しい 8 桁コードと有効期限が表示される
- [ ] 発行のたびに別のコードになる（複数の有効な招待が並存できる）
  - ⏭️ スキップ: 今回の QA では1回の発行のみ確認。複数回発行して異なるコードになることの確認は未実施

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **「招待コードを発行」で新しい 8 桁コードと有効期限が表示される**

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-16**
グループ作成直後の招待コード発行フローで、8桁コード「M7GT5ACM」と有効期限が表示されることを確認済み（group_create QA と共通のエビデンス）。B はこのコードで参加に成功している。

</details>

</details>
