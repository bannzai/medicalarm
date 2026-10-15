---
feature: account_link
verification: mobile-mcp
last_verified_commit: efbd9632640d4658431631749be373ec8652c0f2
last_verified_at: 2026-07-16
---

# account_link QA

アカウント引き継ぎ（匿名 → Apple / Google リンク）の UI とバナー表示条件の確認。

**制約**: 実際の Apple / Google リンクの成功は、Firebase Console でのプロバイダ有効化・GoogleService-Info.plist の再配置・Xcode の Sign in with Apple capability 設定（PR #243 body の「デプロイ前にユーザーがやること」参照）が完了するまで**確認不可**。未完了の間は「タップでエラーが表示され、アプリが壊れないこと」までを確認する。

## 1. ホームバナーの表示条件

- [x] 所属グループがすべて 1 人の間、ホームにアカウント引き継ぎバナーが表示されない
- [x] メンバー 2 人以上のグループに所属すると、ホーム上部にバナーが表示される
- [x] バナーに閉じるボタンがない（強い推奨のため常時表示の仕様）
- [x] バナータップでアカウントリンクのシートが開く

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### 所属グループがすべて 1 人の間、ホームにアカウント引き継ぎバナーが表示されない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
1 人のグループだけに所属している新規ユーザーと、共有グループから削除された後の B のホームには、アカウント引き継ぎのバナーが表示されなかった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/c0d369a6-655f-4e1e-9791-bff08015c6ab-ob11-placeholder-cards.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/2ef30af0-8bd5-4fe7-9291-1b71f72fc29b-gs10-c-after-removed.jpg" width="320">

</details>

### メンバー 2 人以上のグループに所属すると、ホーム上部にバナーが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
2 人のグループに参加した B と、B が参加した A のホーム上部に「グループ共有中はアカウント引き継ぎ設定を強くおすすめします」のバナーが表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/4c0d7322-84c6-4150-8b51-aeb4333732a3-c01-medications-joined.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/de917326-27e9-45fa-afcd-6a9ef8eba2e4-sync01-a-sees-c-record.jpg" width="320">

</details>

### バナーに閉じるボタンがない（強い推奨のため常時表示の仕様）

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
バナーには右端の矢印だけがあり、閉じるボタンは無かった。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/4c0d7322-84c6-4150-8b51-aeb4333732a3-c01-medications-joined.jpg" width="320">

</details>

### バナータップでアカウントリンクのシートが開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
バナーをタップすると「アカウント引き継ぎ」のシート (説明文と「Apple でアカウントを引き継ぐ」「Google でアカウントを引き継ぐ」) が開いた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/8b592d5a-d061-40b4-8d41-f3cacce18779-al05-banner-sheet.jpg" width="320">

</details>

</details>

---

## 2. 設定画面のセクション

- [x] 設定タブに「アカウント引き継ぎ」セクションがあり、Apple でリンク / Google でリンクの行が表示される
- [x] （Console 設定完了前）タップするとエラーが表示されるが、アプリはクラッシュせず操作を継続できる
- [ ] （Console 設定完了後）Apple / Google のリンクに成功するとリンク済み表示に変わり、バナーが消える
  - ⏭️ スキップ: Google は Info.plist の GIDClientID が未設定、Apple は Apple アカウントにサインインした端末が必要で、リンクを成功させられない。Firebase Console の設定と実機での確認はユーザー作業として #340 に移管した
- [ ] （Console 設定完了後）リンク後も薬・記録・グループのデータがそのまま表示される（uid が変わらないこと）
  - ⏭️ スキップ: 同上。リンクを成功させられないため #340 に移管した

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### 設定タブに「アカウント引き継ぎ」セクションがあり、Apple でリンク / Google でリンクの行が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
設定タブに「アカウント引き継ぎ」セクションと「Apple でアカウントを引き継ぐ」「Google でアカウントを引き継ぐ」の行が表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/85a53b2e-82f6-4ccb-b357-37fd5a23e388-al04-settings-after.jpg" width="320">

</details>

### （Console 設定完了前）タップするとエラーが表示されるが、アプリはクラッシュせず操作を継続できる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
Google の行では「PlatformException(google_sign_in, No active configuration. Make sure GIDClientID is set in Info.plist., ...)」のエラーダイアログが表示された。Apple の行では Simulator が Apple アカウント未サインインのため OS のダイアログが出て、閉じると「SignInWithAppleAuthorizationException(... エラー1000)」のエラーダイアログが表示された。どちらも閉じた後に設定画面を操作できた。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/189edb23-2703-4446-930a-d6de51f922b7-al01-google.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/f435379e-3625-41fa-9bbb-92676e0dd4c0-al02-apple.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/1bf1b115-73fb-41c7-8762-aa5b9a005871-al03-apple-closed.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/85a53b2e-82f6-4ccb-b357-37fd5a23e388-al04-settings-after.jpg" width="320">

</details>

### （Console 設定完了後）Apple / Google のリンクに成功するとリンク済み表示に変わり、バナーが消える

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

### （Console 設定完了後）リンク後も薬・記録・グループのデータがそのまま表示される（uid が変わらないこと）

<details><summary>動作確認スクショ</summary>

（未実行）

</details>

</details>
