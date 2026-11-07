# Custom Product Page (CPP) 設計 plan

`cpp/config.json` の設計根拠を記録する。config.json が SSOT で、本ドキュメントは「なぜその設計にしたか」だけを持つ。

- App: Medicalarm (com.bannzai.medicalarm) / App ID: 6740401642
- 作成: 2026-10 (castle issue https://github.com/bannzai/castle/issues/1503 「各リポジトリの対応」)
- 適用は `appstore-custom-product-page` skill の `cpp_apply_config.sh --config cpp/config.json`

## 共通方針

- 目的はオーガニック検索流入の拡大。CPP に検索キーワードを割り当て、キーワードごとに検索結果の Creative Asset (search results) と製品ページの header を出し分ける (2026-10-06 の App Store Connect のアップデートで可能になった)
- 既定の製品ページの訴求 (飲み忘れ防止・絶対に気づく通知) は `appstore/creative-assets/default/` の画像で表す。CPP は既定ページと訴求が明確に分かれる 1 軸だけ作る
- スクリーンショットは新規に作らず、公開中のバージョン (202605.02.205812) を雛形 (`cpp_create.sh --template-version`) に複製する。CPP 固有の差分は promotionalText・keywords・Creative Asset
- キーワードは公開中バージョンの Keywords の語句だけ割り当てられる。アプリの新バージョンが承認されると割り当てがリセットされるため、承認後に `cpp_apply_config.sh` を再実行して config.json から復元する
- 対象 locale は ja と en-US (公開中バージョンで Keywords が入っているのはこの 2 locale)

## CPP 一覧

### 1. family-care-202610 (家族・介護の服薬管理軸)

- 対象オーディエンス: 子ども・親・介護している家族の薬を代わりに管理する人
- 流入元: 「介護」「持病」「糖尿病」「高血圧」「薬管理」などの検索 (ja)、"caregiver" "diabetes" "prescription" (en-US)
- 仮説: 既定ページは「自分の飲み忘れ防止」が主語だが、このキーワード群で探す人は「他人の薬を管理する」場面にいる。複数人管理という Medicalarm の設計前提 (fastlane の説明文) を前面に出すと一致する
- Creative Asset: `appstore/creative-assets/family/` (大小 2 つのピルケースと目覚まし時計。文字なし)
- スクリーンショット: 既定ページの複製

## 次工程

1. `cpp_create.sh family-care-202610 --locale ja --template-version <公開中バージョンの ID>` で作成 (2026-10-07 時点では Apple 側の一時障害 `ENTITY_ERROR.RELATIONSHIP.REQUIRED` で作成できず、再試行中)
2. `cpp_apply_config.sh --config cpp/config.json` で promotionalText と keywords を適用
3. `asset_library_set_placement.sh --target cpp` で header / search results を配置し、ユーザー確認後に `cpp_submit.sh <CPP_ID>` で提出
4. 承認後、App Analytics で CPP ごとの impressions / CVR を計測 (初回 DL 5 件以上で表示)
