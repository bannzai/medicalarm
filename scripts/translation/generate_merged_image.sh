#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"
PROJECT_ROOT_DIR=$SCRIPT_DIR/../
cd $PROJECT_ROOT_DIR

SCREENSHOT=$1
LANG=$2
INDEX=$3

ARTIFACT_DIR="artifacts/merged_image"
mkdir -p "$ARTIFACT_DIR/$LANG"

BACKGROUND_65="scripts/resources/6.5inchi/$INDEX.png"
TITLE_65="artifacts/text_to_image/$LANG/6.5inchi/title_$INDEX.png"
# TODO: SUBTITLE
# SUBTITLE_65="artifacts/text_to_image/$LANG/6.5inchi/subtitle_$INDEX.png"
NOTCH_FRAME_65="scripts/resources/6.5inchi/notch.png"
ARTIFACT65="$ARTIFACT_DIR/$LANG/${INDEX}_APP_IPHONE_65_${INDEX}.png"

ROUNDED_FILE="$ARTIFACT_DIR/$LANG/${INDEX}_rounded.png"

# Create mask image for corner radius
# doc: https://www.imagemagick.org/Usage/thumbnails/#rounded
convert "${SCREENSHOT}" \
     \( +clone  -alpha extract \
        -draw 'fill black polygon 0,0 0,82 82,0 fill white circle 82,82 82,0' \
        \( +clone -flip \) -compose Multiply -composite \
        \( +clone -flop \) -compose Multiply -composite \
     \) -alpha off -compose CopyOpacity -composite  "$ROUNDED_FILE"
echo 'Rounded image generated'

# TODO: SUBTITLE
# \( "${SUBTITLE_65}" -gravity north -geometry +0+321 \) -composite \
convert "${BACKGROUND_65}" \
  \( "$ROUNDED_FILE" -resize 947x2048 -gravity north -geometry +0+682 \) -composite \
  \( "${NOTCH_FRAME_65}" -gravity north -geometry +0+603 \) -composite \
  \( "${TITLE_65}" -gravity north -geometry +0+150 \) -composite \
  -alpha off $ARTIFACT65
echo 'Generated 65 images'
