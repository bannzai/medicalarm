# App Store 製品ページ用ヘッダー

`header.jpg` は全言語で共通使用するテキストレスの入稿用画像。`prompt.txt` に今回実行した生成プロンプトを保存している。

## 訴求とデザイン

「服薬の時間に気づき、飲んだことを記録できる安心」を、ベル・無地の薬・チェック形で表現した。根拠は `ios/fastlane/metadata/ja/` の name・subtitle・description にある飲み忘れ防止、服用時刻の通知、服薬記録の説明。色は `lib/style/color.dart` の `AppColors.primary` と `AppColors.background` に合わせ、柔らかいコーラルとクリームホワイトの3Dイラストにした。

文字・数字・実在ロゴを使用せず、価格・割引・受賞歴・医療効果の保証を載せない。主要モチーフは中央の横帯へまとめ、上下左右に余白を確保した。

## 仕様と検証

2026-09-09 に Apple 公式テンプレートを取得して実測した。キャンバスは 3840×1646、Art Safe Area は left=1097、top=493、right=2743、bottom=1154。

仕様の出典: https://developer.apple.com/app-store/asset-best-practices/

リポジトリルートでの検証コマンド:

```sh
bash ~/.agents/skills/appstore-header-creative/scripts/fetch_template_spec.sh --type header --cache-dir ./tmp/appstore-header-creative
bash ~/.agents/skills/appstore-header-creative/scripts/check_header_asset.sh appstore/product-page-header/header.jpg --type header
bash ~/.agents/skills/pr-attach-screenshots/scripts/check-upload-target.sh appstore/product-page-header/header.jpg
sips -g format -g hasAlpha -g space -g pixelWidth -g pixelHeight appstore/product-page-header/header.jpg
```

すべて終了コード 0。ヘッダー検証の出力:

```text
[OK] フォーマット: jpeg
[OK] サイズ: 3840x1646
[INFO] Art Safe Area (実画像換算): left=1097 top=493 right=2743 bottom=1154 — キーコンテンツ・コピーはこの範囲内に収める
```

`[OK]` 2件、`[WARN]` 0件、`[NG]` 0件。公開前の機械検査は MIME `image/jpeg` で合格。`sips` で RGB・透過なしを確認した。

最終JPEGを表示し、文字・数字・実在サービスのロゴ・秘匿情報・個人情報・QRコードがないことを目視確認した。ベル、薬、チェックと短い弧は、おおよそ x=1160〜2720、y=630〜1010 の範囲にあり、Art Safe Area 内に収まる。背景の光と横帯は装飾として領域外まで広がる。ブランド色と落ち着いたトーンも確認した。

## 制作記録

既存案の下端の余裕が少なかったため、中央の横帯へ収める構図で新規生成した。指定の4K生成スクリプトを使用し、生成元は6336×2688。以下の順で中央クロップ・縮小・JPEG出力した（生成元はローカル一時ファイル）。

```sh
bash ~/.agents/skills/appstore-header-creative/scripts/normalize_asset.sh tmp/medicalarm-header-raw.png tmp/medicalarm-header-normalized.png --type header
sips -s format jpeg -s formatOptions 90 tmp/medicalarm-header-normalized.png --out appstore/product-page-header/header.jpg
```

生成・正規化・JPEG変換はいずれも終了コード 0。生成時にSDKの自動関数呼び出しの使用方法に関する推奨警告、正規化時に `sysctlbyname for kern.hv_vmm_present failed with status -1` と `Warning: Output file suffix should be jpg` が出た。中間ファイルの拡張子に依存せず、最終出力は明示的にJPEGへ変換し、上記検査に合格している。拡大による解像度不足の警告はない。

アプリコードの変更がないため、Flutterビルド・ユニットテスト・Maestro・シミュレータ検証は対象外。App Store Connect の入稿先確認・入稿・実際のストア表示は依頼範囲外で未検証。画像の準備までを実施した。

## セッション再開

```sh
cd /Users/bannzai/worktrees/bannzai/medicalarm/appstore-header-creative
codex resume 01a08542-251a-79c3-a9c8-1f178a2f0251
```
