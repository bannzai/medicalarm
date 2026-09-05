#!/bin/bash
# デプロイ済みの generateMedicinesFromImage callable を、実際の画像を投げて検証する。
#
# 使い方:
#   bash scripts/e2e/generate_medicines_from_image.sh [画像パス]
#
# 画像パスを省略すると scripts/e2e/fixtures/medication_guide.png を使う。fixtures には
# 実物の調剤帳票を参考にした 3 枚があり、期待結果は各画像と同名の <画像名>_expected.json を正とする:
#   - medication_guide.png       お薬の説明書 (薬 4 種: 朝のみ/朝夕/朝昼夕/就寝前)
#   - medicine_notebook_seal.png お薬手帳シールの写真 (毎食後/就寝前/頓服。頓服は schedules 空が期待値)
#   - medicine_bag.png           薬袋の写真 (単剤・朝夕食後)
# 画像は fixtures/src/ の HTML と render.sh から再生成できる。
#
# 前提:
#   - ios/Firebase/GoogleService-Info.plist が配置済み (make secret)。Firebase Auth の
#     Web API キーをここから読み、アプリと同じ匿名認証で idToken を取得する
#   - 対象プロジェクトに関数がデプロイ済み
#
# 注意: 実行するたびに呼び出したユーザーの月間利用回数を 1 消費し、OpenAI の課金が発生する。
set -e
set -o pipefail

cd "$(dirname "$0")/../.."

PROJECT_ID=${PROJECT_ID:-medicalarm-prod}
REGION=${REGION:-asia-northeast1}
IMAGE_PATH=${1:-scripts/e2e/fixtures/medication_guide.png}

[ -f "$IMAGE_PATH" ] || { echo "Error: 画像が見つかりません: $IMAGE_PATH" >&2; exit 1; }
[ -f ios/Firebase/GoogleService-Info.plist ] || { echo "Error: ios/Firebase/GoogleService-Info.plist がありません。make secret を実行してください" >&2; exit 1; }

API_KEY=$(plutil -extract API_KEY raw ios/Firebase/GoogleService-Info.plist)
[ -n "$API_KEY" ] || { echo "Error: GoogleService-Info.plist から API_KEY を取得できませんでした" >&2; exit 1; }

# アプリ起動時と同じ匿名認証でサインインし、callable に渡す idToken を得る
ID_TOKEN=$(curl -sf -X POST "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${API_KEY}" \
  -H 'Content-Type: application/json' -d '{"returnSecureToken":true}' | jq -r .idToken)
[ -n "$ID_TOKEN" ] && [ "$ID_TOKEN" != "null" ] || { echo "Error: 匿名認証に失敗しました" >&2; exit 1; }
echo "匿名認証: OK"

WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT

# クライアント(base64CompressImage)と同じく JPEG で送る
sips -s format jpeg "$IMAGE_PATH" --out "$WORK_DIR/image.jpg" > /dev/null
jq -n --arg image "$(base64 -i "$WORK_DIR/image.jpg" | tr -d '\n')" \
  '{data: {mimeType: "image/jpeg", base64Image: $image}}' > "$WORK_DIR/request.json"

echo "呼び出し: https://${REGION}-${PROJECT_ID}.cloudfunctions.net/generateMedicinesFromImage"
curl -sf -X POST "https://${REGION}-${PROJECT_ID}.cloudfunctions.net/generateMedicinesFromImage" \
  -H "Authorization: Bearer ${ID_TOKEN}" \
  -H 'Content-Type: application/json' \
  --data-binary "@$WORK_DIR/request.json" | jq '.result'
