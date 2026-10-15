---
feature: group_invitation
verification: mobile-mcp
last_verified_commit: efbd9632640d4658431631749be373ec8652c0f2
last_verified_at: 2026-07-16
---

# group_invitation QA

招待コード入力・参加画面と、参加後のマルチユーザー同期（本機能の中核・後から直しにくい）の確認。

前提: 2 ユーザーを用意する。
- ユーザー A: シミュレータ 1 台目。共有グループを作成し、薬（スケジュール付き）を登録し、招待コードを発行しておく
- ユーザー B: **2 台目のシミュレータ**（sim-boot で別名シミュレータを起動）を推奨。1 台でやる場合は `xcrun simctl shutdown <UDID>` → `erase` で新規匿名ユーザーにする（Keychain 復元のため erase 必須。root QA.md 参照）が、A のセッションが失われ相互確認ができなくなる

## 1. 入力バリデーション

- [x] 8 桁未満では参加ボタンが無効
- [x] 除外文字（I / L / O / U / Z / 0 / 1 / 2）を含む入力では参加ボタンが無効
- [x] 小文字で入力しても大文字化される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### 8 桁未満では参加ボタンが無効

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
6 文字 (EES8HP) の入力で「参加する」ボタンがグレーの押せない表示だった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/2fa7ccfc-69e5-429e-95e6-e70060cbd113-gi01-short-lowercase.jpg" width="320">

</details>

### 除外文字（I / L / O / U / Z / 0 / 1 / 2）を含む入力では参加ボタンが無効

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
8 文字だが I と 0 を含む「9XCACEI0」の入力で「参加する」ボタンが押せない表示のままだった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/acd346dc-b4aa-4cf6-ad01-47702001ffca-gi06-excluded-chars.jpg" width="320">

</details>

### 小文字で入力しても大文字化される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「abcdefgh」と小文字で入力すると、入力欄が「ABCDEFGH」と大文字で表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/9d28f448-0fb2-46cd-af08-f1a2f68d4e7a-gi02-valid-format-uppercased.jpg" width="320">

</details>

</details>

---

## 2. 参加フロー

- [x] 有効なコードで参加に成功し、表示中グループが参加先に切り替わる
- [x] 使用済みコード（他のユーザーが参加済み）では「既に使用されています」相当のエラーが表示される
- [x] 形式は正しいが存在しないコードではエラーが表示される
- [x] 参加に成功した B が同じコードで再度参加操作をしてもエラーで固まらない（冪等）

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### 有効なコードで参加に成功し、表示中グループが参加先に切り替わる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
A が発行した「6AW4X9Y3」で B が参加すると、B のグループ一覧に参加先 (メンバー2人・既定) が並び、服薬画面が参加先のグループ (A の薬 Sync Med) に切り替わった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/a85b5e23-d7f3-4aae-8c97-02ae6087211a-gi03-joined-list.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/4c0d7322-84c6-4150-8b51-aeb4333732a3-c01-medications-joined.jpg" width="320">

</details>

### 使用済みコード（他のユーザーが参加済み）では「既に使用されています」相当のエラーが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
B が一度参加に使った「6AW4X9Y3」で、A に削除された後の B がもう一度参加しようとすると「Exception: この招待コードは既に使用されています」のエラーが表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/659fb107-818f-490b-8585-1ab004fe5e50-gi05-used-code.jpg" width="320">

</details>

### 形式は正しいが存在しないコードではエラーが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
存在しない「ABCDEFGH」で参加を押すとエラーダイアログが表示され、閉じると入力画面に戻って再操作できた (この時は B の runner から Cloud Functions に届かず「NetworkException」のエラーだった。B を別の runner で起動し直した後は正常に参加できた)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/9d28f448-0fb2-46cd-af08-f1a2f68d4e7a-gi02-valid-format-uppercased.jpg" width="320">

</details>

### 参加に成功した B が同じコードで再度参加操作をしてもエラーで固まらない（冪等）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「9XCACEEC」で参加した B が同じコードでもう一度参加を押すと、エラーにならずグループ一覧に戻り、参加先は「メンバー2人」のまま重複しなかった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/a85b5e23-d7f3-4aae-8c97-02ae6087211a-gi03-joined-list.jpg" width="320">

</details>

</details>

---

## 3. マルチユーザー同期（A・B 両視点）

- [ ] B の参加後、A のグループ設定のメンバー一覧に B がリアルタイムで現れる
  - ❌ 失敗: 3 回の参加のうち 2 回 (1 回目の参加・3 回目の再参加) は A の画面に B が現れたが、A が B を削除した後の 2 回目の再参加では、A のメンバー一覧とグループ一覧が「メンバー1人」のまま更新されず、A のアプリを起動し直すまで B が表示されなかった。原因は未確認。issue: https://github.com/bannzai/medicalarm/issues/404
- [x] B がグループ切替チップで共有グループに切り替えると、A が登録した薬が表示される
- [x] B が服薬チェックすると、A の服薬記録一覧にもB の記録がリアルタイムで現れる
- [x] A から見て B の記録に記録者ラベルが表示される（B の displayName 未設定時は「メンバー」フォールバック）。A 自身の記録にはラベルが出ない
- [x] B がグループ設定で表示名を設定すると、A 側の記録者ラベル・メンバー一覧に反映される
- [ ] B の端末で共有薬のリマインダーローカル通知がスケジュールされる（スケジュール時刻を数分後に設定して通知バナー表示を確認）
  - ⏭️ スキップ: 通知バナーの表示は時刻の経過を待つ必要があり、今回の simtunnel のセッションでは確認していない。予約の内容は DEBUG の Local Notifications 画面で確認できるため、次の QA で確認する
- [x] 非作成者 B の通知個別設定を開くと、初期値で Critical Alert とアラーム機能（AlarmKit）が OFF になっている（共有薬の Critical Alert が勝手に鳴らない設計）
- [x] A が記録済みのスケジュールは B 側でも記録済み表示になる（重複記録にならない）

注: 服薬記録時の他メンバーへの FCM push の**実配信確認は本 QA の対象外**（ユーザー判断で除外。関数の実行は Cloud Logging の sendMedicationRecordNotification のログで確認できれば十分）。

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### B の参加後、A のグループ設定のメンバー一覧に B がリアルタイムで現れる

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### B がグループ切替チップで共有グループに切り替えると、A が登録した薬が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
B の服薬画面の上部に参加先と自分のグループのチップが並び、参加先を選んでいる時は A が登録した Sync Med (08:00・19:00) が表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/4c0d7322-84c6-4150-8b51-aeb4333732a3-c01-medications-joined.jpg" width="320">

</details>

### B が服薬チェックすると、A の服薬記録一覧にもB の記録がリアルタイムで現れる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
2 スケジュール (08:00・19:00) の共有薬で、B が 08:00 をチェックすると A の画面に「13:36 服用済 · メンバーさんが記録」が現れた。続けて A が別のスケジュール 19:00 をチェックしても、A・B 両方の画面で 2 件ともチェック済みのまま残った (#253 の記録消失は再現しなかった)。B が 08:00 のチェックを外すと、A の画面では 08:00 だけが未チェックになって 19:00 は残り、A の履歴に B の記録・B の取消 (メンバーさんが取消)・A の記録の 3 件が並んだ。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/de917326-27e9-45fa-afcd-6a9ef8eba2e4-sync01-a-sees-c-record.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/830f4cae-a115-4fd8-af93-3946d74e7887-sync02-a-both-records.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/e96697fd-a474-47a8-9e90-0b8b94abe911-sync03-c-both-records.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/62c8c57e-6c25-4c6e-ac5a-49b7eeed2236-sync04-a-after-c-revert.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/15940d0f-77f3-4f38-9e50-c0db5a39daf2-sync05-a-history.jpg" width="320">

</details>

### A から見て B の記録に記録者ラベルが表示される（B の displayName 未設定時は「メンバー」フォールバック）。A 自身の記録にはラベルが出ない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
表示名を設定していない B の記録には A の画面で「メンバーさんが記録」と表示され、A 自身の 19:00 の記録には記録者ラベルが出なかった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/de917326-27e9-45fa-afcd-6a9ef8eba2e4-sync01-a-sees-c-record.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/830f4cae-a115-4fd8-af93-3946d74e7887-sync02-a-both-records.jpg" width="320">

</details>

### B がグループ設定で表示名を設定すると、A 側の記録者ラベル・メンバー一覧に反映される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
B が表示名を「Kid」に設定すると、開いたままの A のメンバー一覧に「Kid」が表示された。A が表示名を「Mom」に設定した時は、B の服薬画面の記録者ラベルが「Momさんが記録」に変わった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/5dc178b3-de24-49d9-a062-91b1288908d5-gs14-a-sees-kid.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/303c210a-1c2f-46d1-bb58-9b45b37a3336-sync06-c-name-reflected.jpg" width="320">

</details>

### B の端末で共有薬のリマインダーローカル通知がスケジュールされる（スケジュール時刻を数分後に設定して通知バナー表示を確認）

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### 非作成者 B の通知個別設定を開くと、初期値で Critical Alert とアラーム機能（AlarmKit）が OFF になっている（共有薬の Critical Alert が勝手に鳴らない設計）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
B が A の共有薬 Sync Med の 08:00 の歯車から通知設定を開くと、「服用時の通知」が ON、「フォローアップ通知」「マナーモードでも通知する」「アラーム機能」が OFF だった (アクセシビリティの値で確認。スクリーンショットの取得は MJPEG フレームの取得に失敗した)。

</details>

### A が記録済みのスケジュールは B 側でも記録済み表示になる（重複記録にならない）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
A がチェックした 19:00 は B の画面でも「13:37 服用済 · メンバーさんが記録」の 1 件だけで表示され、重複しなかった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/e96697fd-a474-47a8-9e90-0b8b94abe911-sync03-c-both-records.jpg" width="320">

</details>

</details>
