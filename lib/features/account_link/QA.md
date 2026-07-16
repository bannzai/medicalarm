---
feature: account_link
verification: mobile-mcp
last_verified_commit: null
last_verified_at: null
---

# account_link QA

アカウント引き継ぎ（匿名 → Apple / Google リンク）の UI とバナー表示条件の確認。

**制約**: 実際の Apple / Google リンクの成功は、Firebase Console でのプロバイダ有効化・GoogleService-Info.plist の再配置・Xcode の Sign in with Apple capability 設定（PR #243 body の「デプロイ前にユーザーがやること」参照）が完了するまで**確認不可**。未完了の間は「タップでエラーが表示され、アプリが壊れないこと」までを確認する。

## 1. ホームバナーの表示条件

- [ ] 所属グループがすべて 1 人の間、ホームにアカウント引き継ぎバナーが表示されない
- [ ] メンバー 2 人以上のグループに所属すると、ホーム上部にバナーが表示される
- [ ] バナーに閉じるボタンがない（強い推奨のため常時表示の仕様）
- [ ] バナータップでアカウントリンクのシートが開く

## 2. 設定画面のセクション

- [ ] 設定タブに「アカウント引き継ぎ」セクションがあり、Apple でリンク / Google でリンクの行が表示される
- [ ] （Console 設定完了前）タップするとエラーが表示されるが、アプリはクラッシュせず操作を継続できる
- [ ] （Console 設定完了後）Apple / Google のリンクに成功するとリンク済み表示に変わり、バナーが消える
- [ ] （Console 設定完了後）リンク後も薬・記録・グループのデータがそのまま表示される（uid が変わらないこと）
