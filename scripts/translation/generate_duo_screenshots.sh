#!/bin/bash
#
# iPhone Duo (折りたたみ端末) 用の App Store スクリーンショットを、外側ディスプレイ (閉じた姿勢、縦 1398×2034) と
# 内側ディスプレイ (開いた姿勢、横 2853×2007) の両方について、ストアに載せている言語 (ios/fastlane/screenshots/ の
# ディレクトリ) × 3 ページぶん生成する。寸法は Apple の Screenshot specifications の iPhone Duo の節
# ( https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications )。
#
# 使い方:
#   scripts/translation/generate_duo_screenshots.sh [--skip-capture] [--skip-compose]
#     --skip-capture : simulator での撮影を飛ばし、artifacts/duo/raw/ にある撮影済みの PNG から合成だけ行う
#     --skip-compose : 撮影だけ行い、合成と検証を飛ばす
#
# 環境変数:
#   DUO_SIMULATOR_NAME : 撮影に使う simulator 名 (既定 medicalarm-appstore-duo)。sim-boot が冪等に作成・起動する
#   DUO_POSE_SCRIPT    : 姿勢を切り替える ios-simulator skill のスクリプト (既定 ~/.claude/skills/ios-simulator/scripts/duo-pose.sh)
#
# 出力:
#   artifacts/duo/raw/{outer,inner}/screenshot_<ページ>--<言語コード>.png  撮影した素の画面 (integration_test の takeScreenshot)
#   artifacts/duo/text/                                                キャッチコピーの文字画像
#   artifacts/appstore_iphone_duo/<言語>/<index>_APP_IPHONE_DUO_1_outer.png  外側 1398×2034 (alpha なし)
#   artifacts/appstore_iphone_duo/<言語>/<index>_APP_IPHONE_DUO_2_inner.png  内側 2853×2007 (alpha なし)
#   最後に VERIFIED=<枚数> を標準出力に出す。寸法・alpha・枚数のどれかが合わなければ exit 1
#
#   ios/fastlane/screenshots/ には置かない。fastlane deliver は画像の px から表示クラスを決め、Duo の寸法を知らないため
#   そこに置くとアップロード全体が検証で止まる (fastlane 2.240.1 の deliver/lib/deliver/app_screenshot.rb の
#   DEVICE_RESOLUTIONS に 1398 / 2853 の寸法が無い。ios/Gemfile.lock は 2.239.0)。
#   アップロードは App Store Connect の Web UI か `asc screenshots upload --device-type APP_IPHONE_DUO` で行う。
#
# 依存コマンド: flutter, sim-boot (~/bin), duo-pose.sh, swift, magick, sips, python3
#   内側ディスプレイの姿勢切り替えは Device Hub のウィンドウ操作でしかできないため、ローカルの Mac でだけ動く。
#
# 冪等: 同じ入力なら同じ出力を上書きする。raw / 合成結果の両方を作り直す。
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd -P)"
cd "$SCRIPT_DIR/../.."

DUO_SIMULATOR_NAME="${DUO_SIMULATOR_NAME:-medicalarm-appstore-duo}"
DUO_POSE_SCRIPT="${DUO_POSE_SCRIPT:-$HOME/.claude/skills/ios-simulator/scripts/duo-pose.sh}"

RAW_DIR="artifacts/duo/raw"
TEXT_DIR="artifacts/duo/text"
OUTPUT_DIR="artifacts/appstore_iphone_duo"
TEXT_JSON="scripts/translation/resources/text_to_image.json"
FASTLANE_SCREENSHOTS_DIR="ios/fastlane/screenshots"

# 外側は縦、内側は開いた端末を持つ向きのまま撮れる横を採る (appstore-screenshot-builder skill references/iphone-duo.md の既定)
OUTER_WIDTH=1398
OUTER_HEIGHT=2034
INNER_WIDTH=2853
INNER_HEIGHT=2007
# 既存の 6.5 インチ版の背景 (scripts/translation/resources/6.5inchi/0.png) の画素値 srgb(252,236,234) と同じ色
BACKGROUND_COLOR='#FCECEA'
# text_to_image.sh のタイトル色と同じ
COPY_COLOR='#800080'
# 端末フレームの色。ストアの既存画像 (notch.png) のチタン色の縁に寄せた濃いグレーと縁取り
FRAME_FILL='#2C2C2E'
FRAME_STROKE='#9A9A9E'

# ページの並びは generate_metadata.py の GENERATE_SCREENSHOT_TEST_FUNCTION_1〜3 と同じ
PAGES=(screenshot_medications screenshot_medication_histories screenshot_medicine_schedule_notification_form)

SKIP_CAPTURE=0
SKIP_COMPOSE=0
for arg in "$@"; do
  case "$arg" in
    --skip-capture) SKIP_CAPTURE=1 ;;
    --skip-compose) SKIP_COMPOSE=1 ;;
    *)
      echo "ERROR: unknown argument: $arg" >&2
      sed -n '2,30p' "$0" | sed -E 's/^# ?//' >&2
      exit 2
      ;;
  esac
done

# ios/fastlane/screenshots/ のディレクトリ名を、integration_test が出力ファイル名に使う言語コードにする
# (generate_metadata.py の map_directory_name の逆)
language_code_for_directory() {
  case "$1" in
    ar-SA) echo ar ;;
    de-DE) echo de ;;
    en-US) echo en ;;
    es-ES) echo es ;;
    no) echo nb ;;
    nl-NL) echo nl ;;
    zh-Hant) echo zh ;;
    *) echo "$1" ;;
  esac
}

LANGUAGE_DIRECTORIES=()
for dir in "$FASTLANE_SCREENSHOTS_DIR"/*/; do
  LANGUAGE_DIRECTORIES+=("$(basename "$dir")")
done
LANGUAGE_CODES=""
for dir in "${LANGUAGE_DIRECTORIES[@]}"; do
  LANGUAGE_CODES="${LANGUAGE_CODES:+$LANGUAGE_CODES,}$(language_code_for_directory "$dir")"
done
echo "languages (${#LANGUAGE_DIRECTORIES[@]}): ${LANGUAGE_DIRECTORIES[*]}"

# 姿勢を切り替える。起動直後は有効なディスプレイを判定できず失敗することがあるため、数秒おいて最大 6 回試す
set_pose() {
  local udid=$1 pose=$2 attempt
  for attempt in 1 2 3 4 5 6; do
    if bash "$DUO_POSE_SCRIPT" set --udid "$udid" "$pose" | tee /dev/stderr | grep -q '^STATUS=OK$'; then
      return 0
    fi
    echo "duo-pose set $pose: attempt $attempt failed, retrying in 5s" >&2
    sleep 5
  done
  echo "ERROR: could not set pose to $pose" >&2
  return 1
}

# simulator を起動し、UDID を返す。既に起動済みなら sim-boot がそのまま返す
boot_simulator() {
  local udid
  udid=$(sim-boot "$DUO_SIMULATOR_NAME" "iPhone Duo" | tee /dev/stderr | sed -n 's/^DEVICE_UDID=//p' | tail -1)
  if [ -z "$udid" ]; then
    echo "ERROR: sim-boot did not return DEVICE_UDID" >&2
    return 1
  fi
  echo "$udid"
}

# simulator のシステム言語を変えて起動し直し、UDID を返す。
# カレンダーの曜日 (lib/utils/date_time/weekday.dart) はアプリのロケールではなく Platform.localeName (システム言語) で決まるため、
# 出荷済みの iPhone 版 (ja 以外は英語の曜日、ja は日本語の曜日) と揃えるには言語ごとにシステム言語を切り替える必要がある。
# defaults の変更は起動中のプロセスに効かないため、書き換えた後に shutdown → 起動で反映する。
# 元のシステム言語は復元しない (撮影専用の simulator で、次回の実行でも自分で設定し直すため)
set_system_language() {
  local udid=$1 language=$2 locale=$3
  xcrun simctl spawn "$udid" defaults write .GlobalPreferences AppleLanguages -array "$language"
  xcrun simctl spawn "$udid" defaults write .GlobalPreferences AppleLocale -string "$locale"
  xcrun simctl shutdown "$udid"
  boot_simulator
}

capture() {
  local udid=$1 pose=$2 display=$3 language_codes=$4 page
  set_pose "$udid" "$pose"
  # 切り替えの直後は描画が追いつかないため少し待つ (ios-simulator skill Phase 2 の実測に合わせて 5 秒)
  sleep 5
  mkdir -p "$RAW_DIR/$display"
  for page in "${PAGES[@]}"; do
    flutter drive \
      --driver=test_driver/screenshot_test.dart \
      --target="integration_test/${page}_test.dart" \
      --device-id="$udid" \
      --dart-define="SCREENSHOT_OUTPUT_DIR=$RAW_DIR/$display" \
      --dart-define="SCREENSHOT_LANGUAGE_CODES=$language_codes" \
      --dart-define=SCREENSHOT_RENDER_FROM_FLUTTER_VIEW=true
  done
}

# システム言語 (曜日の言語) ごとに撮影する言語の組。set_system_language のコメントを参照
LANGUAGE_CODES_WITH_ENGLISH_WEEKDAYS=$(echo "$LANGUAGE_CODES" | tr ',' '\n' | grep -v '^ja$' | paste -sd, -)
LANGUAGE_CODES_WITH_JAPANESE_WEEKDAYS=$(echo "$LANGUAGE_CODES" | tr ',' '\n' | grep '^ja$' | paste -sd, -)

if [ "$SKIP_CAPTURE" -eq 0 ]; then
  rm -rf "$RAW_DIR/outer" "$RAW_DIR/inner"
  UDID=$(boot_simulator)
  if [ -n "$LANGUAGE_CODES_WITH_ENGLISH_WEEKDAYS" ]; then
    UDID=$(set_system_language "$UDID" en-US en_US)
    capture "$UDID" closed outer "$LANGUAGE_CODES_WITH_ENGLISH_WEEKDAYS"
    capture "$UDID" open inner "$LANGUAGE_CODES_WITH_ENGLISH_WEEKDAYS"
  fi
  if [ -n "$LANGUAGE_CODES_WITH_JAPANESE_WEEKDAYS" ]; then
    UDID=$(set_system_language "$UDID" ja-JP ja_JP)
    capture "$UDID" closed outer "$LANGUAGE_CODES_WITH_JAPANESE_WEEKDAYS"
    capture "$UDID" open inner "$LANGUAGE_CODES_WITH_JAPANESE_WEEKDAYS"
  fi
  # 閉じた姿勢に戻しておく (次に起動した時の既定と揃える)
  set_pose "$UDID" closed
fi

if [ "$SKIP_COMPOSE" -eq 1 ]; then
  exit 0
fi

# ---- キャッチコピーの文字画像 ----
rm -rf "$TEXT_DIR"
mkdir -p "$TEXT_DIR"
python3 -I - "$TEXT_JSON" "$TEXT_DIR" "${LANGUAGE_DIRECTORIES[@]}" <<'PY' > "$TEXT_DIR/jobs.json"
import json, sys
text_json, text_dir, *languages = sys.argv[1:]
copies = json.load(open(text_json))
jobs = []
for language in languages:
    entries = copies.get(language)
    if entries is None:
        sys.exit(f"ERROR: {text_json} has no entry for {language}")
    for entry in entries:
        index = entry["index"]
        # 外側 (縦 1398 幅): 既存の 6.5 インチ版 (幅 1284 に 120px) と同じ比率の文字の大きさ
        jobs.append({"text": entry["title"], "output": f"{text_dir}/{language}_{index}_outer_title.png", "width": 1240, "fontSize": 104, "weight": "bold", "color": "#800080"})
        jobs.append({"text": entry["subtitle"], "output": f"{text_dir}/{language}_{index}_outer_subtitle.png", "width": 1240, "fontSize": 56, "weight": "regular", "color": "#800080"})
        # 内側 (横 2853 幅): 左の列 (幅 1000) に置く
        jobs.append({"text": entry["title"], "output": f"{text_dir}/{language}_{index}_inner_title.png", "width": 1000, "fontSize": 112, "weight": "bold", "color": "#800080"})
        jobs.append({"text": entry["subtitle"], "output": f"{text_dir}/{language}_{index}_inner_subtitle.png", "width": 1000, "fontSize": 60, "weight": "regular", "color": "#800080"})
json.dump(jobs, sys.stdout, ensure_ascii=False)
PY
swift scripts/translation/render_text.swift "$TEXT_DIR/jobs.json"

image_height() {
  magick identify -format '%h' "$1"
}

# 撮影した画面を指定の大きさに合わせ、角を丸めた PNG を作る
rounded_screen() {
  local input=$1 width=$2 height=$3 radius=$4 output=$5
  # 撮影画像は alpha を持たないため、-alpha set で alpha チャンネルを足してから角のマスクを掛ける (無いと角が黒く残る)
  magick "$input" -resize "${width}x${height}!" -alpha set \
    \( -size "${width}x${height}" xc:none -fill white -draw "roundrectangle 0,0 $((width - 1)),$((height - 1)) $radius,$radius" \) \
    -compose DstIn -composite "$output"
}

# 外側: 背景 + 上部にタイトル・サブタイトル + 下部に閉じた端末のフレームと画面
compose_outer() {
  local language=$1 index=$2 raw=$3 output=$4
  local bezel=22 radius=100
  local title="$TEXT_DIR/${language}_${index}_outer_title.png" subtitle="$TEXT_DIR/${language}_${index}_outer_subtitle.png"
  local title_top=130
  local subtitle_top=$((title_top + $(image_height "$title") + 36))
  # 端末は文字の下 (最低でも 520px の位置) から始め、下端に 73px 残す。タイトル・サブタイトルが折り返して長くなる言語
  # (uk の 2 ページ目など) では、端末を文字に重ねず、画面を外側ディスプレイの比率 (466×678 pt) のまま小さくする
  local frame_top=$((subtitle_top + $(image_height "$subtitle") + 40))
  if [ "$frame_top" -lt 520 ]; then
    frame_top=520
  fi
  local screen_height=$((OUTER_HEIGHT - 73 - frame_top - bezel * 2))
  if [ "$screen_height" -gt 1397 ]; then
    screen_height=1397
  fi
  local screen_width=$((screen_height * 960 / 1397))
  local frame_left=$(((OUTER_WIDTH - screen_width - bezel * 2) / 2))
  rounded_screen "$raw" "$screen_width" "$screen_height" "$radius" "$TEXT_DIR/_screen.png"
  magick -size "${OUTER_WIDTH}x${OUTER_HEIGHT}" "xc:$BACKGROUND_COLOR" \
    -fill "$FRAME_FILL" -stroke "$FRAME_STROKE" -strokewidth 6 \
    -draw "roundrectangle $frame_left,$frame_top $((frame_left + screen_width + bezel * 2)),$((frame_top + screen_height + bezel * 2)) $((radius + bezel)),$((radius + bezel))" \
    \( "$TEXT_DIR/_screen.png" \) -geometry "+$((frame_left + bezel))+$((frame_top + bezel))" -composite \
    \( "$title" \) -gravity north -geometry "+0+$title_top" -composite \
    \( "$subtitle" \) -gravity north -geometry "+0+$subtitle_top" -composite \
    -alpha off "$output"
}

# 内側: 背景 + 左にタイトル・サブタイトル + 右に開いた端末 (中央に折り目) のフレームと画面
compose_inner() {
  local language=$1 index=$2 raw=$3 output=$4
  # 画面は内側ディスプレイの比率 (951×669 pt) のまま縮める
  local screen_width=1540 screen_height=1083 bezel=26 radius=72
  local frame_left=1170 frame_top=$(((INNER_HEIGHT - screen_height - bezel * 2) / 2))
  local title="$TEXT_DIR/${language}_${index}_inner_title.png" subtitle="$TEXT_DIR/${language}_${index}_inner_subtitle.png"
  local copy_left=85 gap=44
  local copy_height=$(($(image_height "$title") + gap + $(image_height "$subtitle")))
  local title_top=$(((INNER_HEIGHT - copy_height) / 2))
  local subtitle_top=$((title_top + $(image_height "$title") + gap))
  local crease_x=$((frame_left + bezel + screen_width / 2))
  rounded_screen "$raw" "$screen_width" "$screen_height" "$radius" "$TEXT_DIR/_screen.png"
  magick -size "${INNER_WIDTH}x${INNER_HEIGHT}" "xc:$BACKGROUND_COLOR" \
    -fill "$FRAME_FILL" -stroke "$FRAME_STROKE" -strokewidth 6 \
    -draw "roundrectangle $frame_left,$frame_top $((frame_left + screen_width + bezel * 2)),$((frame_top + screen_height + bezel * 2)) $((radius + bezel)),$((radius + bezel))" \
    \( "$TEXT_DIR/_screen.png" \) -geometry "+$((frame_left + bezel))+$((frame_top + bezel))" -composite \
    -fill none -stroke 'rgba(0,0,0,0.16)' -strokewidth 3 \
    -draw "line $crease_x,$((frame_top + bezel)) $crease_x,$((frame_top + bezel + screen_height))" \
    \( "$title" \) -geometry "+$copy_left+$title_top" -composite \
    \( "$subtitle" \) -geometry "+$copy_left+$subtitle_top" -composite \
    -alpha off "$output"
}

rm -rf "$OUTPUT_DIR"
for language in "${LANGUAGE_DIRECTORIES[@]}"; do
  code=$(language_code_for_directory "$language")
  mkdir -p "$OUTPUT_DIR/$language"
  for index in "${!PAGES[@]}"; do
    page=${PAGES[$index]}
    compose_outer "$language" "$index" "$RAW_DIR/outer/${page}--${code}.png" "$OUTPUT_DIR/$language/${index}_APP_IPHONE_DUO_1_outer.png"
    compose_inner "$language" "$index" "$RAW_DIR/inner/${page}--${code}.png" "$OUTPUT_DIR/$language/${index}_APP_IPHONE_DUO_2_inner.png"
    echo "composed $language $index"
  done
done

# ---- 機械検証: 寸法・alpha・枚数 ----
verify() {
  local file=$1 width=$2 height=$3 info
  info=$(sips -g pixelWidth -g pixelHeight -g hasAlpha "$file" | tail -3 | awk '{print $2}' | paste -sd' ' -)
  if [ "$info" != "$width $height no" ]; then
    echo "ERROR: $file is '$info', expected '$width $height no'" >&2
    return 1
  fi
}
count=0
failed=0
for file in "$OUTPUT_DIR"/*/*_1_outer.png; do
  verify "$file" "$OUTER_WIDTH" "$OUTER_HEIGHT" || failed=1
  count=$((count + 1))
done
for file in "$OUTPUT_DIR"/*/*_2_inner.png; do
  verify "$file" "$INNER_WIDTH" "$INNER_HEIGHT" || failed=1
  count=$((count + 1))
done
expected=$((${#LANGUAGE_DIRECTORIES[@]} * ${#PAGES[@]} * 2))
if [ "$failed" -ne 0 ] || [ "$count" -ne "$expected" ]; then
  echo "ERROR: verified $count files (expected $expected), failed=$failed" >&2
  exit 1
fi
echo "VERIFIED=$count"
