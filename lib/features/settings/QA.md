---
feature: settings
verification: mobile-mcp
last_verified_commit: 4d2291e65d9785265cc567936d65e75acc5ccae1
last_verified_at: 2026-08-12
---

# settings QA

到達手順: ホーム画面下部のタブバーで「設定」タブ（設定アイコン）を選択すると設定画面が表示される。

## 1. プレミアムプランセクション

- [x] **プレミアム導線**: 「プレミアムプラン」セクションの「プレミアムプランを見る」行をタップすると、プレミアム紹介シートが表示される

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **プレミアム導線**: 「プレミアムプラン」セクションの「プレミアムプランを見る」行をタップすると、プレミアム紹介シートが表示される

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/71309b20-3d12-472d-977e-371f892b1c00.png" width="320">

</details>

</details>

---

## 2. アプリについてセクション

- [x] **利用規約**: 「利用規約」行をタップすると利用規約ページが外部ブラウザで開く
- [x] **プライバシーポリシー**: 「プライバシーポリシー」行をタップするとプライバシーポリシーページが外部ブラウザで開く
- [x] **特定商取引法に基づく表記**: 「特定商取引法に基づく表記」行をタップすると該当ページが外部ブラウザで開く
- [x] **お問い合わせ**: 「お問い合わせ」行をタップすると問い合わせフォーム（Googleフォーム）が外部ブラウザで開く
- [x] **OSSライセンス**: 「OSSライセンス」行をタップすると Flutter 標準のライセンス画面が開き、アプリ名とバージョン、依存パッケージの一覧が表示される。パッケージ行をタップするとライセンス本文が読める

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **利用規約**: 「利用規約」行をタップすると利用規約ページが外部ブラウザで開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/553f3b7e-4ba4-4d29-9459-a38146f52d9b.png" width="320">

</details>

### **プライバシーポリシー**: 「プライバシーポリシー」行をタップするとプライバシーポリシーページが外部ブラウザで開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/d7495752-3a72-40a0-b86b-8d33e23318be.png" width="320">

</details>

### **特定商取引法に基づく表記**: 「特定商取引法に基づく表記」行をタップすると該当ページが外部ブラウザで開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/7693e1e4-ac90-4943-a2fd-54117f10aa7f.png" width="320">

</details>

### **お問い合わせ**: 「お問い合わせ」行をタップすると問い合わせフォーム（Googleフォーム）が外部ブラウザで開く

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/66fe90fd-c027-4b72-9993-e7ab2b349490.png" width="320">

</details>

### **OSSライセンス**: 「OSSライセンス」行をタップすると Flutter 標準のライセンス画面が開き、アプリ名とバージョン、依存パッケージの一覧が表示される。パッケージ行をタップするとライセンス本文が読める

<details><summary>動作確認スクショ</summary>

**確認日: 2026-08-12**

設定画面の「アプリについて」セクションに「OSSライセンス」行が追加されている。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260812/41121287-1b83-4416-806a-89825d8d24bc.png" width="320" />

タップすると `showLicensePage` のライセンス画面が開き、`PackageInfo.fromPlatform()` から取得したアプリ名「Medicalarm」とバージョン「202607.15.102935」、依存パッケージの一覧（`_fe_analyzer_shared` / `_flutterfire_internals` / `abseil-cpp` など）が表示される。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260812/55c21d34-d883-46f4-9fad-143f108445c0.png" width="320" />

パッケージ行をタップするとライセンス本文が読める。

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260812/647bc214-ad39-46e9-bd5b-bfba5ad206ab.png" width="320" />

</details>

</details>

---

## 3. デバッグ機能

- [x] **アカウント削除（デバッグビルドのみ）**: デバッグビルドでは「アカウントを削除する」ボタンが表示される。タップすると「ユーザー情報を削除します」の確認ダイアログが表示され、キャンセルと削除する（赤字）を選択できる
  - キャンセルの動作のみ確認し、実際のアカウント削除（`削除する`赤字ボタン）は実行していない。削除すると匿名ユーザーが即座に消去され `exit(0)` で完了ダイアログからアプリが終了するため、以降のQA項目を継続できなくなる（root QA.md「匿名認証で起動のたびに新規ユーザーを作れる」前提はあるが、破壊的操作のため本セッションでは見送った）
- [x] **Local Notifications**: 「DEBUG」セクションの「Local Notifications」行をタップすると、予約中のリマインダー通知一覧（id/title/body/payload）を表示するページに遷移する

#### 動作確認
<details>
<summary>動作確認エビデンス</summary>

### **アカウント削除（デバッグビルドのみ）**: デバッグビルドでは「アカウントを削除する」ボタンが表示される。タップすると「ユーザー情報を削除します」の確認ダイアログが表示され、キャンセルと削除する（赤字）を選択できる

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/36ea1989-54f0-42ee-84f1-bb8f17967dc4.png" width="320">

</details>

### **Local Notifications**: 「DEBUG」セクションの「Local Notifications」行をタップすると、予約中のリマインダー通知一覧（id/title/body/payload）を表示するページに遷移する

<details><summary>動作確認スクショ</summary>

**確認日: 2026-07-14**

<img src="https://pub-7f3469dd3e2e445b9b8ec2d1381b5ea8.r2.dev/bannzai/medicalarm/20260714/2e12243c-006b-441f-aed7-4a77e6705549.png" width="320">

</details>

</details>
