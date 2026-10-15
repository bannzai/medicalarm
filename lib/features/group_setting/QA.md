---
feature: group_setting
verification: mobile-mcp
last_verified_commit: b28392fae518a7b8dc861588de798f90678346d6
last_verified_at: 2026-10-15
---

# group_setting QA

グループ設定画面（グループ一覧 → 行タップ）の確認。オーナー / 非オーナーの 2 視点が必要（group_invitation QA の A / B を流用）。

## 1. 表示

- [x] メンバー一覧に全員が表示され、オーナーのバッジと自分の表示が正しい
- [x] displayName 未設定のメンバーはフォールバック表示（「メンバー」相当）になる

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### メンバー一覧に全員が表示され、オーナーのバッジと自分の表示が正しい

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
A の画面ではメンバー 2 人が並び、A の行に「あなた」「オーナー」のバッジが付いた。B の画面では A の行に「オーナー」、B の行に「あなた」のバッジが付いた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/47488e7e-4e98-4f8c-aa12-2af8a2994912-gs05-members.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/b2cb88a7-6a70-44f9-a4a8-4b832e537ba9-gs07-c-nonowner.jpg" width="320">

</details>

### displayName 未設定のメンバーはフォールバック表示（「メンバー」相当）になる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
表示名を設定していないメンバーは「メンバー」と表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/47488e7e-4e98-4f8c-aa12-2af8a2994912-gs05-members.jpg" width="320">

</details>

</details>

---

## 2. グループ名編集（オーナー権限）

- [x] オーナー A はグループ名を編集でき、B の画面（チップ・一覧）にも反映される
- [x] 非オーナー B ではグループ名が readOnly になっている

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### オーナー A はグループ名を編集でき、B の画面（チップ・一覧）にも反映される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
A がグループ名を「Family」にして確定すると、B の服薬画面のチップとグループ一覧が「Family」に変わった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/d17db5ed-0862-44b1-8d98-52605307ae36-gs06-a-named.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/303c210a-1c2f-46d1-bb58-9b45b37a3336-sync06-c-name-reflected.jpg" width="320">

</details>

### 非オーナー B ではグループ名が readOnly になっている

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
B のグループ設定ではグループ名が入力欄ではなく表示だけの要素で、タップして文字を打っても「Family」のまま変わらなかった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/b2cb88a7-6a70-44f9-a4a8-4b832e537ba9-gs07-c-nonowner.jpg" width="320">

</details>

</details>

---

## 3. 表示名編集

- [x] 自分の表示名を編集でき、相手側のメンバー一覧・記録者ラベルに反映される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### 自分の表示名を編集でき、相手側のメンバー一覧・記録者ラベルに反映される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
A が表示名を「Mom」にすると B の画面のメンバー一覧と記録者ラベル (Momさんが記録) に反映された。B が「Kid」にすると A のメンバー一覧に反映された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/d17db5ed-0862-44b1-8d98-52605307ae36-gs06-a-named.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/303c210a-1c2f-46d1-bb58-9b45b37a3336-sync06-c-name-reflected.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/5dc178b3-de24-49d9-a062-91b1288908d5-gs14-a-sees-kid.jpg" width="320">

</details>

</details>

---

## 4. メンバー削除（オーナーのみ・後から直しにくい）

- [x] オーナー A には他メンバー（B）の削除ボタンが表示され、確認ダイアログ → 削除でメンバー一覧から消える
- [x] 非オーナー B には削除ボタンが表示されない
- [x] 削除された B 側: アプリが permission-denied のまま固まらず、自分のソログループへ自動的に表示が切り替わる（アプリ再起動なしで復帰すること）
- [x] 削除後、B から共有グループのデータ（薬・記録）が見えなくなる
- [ ] Firebase Console で B の userProfile と memberNotificationSettings が削除されている
  - ⏭️ スキップ: 今回は Firestore のデータを確認していない。削除後に再参加した B の表示名が「メンバー」に戻ったこと (B の userProfile が消えたことと矛盾しない表示) だけを画面で確認した

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### オーナー A には他メンバー（B）の削除ボタンが表示され、確認ダイアログ → 削除でメンバー一覧から消える

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
A の画面で B の行に削除ボタンが表示され、タップすると「メンバーを削除しますか？」の確認ダイアログが出た。「削除する」を選ぶとメンバー一覧から B が消えた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/47488e7e-4e98-4f8c-aa12-2af8a2994912-gs05-members.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/6d0e5646-887a-4c41-82ff-bbb9499d573c-gs08-remove-confirm.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/6c759627-ff81-41ed-b88d-786be0d547aa-gs09-removed.jpg" width="320">

</details>

### 非オーナー B には削除ボタンが表示されない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
B のグループ設定のメンバー一覧には削除ボタンが無かった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/b2cb88a7-6a70-44f9-a4a8-4b832e537ba9-gs07-c-nonowner.jpg" width="320">

</details>

### 削除された B 側: アプリが permission-denied のまま固まらず、自分のソログループへ自動的に表示が切り替わる（アプリ再起動なしで復帰すること）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
服薬画面を開いていた B は、A に削除されるとアプリを起動し直さずに自分のグループ (仮カードの表示) に切り替わり、チップとアカウント引き継ぎのバナーも消えた。グループ設定を開いていた B は、戻るとグループ一覧に自分のグループだけが表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/2ef30af0-8bd5-4fe7-9291-1b71f72fc29b-gs10-c-after-removed.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/fb7ed65f-e798-4e26-b8ea-f0fab20b1931-gs17-c-back-after-removed.jpg" width="320">

</details>

### 削除後、B から共有グループのデータ（薬・記録）が見えなくなる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
削除後の B の服薬画面とグループ一覧に、共有グループの薬 (Sync Med) と共有グループが表示されなかった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/2ef30af0-8bd5-4fe7-9291-1b71f72fc29b-gs10-c-after-removed.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/fb7ed65f-e798-4e26-b8ea-f0fab20b1931-gs17-c-back-after-removed.jpg" width="320">

</details>

### Firebase Console で B の userProfile と memberNotificationSettings が削除されている

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>

---

## 5. 招待コード発行

- [x] 「招待コードを発行」で新しい 8 桁コードと有効期限が表示される
- [x] 発行のたびに別のコードになる（複数の有効な招待が並存できる）

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### 「招待コードを発行」で新しい 8 桁コードと有効期限が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「招待コードを発行」をタップすると 8 桁のコード (6AW4X9Y3) と「有効期限: 2026/10/22 13:32」のダイアログが表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/ade7d7d1-940d-4d4f-a5ea-17b125893f73-gs04-invite.jpg" width="320">

</details>

### 発行のたびに別のコードになる（複数の有効な招待が並存できる）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
同じグループで続けて発行すると毎回別のコードになった (別ユーザーの 2 回、A の 3 回: 6AW4X9Y3 / 9XCACEEC / Q4YA45HR)。後から発行した 9XCACEEC と Q4YA45HR はどちらも参加に使えた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/6fc3e42c-7fbd-419b-8feb-c48dd0e5f44e-gs01-invite-1.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/1b604777-6c42-4957-909c-96ae93e3ea62-gs02-invite-2.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/ade7d7d1-940d-4d4f-a5ea-17b125893f73-gs04-invite.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/d44e0c93-803c-4cbc-8f1a-e604c17daee6-gs11-invite-again.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/c656c29f-15a2-4b18-baf2-7d0489b83534-gs16-invite-3.jpg" width="320">

</details>

</details>
