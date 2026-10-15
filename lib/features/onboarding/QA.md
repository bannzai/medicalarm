---
feature: onboarding
verification: maestro, mobile-mcp
last_verified_commit: e5dcb6401545189dd7116f2f1b066521cb099053
last_verified_at: 2026-10-15
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
| S6 | 結果画面の CTA でプレミアム紹介シートが開き、閉じると薬登録の案内を経てホームに到達する | ペイウォールへの接続 |
| S7 | 完了後は再起動しても再表示されない | 再表示されない |

## 1. 表示条件

- [x] **初回起動で表示**: シミュレータ初期化後の起動で、通知許可 / ATT ダイアログの前後に「飲み忘れの不安をなくそう」の画面が表示される
  - 自動化: auto (maestro/flows/helpers/allow_notification.yaml が「はじめる」を検出して onboarding.yaml を実行する)
- [x] **再表示されない**: ペイウォールを閉じてホームに到達した後、アプリを再起動しても直接服薬画面が表示される
  - 自動化: manual (再起動の操作が必要。`xcrun simctl terminate <UDID> com.bannzai.medicalarm` → `xcrun simctl launch <UDID> com.bannzai.medicalarm`)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **初回起動で表示**: シミュレータ初期化後の起動で、通知許可 / ATT ダイアログの前後に「飲み忘れの不安をなくそう」の画面が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
simtunnel (iPhone 17) に新規インストールしたアプリを日本語ロケールで起動すると、通知許可・ATT ダイアログより前に「飲み忘れの不安をなくそう」の価値宣言画面が表示された (プログレスバー 1/7)。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/6eb92f56-685d-4e52-a955-cbef3f518bf6-ob01-welcome.jpg" width="320">

</details>

### **再表示されない**: ペイウォールを閉じてホームに到達した後、アプリを再起動しても直接服薬画面が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
ペイウォールを閉じて「あとで」で服薬画面に到達した後、アプリを終了して起動し直すと、オンボーディングは表示されず服薬画面 (仮カード付き) が表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/d8e1b0cd-a3d8-4a20-8ad9-882f872abbab-ob12-relaunch.jpg" width="320">

</details>

</details>

---

## 2. ファネルの完走

- [x] **JP 短尺の完走**: 「はじめる」→「たまにある」→「自分」→「2回」→「1〜2種類」の順にタップすると、プラン生成演出 (約 2.4 秒) を経て「あなた専用のプラン」が表示される。プログレスバーが進む
  - 自動化: auto (maestro/flows/helpers/onboarding.yaml)
- [x] **US 長尺の完走**: シミュレータの言語を英語にして起動すると、「Have you ever missed a dose?」の後に「Ever felt anxious...」「By the time you notice...」、質問 3 つの後に「What changes with Medicalarm」「Set your goal」が挟まり、結果画面に「Goal: …」が表示される
  - 自動化: manual (シミュレータの言語切り替えが必要)。手順: `xcrun simctl shutdown <UDID>` → `xcrun simctl erase <UDID>` → `xcrun simctl boot <UDID>` → `xcrun simctl install <UDID> build/ios/iphonesimulator/Runner.app` → `xcrun simctl launch <UDID> com.bannzai.medicalarm -AppleLanguages "(en)" -AppleLocale en_US`
- [x] **戻る操作**: 質問画面の左上の戻るボタンで前の質問に戻り、回答済みの選択肢が強調表示される。価値宣言・プラン生成・結果画面には戻るボタンが無い
  - 自動化: manual (maestro の `tapOn: point: "7%,10%"` で戻るボタンをタップする。戻るボタンにテキストラベルが無いため座標指定になる)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **JP 短尺の完走**: 「はじめる」→「たまにある」→「自分」→「2回」→「1〜2種類」の順にタップすると、プラン生成演出 (約 2.4 秒) を経て「あなた専用のプラン」が表示される。プログレスバーが進む

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「はじめる」→「たまにある」→「自分」→「2回」→「1〜2種類」の順にタップし、プラン生成演出 (「あなた専用のプランを作成中」) を経て「あなた専用のプラン」に到達した。プログレスバーの値は 14 → 29 → 43 → 57 → 71 → 100 (アクセシビリティの値) と進んだ。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/6eb92f56-685d-4e52-a955-cbef3f518bf6-ob01-welcome.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/58869b45-7033-4b8c-b8b4-e2a93f0852af-ob02-pain-forgot.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/bc69018f-4b2c-4176-9115-10a34a89bb0f-ob03-care-target.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/9239127b-c433-4234-adfd-09841ad89e92-ob05-daily-dose-count.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/32508dff-de91-4714-86e2-a82ab2cc6906-ob06-medicine-count.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/b09dc26d-bc2e-452e-9f54-789ec329195d-ob07-plan-generating.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/1a657f61-6ce0-4bf0-a2a0-238e0aaa038a-ob08-plan-result-ja.jpg" width="320">

</details>

### **US 長尺の完走**: シミュレータの言語を英語にして起動すると、「Have you ever missed a dose?」の後に「Ever felt anxious...」「By the time you notice...」、質問 3 つの後に「What changes with Medicalarm」「Set your goal」が挟まり、結果画面に「Goal: …」が表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
新規インストールしたアプリを `-AppleLanguages (en) -AppleLocale en_US` で起動すると、「Say goodbye to missed doses」→「Have you ever missed a dose?」→「Ever felt anxious because…」→「By the time you notice…」→ 管理対象・回数・薬の数の質問 3 つ →「What changes with Medicalarm」→「Set your goal」と進み、結果画面「Your personal plan」に「Goal: Never miss a dose」が表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/9a2f9a37-4785-4e3b-b727-94fbaf9ff2d4-us01-welcome.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/2b1221dd-2f53-4652-9b94-185410093819-us02.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/dc450e94-c2a0-41ee-a79d-a98457b33dd4-us03.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/3f64671c-e67f-4415-b100-674f5ce754a3-us04.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/ce959c03-18ca-4185-b294-24e7e00e0b11-us05.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/a676a03f-ed36-4771-ab92-fc9dc473c117-us06.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/141aa46d-fe8f-4fb3-af1b-d439e87c0f48-us07.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/4479c1ec-4e7c-463e-9fe2-86145aac1f27-us08.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/6fea72be-2a32-4a3b-8387-83322d69cd56-us09.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/29930130-bf80-44a9-a8c4-c55ad55800b3-us10.jpg" width="320">

</details>

### **戻る操作**: 質問画面の左上の戻るボタンで前の質問に戻り、回答済みの選択肢が強調表示される。価値宣言・プラン生成・結果画面には戻るボタンが無い

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
管理対象の質問画面 (3/7) で左上の戻るボタンをタップすると飲み忘れ質問 (2/7) に戻り、直前に選んだ「たまにある」が枠線と塗りで強調表示された。価値宣言・プラン生成演出の画面には戻るボタンが無い。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/f8722806-eefc-45e2-8d3c-4cf2a96669c0-ob04-back-highlight.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/b09dc26d-bc2e-452e-9f54-789ec329195d-ob07-plan-generating.jpg" width="320">

</details>

</details>

---

## 3. 結果提示とペイウォール

- [x] **結果画面の反映**: 結果画面のカードに選んだ服用者・1 日の通知・管理する薬の回答が表示される。「自分と家族」「3回以上」「3〜5種類」のいずれかを選ぶと「プレミアムプランがおすすめ」が表示され、「自分」「2回」「1〜2種類」ではプレミアム訴求が出ない
  - 自動化: manual (回答の組み合わせを変えて 2 パターン確認する必要がある)
- [x] **ペイウォールへの接続**: 「プランを始める」で既存のプレミアム紹介シートが開き、閉じると最初の薬登録の案内が表示される。「あとで」を選ぶと回答した回数分の仮カードを持つ服薬画面へ進む
  - 自動化: auto (maestro/flows/helpers/onboarding.yaml)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **結果画面の反映**: 結果画面のカードに選んだ服用者・1 日の通知・管理する薬の回答が表示される。「自分と家族」「3回以上」「3〜5種類」のいずれかを選ぶと「プレミアムプランがおすすめ」が表示され、「自分」「2回」「1〜2種類」ではプレミアム訴求が出ない

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「自分」「2回」「1〜2種類」ではカードに回答が表示され、プレミアム訴求は出なかった。別の新規ユーザーで「自分と家族」「3回以上」「3〜5種類」を選ぶと、カードに回答が反映された上で「プレミアムプランがおすすめ」と無料上限を超える旨が表示された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/1a657f61-6ce0-4bf0-a2a0-238e0aaa038a-ob08-plan-result-ja.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/9bd964cc-2cc6-469e-95c6-b3590a0656d8-ob15-plan-result-premium.jpg" width="320">

</details>

### **ペイウォールへの接続**: 「プランを始める」で既存のプレミアム紹介シートが開き、閉じると最初の薬登録の案内が表示される。「あとで」を選ぶと回答した回数分の仮カードを持つ服薬画面へ進む

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
「プランを始める」でプレミアム紹介シート (月額 $2.99 / 年額 $22.99) が開き、閉じると「最初のお薬を登録しましょう」の案内 (08:00・19:00) が表示された。「あとで」を選ぶと ATT・通知許可を経て、08:00・19:00 の仮カードを持つ服薬画面に進んだ。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/57a9acd0-d3e3-473a-82f8-41f1eddbe3eb-ob09-paywall.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/45a5ae72-856d-4c5f-a5fb-23d591c050cc-ob10-registration-guide.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/c0d369a6-655f-4e1e-9791-bff08015c6ab-ob11-placeholder-cards.jpg" width="320">

</details>

</details>

---

## 4. 最初の薬登録

- [x] **回答した時刻の引き継ぎ**: 2回の回答で登録案内に08:00・19:00が表示され、お薬を追加するとフォームにも同じ時刻が初期入力される。時刻は編集できる
  - 自動化: auto (maestro/flows/onboarding_medication_plan.yaml)
- [x] **フォームを閉じた場合**: 保存せず閉じると服薬画面へ進み、お薬が未登録の仮カードが残る
  - 自動化: auto (maestro/flows/onboarding_medication_plan.yaml)
- [x] **登録後の仮カード解除**: 最初のお薬を保存すると実際の薬名と服薬チェック欄が表示され、仮カードと薬登録案内の通知が解除される
  - 自動化: auto (maestro/flows/onboarding_medication_plan.yaml)

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **回答した時刻の引き継ぎ**: 2回の回答で登録案内に08:00・19:00が表示され、お薬を追加するとフォームにも同じ時刻が初期入力される。時刻は編集できる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
2回の回答で登録案内に 08:00・19:00 が表示され、仮カードの「お薬を追加」から開いたフォームに 08:00・19:00 が初期入力された。08:00 をタップして時刻ピッカーで 09:00 に変更でき、行に反映された。別の新規ユーザー (3回以上) では登録案内の「お薬を追加」から直接フォームへ進め、無料上限の 2 件 (08:00・12:00) が初期入力された。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/45a5ae72-856d-4c5f-a5fb-23d591c050cc-ob10-registration-guide.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/26cef2f6-b5ad-45a9-bd5a-5463250c683e-mf01-form-prefilled.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/e75cc4dd-01ee-4beb-9a09-8c39d619b02b-mf02-time-edited.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/caf0a2ad-9fed-45f1-92f8-6b29580af601-ob16-guide-to-form-capped.jpg" width="320">

</details>

### **フォームを閉じた場合**: 保存せず閉じると服薬画面へ進み、お薬が未登録の仮カードが残る

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
仮カードから開いたフォームを保存せず左上の戻るで閉じると、服薬画面に 08:00・19:00 の仮カードが残った。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/d6fc4709-c63c-4b1e-911e-16e750c5a2f1-ob13-placeholder-remains.jpg" width="320">

</details>

### **登録後の仮カード解除**: 最初のお薬を保存すると実際の薬名と服薬チェック欄が表示され、仮カードと薬登録案内の通知が解除される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-10-15**
薬名「QA Medicine」で保存すると、実際の薬名と服薬チェック欄のカードに切り替わり、仮カードは消えた。別の新規ユーザーで DEBUG の Local Notifications を開くと、仮カード 2 枚に対して「お薬を追加」の通知が 2 件 (payload 空) 予約されており、08:00 の仮カードを削除すると 1 件に減った。
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/f3ce287f-706d-4159-a8b9-ca62991f221c-ob14-registered.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/a75420f1-e111-4992-b53a-fe054aa002da-b01-placeholder-notifications.jpg" width="320">
<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/2026/10/15/88f4ae74-453b-455e-aef7-8cf1603257d7-b03-notifications-after-delete.jpg" width="320">

</details>

</details>

---

## 2026-09-08の追加実装の検証

対象コード: `c4e57849`。iOS 26.5の専用シミュレータで今回の追加部分を検証した。既存項目全体は再検証していないため、frontmatterの最終検証コミットは更新していない。

- 2回を回答し、ペイウォールを閉じると08:00・19:00の登録案内が表示された。「あとで」で仮カードを表示し、再起動後も保持された
- 仮カードから開いた登録フォームに08:00・19:00が初期入力された。保存せず閉じても仮カードが残った。時刻を編集する操作と、登録案内から直接フォームへ進む経路は今回のシミュレータでは未検証
- 薬名「Onboarding QA」の保存後に実薬のカードと服薬チェック欄が表示され、仮カードが消えた。通知一覧も実薬の通知に切り替わった
- 別の専用シミュレータで08:00だけを削除すると19:00が残り、最後の時刻の削除と再起動後は仮カードと通知が消えた。通知一覧で薬登録案内の文面を確認した。指定時刻の実際の通知受信は未検証
- Maestroの通し実行は登録側が保存ボタン検出、削除側が広告オーバーレイ等でexit 1。分割した追検証は登録後・通知解除と最後の手動削除・再起動をそれぞれexit 0で確認した。通しテスト成功とは扱わない
- ローカルログ: `tmp/onboarding-followup-maestro-registration.log`、`tmp/onboarding-followup-maestro-registration-finish.log`、`tmp/onboarding-followup-maestro-delete-last-dismiss.log`
- 画像: https://github.com/bannzai/medicalarm/pull/273 の「今回の検証」へ添付

## 2026-10-11 CI E2E での通し実行の記録

対象コード: `6907e9bc` (#373)。GitHub Actions の `CI E2E (Flutter iOS)` (macos-26 runner・iPhone 17・新品の Simulator) で `maestro test maestro/flows` を実行した。アプリ本体のコードは変えていないため、frontmatter の最終検証コミットは更新していない。

- `onboarding_medication_plan.yaml` (登録側) と `onboarding_medication_plan_delete.yaml` (削除側) がどちらも Passed になり、2026-09-08 の記録で未達だった通し実行が成功した: https://github.com/bannzai/medicalarm/actions/runs/38092951947
- 「回答した時刻の引き継ぎ」の項目のうち、時刻を編集する操作はフローに含まれず未検証のため、チェックは入れていない
