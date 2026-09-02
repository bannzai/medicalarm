---
feature: onboarding
verification: maestro, mobile-mcp
last_verified_commit: 90f723b1ead9d5e66c12ce4331a8e8b602a105e8
last_verified_at: 2026-09-03
---

# onboarding QA

初回起動時の課金転換型オンボーディング (価値宣言 → 質問 → プラン生成 → 結果提示 → ペイウォール) の確認。

## 関連リンク

- 仕様: documents/onboarding-funnel-design.md
- 関連: https://github.com/bannzai/medicalarm/issues/271

**到達手順**: 新規の匿名ユーザーで起動する。`xcrun simctl shutdown <UDID>` → `xcrun simctl erase <UDID>` でシミュレータを初期化してから起動すると、AppUser が新規作成され (作成から 1 日以内・完了記録なし) オンボーディングが表示される。既存ユーザー (作成から 1 日超) には表示されない。

**操作手段の注意**: このファネルの手動操作には maestro を使う。mobile-mcp (WebDriverAgent) は `Running tests...` で XCUITest runner を前面に出すためアプリがバックグラウンドに落ち、`mobile_list_elements_on_screen` がアプリではなく Springboard の要素を返す・Flutter の debug connection が切れる。詳細は root QA.md の「再現が難しい操作の手順」を参照。

**プラン生成演出 (約 2.4 秒) の撮影手順**: maestro の `takeScreenshot` は tap 後の settle 待ちで演出が終わった後に撮れてしまう。別シェルで `xcrun simctl io <UDID> screenshot` を連続実行するループを回した状態で maestro のタップ flow を走らせ、後からフレームを選ぶ。

## 仕様チェックリスト

| ID | 期待挙動 | 対応項目 |
|----|---------|---------|
| S1 | 新規ユーザーの初回起動でオンボーディングが表示される | 初回起動で表示 |
| S2 | 日本語ロケールでは 7 画面 (価値宣言 / 飲み忘れ / 管理対象 / 服用回数 / 薬の数 / プラン生成 / 結果) の短尺になる | JP 短尺の完走 |
| S3 | 日本語以外のロケールでは 11 画面の長尺になる | US 長尺の完走 |
| S4 | 質問画面の戻るボタンで前の質問に戻り、回答が保持される | 戻る操作 |
| S5 | 結果画面に回答が反映され、無料上限を超える回答ではプレミアム訴求が出る | 結果画面の反映 |
| S6 | 結果画面の CTA でプレミアム紹介シートが開き、閉じるとホームに到達する | ペイウォールへの接続 |
| S7 | 完了後は再起動しても再表示されない | 再表示されない |

## 1. 表示条件

- [x] **初回起動で表示**: シミュレータ初期化後の起動で、通知許可 / ATT ダイアログの前後に「飲み忘れの不安をなくそう」の画面が表示される
  - 自動化: auto (maestro/flows/allow_notification.yaml が「はじめる」を検出して onboarding.yaml を実行する)
- [x] **再表示されない**: ペイウォールを閉じてホームに到達した後、アプリを再起動しても直接服薬画面が表示される
  - 自動化: manual (再起動の操作が必要。`xcrun simctl terminate <UDID> com.bannzai.medicalarm` → `xcrun simctl launch <UDID> com.bannzai.medicalarm`)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **初回起動で表示**: シミュレータ初期化後の起動で、通知許可 / ATT ダイアログの前後に「飲み忘れの不安をなくそう」の画面が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-09-03**
`xcrun simctl erase` した新規匿名ユーザー状態で起動すると、通知許可 / ATT ダイアログより前に「飲み忘れの不安をなくそう」の価値宣言画面が表示された (プログレスバーは 1/7)。`maestro test --udid <UDID> maestro/flows/allow_notification.yaml` も「はじめる」を検出して onboarding.yaml を実行し exit 0 で完了した。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/72220832-563f-4437-b80d-c01a26d1cc8e-01-welcome.png" width="320">

</details>

### **再表示されない**: ペイウォールを閉じてホームに到達した後、アプリを再起動しても直接服薬画面が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-09-03**
ペイウォールを閉じて服薬画面に到達した後、`xcrun simctl terminate` → `xcrun simctl launch` で再起動したところ、オンボーディングは表示されず直接服薬画面が表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/55dd64fe-47ea-49da-a2a7-0cd903527222-m11-relaunch.png" width="320">

</details>

</details>

---

## 2. ファネルの完走

- [x] **JP 短尺の完走**: 「はじめる」→「たまにある」→「自分」→「2回」→「1〜2種類」の順にタップすると、プラン生成演出 (約 2.4 秒) を経て「あなた専用のプラン」が表示される。プログレスバーが進む
  - 自動化: auto (maestro/flows/onboarding.yaml)
- [x] **US 長尺の完走**: シミュレータの言語を英語にして起動すると、「Have you ever missed a dose?」の後に「Ever felt anxious...」「By the time you notice...」、質問 3 つの後に「What changes with Medicalarm」「Set your goal」が挟まり、結果画面に「Goal: …」が表示される
  - 自動化: manual (シミュレータの言語切り替えが必要)。手順: `xcrun simctl shutdown <UDID>` → `xcrun simctl erase <UDID>` → `xcrun simctl boot <UDID>` → `xcrun simctl install <UDID> build/ios/iphonesimulator/Runner.app` → `xcrun simctl launch <UDID> com.bannzai.medicalarm -AppleLanguages "(en)" -AppleLocale en_US`
- [x] **戻る操作**: 質問画面の左上の戻るボタンで前の質問に戻り、回答済みの選択肢が強調表示される。価値宣言・プラン生成・結果画面には戻るボタンが無い
  - 自動化: manual (maestro の `tapOn: point: "7%,10%"` で戻るボタンをタップする。戻るボタンにテキストラベルが無いため座標指定になる)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **JP 短尺の完走**: 「はじめる」→「たまにある」→「自分」→「2回」→「1〜2種類」の順にタップすると、プラン生成演出 (約 2.4 秒) を経て「あなた専用のプラン」が表示される。プログレスバーが進む

<details><summary>動作確認スクショ</summary>

**確認日: 2026-09-03**
日本語ロケールで 7 画面の短尺になることを確認した (ログにも `onboarding_started {form: short, total: 7}` が出力される)。「たまにある」→「自分」→「2回」→「1〜2種類」の順にタップして、プラン生成演出 (「あなた専用のプランを作成中」+ 円形プログレス + 「準備ができました」) を経て「あなた専用のプラン」に到達した。各画面でプログレスバーが 1/7 → 2/7 → 3/7 → 4/7 → 5/7 → ほぼ満杯 → 満杯と進むことも確認した。`maestro test --udid <UDID> maestro/flows/allow_notification.yaml` (onboarding.yaml を実行) は exit 0。
価値宣言 (1/7):
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/72220832-563f-4437-b80d-c01a26d1cc8e-01-welcome.png" width="320">
飲み忘れ質問 (2/7):
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/24896cc7-05a9-4faa-82c7-7ac358e4d1ed-m02-pain-forgot.png" width="320">
管理対象 (3/7):
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/aaa80b9d-096b-4403-995a-45e3a315f0ba-m03-care-target.png" width="320">
服用回数 (4/7):
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/afbbfae5-b2c6-489b-b5a8-036acfe0adc5-m05-daily-dose-count.png" width="320">
薬の数 (5/7):
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/b8aaa71a-a8ab-4c0c-9a0b-6d878d18bd9f-m06-medicine-count.png" width="320">
プラン生成演出:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/47f4ea6a-e384-439d-ba3b-a10434b2585a-m07b-plan-generating.png" width="320">
結果画面:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/c22d3e6f-e0e6-4d7c-8b11-c023acafa160-r03-plan-result-ja.png" width="320">

</details>

### **US 長尺の完走**: シミュレータの言語を英語にして起動すると、「Have you ever missed a dose?」の後に「Ever felt anxious...」「By the time you notice...」、質問 3 つの後に「What changes with Medicalarm」「Set your goal」が挟まり、結果画面に「Goal: …」が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-09-03**
シミュレータを erase して英語で起動し、「Get started」→「Often」(Have you ever missed a dose?) →「Often」(Ever felt anxious…) →「Next」(By the time you notice…) →「Myself and my family」→「3 times or more」→「6 or more」→「Next」(What changes with Medicalarm) →「Watch over my family's medication」(Set your goal) の順にタップして完走した。結果画面に「Goal: Watch over my family's medication」と「Premium plan recommended」が表示された。
価値宣言 (1/11):
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/d3987acc-783d-4fbb-a44c-7234de02a64d-u01-welcome.png" width="320">
ペイン 2 問目 (Ever felt anxious…):
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/092c4ac5-9d0e-4691-93da-6acb8e2ea6c9-u03-pain-worry.png" width="320">
価値提示 (By the time you notice…):
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/47dd3c96-29d9-4241-8aff-ec989d26a9d9-u04-value-reminder.png" width="320">
Before/After (What changes with Medicalarm):
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/059ca03c-3311-4a59-825d-18f5dc3272e2-u06-before-after.png" width="320">
目標設定 (Set your goal):
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/387e0dc7-4255-4dba-a938-46fe8d2cb318-u07-goal.png" width="320">
結果画面 (Goal: … / Premium plan recommended):
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/506c239b-af95-44ac-8378-3cf9d9bc7ed4-r04-plan-result-en.png" width="320">

</details>

### **戻る操作**: 質問画面の左上の戻るボタンで前の質問に戻り、回答済みの選択肢が強調表示される。価値宣言・プラン生成・結果画面には戻るボタンが無い

<details><summary>動作確認スクショ</summary>

**確認日: 2026-09-03**
管理対象の質問画面 (3/7) で左上の戻るボタンをタップすると飲み忘れ質問 (2/7) に戻り、直前に選んだ「たまにある」がピンクの枠線と塗りで強調表示された。プログレスバーも 2/7 に戻る。価値宣言・プラン生成・結果画面のスクショには戻るボタンが無いことも確認済み (上記「JP 短尺の完走」のスクショ)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/0552f814-d659-4aef-bca0-4c4bec327aa2-m04-back-highlight.png" width="320">

</details>

</details>

---

## 3. 結果提示とペイウォール

- [x] **結果画面の反映**: 結果画面のカードに選んだ服用者・1 日の通知・管理する薬の回答が表示される。「自分と家族」「3回以上」「3〜5種類」のいずれかを選ぶと「プレミアムプランがおすすめ」が表示され、「自分」「2回」「1〜2種類」ではプレミアム訴求が出ない
  - 自動化: manual (回答の組み合わせを変えて 2 パターン確認する必要がある)
- [x] **ペイウォールへの接続**: 「プランを始める」で既存のプレミアム紹介シート (月額 / 年額ボタン) が開き、左上の閉じるボタンで閉じると服薬画面が表示される
  - 自動化: auto (maestro/flows/onboarding.yaml)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **結果画面の反映**: 結果画面のカードに選んだ服用者・1 日の通知・管理する薬の回答が表示される。「自分と家族」「3回以上」「3〜5種類」のいずれかを選ぶと「プレミアムプランがおすすめ」が表示され、「自分」「2回」「1〜2種類」ではプレミアム訴求が出ない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-09-03**
無料上限内の回答 (JP:「自分」「2回」「1〜2種類」) では、カードに 服用者=自分 / 1日の通知=2回 / 管理する薬=1〜2種類 が表示され、プレミアム訴求は出なかった。無料上限を超える回答 (US:「Myself and my family」「3 times or more」「6 or more」) では、カードに回答が反映された上で「Premium plan recommended」が表示された。
無料上限内 (プレミアム訴求なし):
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/c22d3e6f-e0e6-4d7c-8b11-c023acafa160-r03-plan-result-ja.png" width="320">
上限超過 (プレミアム訴求あり):
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/506c239b-af95-44ac-8378-3cf9d9bc7ed4-r04-plan-result-en.png" width="320">

</details>

### **ペイウォールへの接続**: 「プランを始める」で既存のプレミアム紹介シート (月額 / 年額ボタン) が開き、左上の閉じるボタンで閉じると服薬画面が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-09-03**
結果画面の「プランを始める」で既存の PremiumIntroductionSheet (「プレミアムプラン」ヘッダー・月額プラン $2.99 / 年額プラン $22.99) が開き、左上の閉じるボタン (×) で閉じると通知許可ダイアログを経て服薬画面 (タブバー: 服薬 / 履歴 / カレンダー / 設定) に到達した。`maestro test --udid <UDID> maestro/flows/allow_notification.yaml` (onboarding.yaml がペイウォールの開閉まで実行) は exit 0。
プレミアム紹介シート:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/121f0494-a250-4c51-a058-22aa897a3fdf-m09-paywall.png" width="320">
閉じた後の服薬画面 (mobile 操作):
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/8f1e150b-b9a7-4244-a6f0-ed8fc0f9b2d0-m10-medications.png" width="320">
maestro flow 実行後の服薬画面:
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/09/02/668812e2-46c3-455f-a118-2a1efa11c1ce-m12-maestro-home.png" width="320">

</details>

</details>

---
