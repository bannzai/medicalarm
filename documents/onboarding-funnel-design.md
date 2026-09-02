# 課金転換型オンボーディングの設計

初回起動時に表示する、トライアル開始率 (課金転換) を目的としたオンボーディングファネルの設計。実装は `lib/features/onboarding/`。

- 起票元: https://github.com/bannzai/medicalarm/issues/271
- 設計指針: onboarding-design skill の課金転換モード (`references/monetization-onboarding.md`)。リテンション型 (8 つのベストプラクティス) ではなく、質問と演出で「自分ごと化」させてからペイウォールを出す構成を採る

## 表示条件

`OnboardingResolver` (`lib/features/onboarding/resolver.dart`) が `RootPage` の `AppEntityPrepareResolver` と `PromotionStartResolver` の間で判定する。

- `AppUser.onboardingCompletedDateTime` が null (未完了)
- プレミアム (トライアル含む) でない
- `AppUser.createdDateTime` から 1 日以内。この機能のリリース前からの既存ユーザーには表示しない。匿名ユーザーは再インストールでも Keychain から復元されるため、再インストールで再表示されることもない
- 端末の言語が `onboardingSupportedLanguageCodes` (翻訳済み: ja / en) に含まれる。未翻訳の言語ではテンプレート (ja) の文言にフォールバックしてしまうため表示しない

完了はペイウォール (既存の `PremiumIntroductionSheet`) を閉じた時点とし、`OnboardingComplete` (`lib/provider/onboarding.dart`) が `onboardingCompletedDateTime` を書き込む。

既存の `promotion_start` (登録 1 日後以降のトライアル未設定ユーザーへの再エンゲージメント訴求) とは役割を分ける。本ファネルは初回起動直後の 1 回だけの導線で、再エンゲージメントは従来どおり `PromotionStartResolver` が担う。

## ファネル構成

US 長尺 (11 画面 + ペイウォール) と JP 短尺 (7 画面 + ペイウォール) を端末ロケールで出し分ける (`isShortFormOnboarding`: 言語コードが `ja` なら短尺)。短尺では、回答が結果画面に反映されない感情的な演出画面とペインの重ね聞きを省く。

| # | 画面 (`OnboardingStep`) | 段階 | 短尺 | 内容 | 回答の使い道 |
| --- | --- | --- | --- | --- | --- |
| 1 | `welcome` | 価値宣言 | ○ | 「飲み忘れの不安をなくそう」+ 通知 / Critical Alert / 家族管理の 3 特徴 | — |
| 2 | `painForgot` | ペイン認識 | ○ | 薬を飲み忘れたことはあるか (よくある / たまにある / ほとんどない) | 計測のみ (自覚を作る) |
| 3 | `painWorry` | ペイン認識 | × | 飲んだか思い出せず不安になったことは (よくある / たまにある / ない) | 計測のみ |
| 4 | `valueReminder` | 価値提示 | × | 「飲み忘れは気づいた時には遅い」→ 服用時刻の通知と Critical Alert の説明 | — |
| 5 | `careTarget` | パーソナライズ | ○ | 誰の服薬を管理するか (自分 / 家族 / 自分と家族) | 結果画面の服用者数。無料上限 (2 人) 超過でプレミアム訴求 |
| 6 | `dailyDoseCount` | パーソナライズ | ○ | 1 日の服用回数 (1 回 / 2 回 / 3 回以上) | 結果画面の通知回数。無料上限 (スケジュール 2 件) 超過でプレミアム訴求 |
| 7 | `medicineCount` | パーソナライズ | ○ | 管理する薬の数 (1〜2 / 3〜5 / 6 以上) | 結果画面の薬の数。無料上限 (2 種類) 超過でプレミアム訴求 |
| 8 | `beforeAfter` | 価値提示 | × | これまで (飲み忘れ / 記憶の不安 / 家族の把握) → これから (通知 / 記録 / ひと目で把握) | — |
| 9 | `goal` | コミットメント | × | 目標を決める (飲み忘れゼロ / 記録の継続 / 家族の見守り) | 結果画面の見出し下に「目標: …」として表示 |
| 10 | `planGenerating` | プラン生成演出 | ○ | 2.4 秒のプログレス + 3 段階のメッセージ。自動で次へ | — |
| 11 | `planResult` | 結果提示 | ○ | 回答をまとめた「あなた専用のプラン」カード。上限超過なら「プレミアムプランがおすすめ」を添える | CTA「プランを始める」でペイウォールへ |
| 12 | ペイウォール | ペイウォール | ○ | 既存の `PremiumIntroductionSheet` (月額 / 年額)。閉じるとホームへ | — |

コミットメント演出は「目標設定の入力」方式を採る。署名や長押しは世界観 (服薬管理) に合わず、アクセシビリティと E2E の手間も増えるため採らない。JP では実利のない演出として省く。

質問画面はタップで即座に次へ進み、AppBar のプログレスバーで残量を示す。質問画面では戻るボタンで前の質問へ戻れる (回答は保持)。価値宣言・プラン生成・結果提示では戻るボタンを出さない。通知許可の OS ダイアログは従来どおりホーム画面表示時に出るため、ファネル完了後 (通知プランを提示した文脈の直後) に要求される。

## 計測イベント

`monetization-onboarding.md` の「計測イベントの最低セット」に対応する Firebase Analytics イベント。

| 最低セット | イベント | パラメータ |
| --- | --- | --- |
| インストール | `first_open` (Firebase 自動収集) | — |
| オンボーディング開始 | `onboarding_started` | `form` (short / long), `total` |
| 各ステップ表示 | `onboarding_step_shown` | `step`, `index`, `total` |
| 回答 | `onboarding_answered` | `step`, `answer` |
| 戻る | `onboarding_back_pressed` | `step` |
| 結果画面 CTA | `onboarding_plan_start_pressed` | `recommends_premium` |
| オンボーディング完了 | `onboarding_completed` | `form` |
| ペイウォール表示 | `onboarding_paywall_shown` (加えて既存の `screen_PremiumIntroductionSheet`) | — |
| ペイウォール閉じる | `onboarding_paywall_closed` | — |
| トライアル開始 / 購入完了 | `purchase_completed` | `product_identifier`, `period_type` (trial / intro / normal) |

見る指標: ペイウォール到達率 (`onboarding_started` → `onboarding_paywall_shown`)、ステップ別の離脱 (`onboarding_step_shown` の `index` 分布)、トライアル開始率 (`onboarding_paywall_shown` → `purchase_completed` で `period_type = trial`)。

## 今後の検討

- トライアル構成 (無料短期 vs 少額長期の 2 択、価格アンカー) は RevenueCat の offering 設計に依存するため本設計の対象外。ペイウォール離脱への手当て (解約時オファー等) も同様
- US 長尺 / JP 短尺は仮説に基づく初期方針。`form` パラメータで完了率・トライアル開始率を比較して見直す
- 回答 (服用回数・薬の数) を薬登録フォームの初期値に使う導線は未実装
