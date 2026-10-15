## Generator
- generate_screenshot.sh は UITest を通して各言語のスクリーンショットを撮る
- generate_screenshot_text.py は OpenAI を通じて resources/text_to_image.json からスクリーンショットに表示するテキストを画像にする
- generate_merged_image.sh は imagemagick を使用して、generate_screenshot と generate_screenshot_text を合体させる
- generate_metadata.py は generate_merged_image.sh を各言語ごとに逐次実行して、fastlane/metadata に配置する

## iPhone Duo (外側・内側ディスプレイ)
- `bash scripts/translation/generate_duo_screenshots.sh` の 1 コマンドで、ローカルの iPhone Duo simulator で閉じた姿勢 (外側 1398×2034) と開いた姿勢 (内側 2853×2007) の 3 ページを全言語撮り、文字を載せて `artifacts/appstore_iphone_duo/<言語>/<index>_APP_IPHONE_DUO_{1_outer,2_inner}.png` に出力する。寸法・alpha 無し・枚数 (言語数 × 3 ページ × 2 面) の検証まで行う
- 姿勢の切り替え (`duo-pose.sh`) はローカル simulator でしかできないため、simtunnel ではなく `sim-boot` を使う
- 文字は `render_text.swift` (CoreText) で描く。この Mac の ImageMagick には raqm / pango が無く、アラビア語・ヘブライ語の字形結合を扱えないため
- 言語は `ios/fastlane/screenshots/*/` の一覧から導出し、コピーは `resources/text_to_image.json` を使う。`--skip-capture` で合成だけ、`--skip-compose` で撮影だけを再実行できる
- `ios/fastlane/screenshots/` には置かない (fastlane deliver は画像の px から表示クラスを決め、Duo の寸法を知らないため、置くとアップロード全体が検証で止まる)。App Store Connect へは手動でアップロードする

## Translator
- アプリ内文字列 (lib/l10n/*.arb) の翻訳は translate-app-arb skill で行う (`/translate-app-arb`)。設定はプロジェクトルートの `translate-app.config.json`。未翻訳キーのみの冪等な翻訳のほか、キー欠落・プレースホルダーの機械検査 (check) と品質レビュー (review) も同 skill が担う
- translate_screenshot_text.py: スクリーンショットに載せる文字を翻訳して text_to_image.json を生成する

## UITest
- ui_test_xxx は flutter drive を実行して ui_test をするために必要なスクリプト

## Usage
- 何もない場合は、アプリ内文字列を translate-app-arb skill で翻訳し、translate_screenshot_text.py で text_to_image.json を用意する。そのあとで Generator 系のスクリプトを実行する
- 一度生成されてから変更する場合は、その場合は generator を適宜調整して実行する。ほとんどこのパターン

## Remake

- $ exec arch -arch arm64e /bin/zsh --login
  - rosetta だと Macro を認識しない
  - Flutter ではこれは不要だが、内部で使われ始めた場合を考えてメモとして残しておく
- ./scripts/generate_screenshot.sh # UITest を通じて各言語のスクショを作成
- EDIT text_to_image.json OR EXEC `python ./scripts/translate_screenshot_text.py`# 翻訳したスクショのタイトル,サブタイトルを json に記録
- rm -rf artifacts/text_to_image # artifact を削除。text_to_image.json が変わらなければ結果も一緒
- python ./scripts/generate_screenshot_text.py # text_to_image.json の内容を画像化
- python scripts/generate_metadata.py # generate_merged_image.sh を各言語ごとに実行する

## 参考
- 全部じゃないけど、fastlane の言語コードがどの言語になっているのかが日本語でわかる
  - https://qiita.com/yutailang0119/items/69b7d0b3807d7212b401#deliver%E3%81%AE%E5%AF%BE%E5%BF%9C%E3%81%97%E3%81%A6%E3%81%84%E3%82%8B%E8%A8%80%E8%AA%9E%E3%82%B3%E3%83%BC%E3%83%89%E3%81%AFreadme%E3%81%AB%E8%A8%98%E8%BC%89%E3%81%8C%E3%81%82%E3%82%8A%E3%81%BE%E3%81%99

## Deprecated
- translate_metadata.py
  - AppStore の metadata を翻訳するスクリプト。ただ、name,subtitle,keywords が文字数制限があり、OpenAI が文字数を考慮しての生成が苦手なのでこの部分を自動化するのは諦めた

