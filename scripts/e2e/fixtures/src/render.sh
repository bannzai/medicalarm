#!/bin/bash
# scripts/e2e/fixtures/src/*.html を Chrome headless でレンダリングし、写真風の後処理をかけて
# scripts/e2e/fixtures/*.png を生成する。generateMedicinesFromImage の E2E 用 fixture 画像を作る。
#
# 使い方:
#   bash scripts/e2e/fixtures/src/render.sh            # 3 枚すべて生成
#   bash scripts/e2e/fixtures/src/render.sh medicine_bag  # 名前を指定して 1 枚だけ生成
#
# 前提: Google Chrome (/Applications/Google Chrome.app) と Python の Pillow。
#   Pillow が無い場合は python3 -m pip install --user pillow で入れる。
#
# 出力は決定的で、引数を変えずに再実行しても同じ画像になる (乱数はすべて固定 seed から作る)。
set -e
set -o pipefail

cd "$(dirname "$0")"

chromeBinary="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
[ -x "$chromeBinary" ] || { echo "Error: Google Chrome が見つかりません: $chromeBinary" >&2; exit 1; }
if ! python3 -c 'import PIL' 2>/dev/null; then
  echo "Pillow が無いのでインストールします"
  python3 -m pip install --user pillow
  python3 -c 'import PIL' || { echo "Error: Pillow を用意できませんでした" >&2; exit 1; }
fi

workDir=$(mktemp -d)
trap 'rm -rf "$workDir"' EXIT

# Chrome 152 の headless は --screenshot の書き出しを終えてもプロセスが終了しないため、
# 出力ファイルのサイズが安定したところで打ち切る。--screenshot の完了を待つ公式の手段が無く、
# 単に待つと 1 枚ごとに無期限に止まる。
screenshotTimeoutSeconds=60
takeScreenshot() {
  local outputImage=$1
  local pageURL=$2
  local windowSize=$3
  local profileDir=$4

  "$chromeBinary" \
    --headless \
    --disable-gpu \
    --hide-scrollbars \
    --force-device-scale-factor=1 \
    --user-data-dir="$profileDir" \
    --window-size="$windowSize" \
    --screenshot="$outputImage" \
    "$pageURL" > /dev/null 2>&1 &
  local chromePID=$!

  local previousSize=0
  local currentSize=0
  local waited=0
  while [ "$waited" -lt "$screenshotTimeoutSeconds" ]; do
    sleep 1
    waited=$((waited + 1))
    currentSize=$(stat -f%z "$outputImage" 2>/dev/null || echo 0)
    if [ "$currentSize" -gt 0 ] && [ "$currentSize" = "$previousSize" ]; then
      break
    fi
    previousSize=$currentSize
  done

  kill -9 "$chromePID" 2>/dev/null || true
  wait "$chromePID" 2>/dev/null || true
  pkill -9 -f "$profileDir" 2>/dev/null || true
}

# 画像ごとの: 名前 レンダリング幅 レンダリング高さ 回転角(度) ノイズ種 背景色(R,G,B) 背景の幅(px)
# 回転角とノイズ種は画像ごとに変えて、3 枚が同じ撮影条件に見えないようにする。
fixtures=(
  "medication_guide 1240 1754 -1.4 7 176,170,162 62"
  "medicine_notebook_seal 700 900 1.7 21 150,146,140 46"
  "medicine_bag 900 1200 -1.1 34 168,161,152 54"
)

for fixture in "${fixtures[@]}"; do
  read -r name width height angle seed background margin <<< "$fixture"
  if [ $# -gt 0 ] && [ "$1" != "$name" ]; then
    continue
  fi

  rawImage="$workDir/$name.png"
  takeScreenshot "$rawImage" "file://$PWD/$name.html" "$width,$height" "$workDir/profile-$name"
  # Chrome はレンダリングに失敗しても 0 で終わることがあるため、出力の有無とサイズで判定する
  [ -s "$rawImage" ] || { echo "Error: スクリーンショットが生成されませんでした: $name" >&2; exit 1; }
  python3 -c "
import sys
from PIL import Image
with Image.open(sys.argv[1]) as image:
    if image.size != (int(sys.argv[2]), int(sys.argv[3])):
        sys.exit(f'Error: 想定と違うサイズです: {image.size}')
" "$rawImage" "$width" "$height"

  python3 photo_effect.py "$rawImage" "../$name.png" \
    --angle "$angle" --seed "$seed" --background "$background" --margin "$margin"
  echo "生成: scripts/e2e/fixtures/$name.png"
done
