
#!/bin/bash
set -euo pipefail

# MEMO: imagemagickのstrokeがFigmaのstrokeと違い、ギザギザにならないのと、外側に広がらず、内側と外側に広がることしかできないので諦めた


SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"
PROJECT_ROOT_DIR=$SCRIPT_DIR/../
cd $PROJECT_ROOT_DIR

TITLE=$1
SUBTITLE=$2
LANGUAGE=$3
INDEX=$4

ARTIFACTS=artifacts/text_to_image


mkdir -p "$ARTIFACTS/$LANGUAGE"
mkdir -p "$ARTIFACTS/$LANGUAGE/6.5inchi"

echo "BEGIN text-to-image TITLE:$TITLE, SUBTITLE:$SUBTITLE, LANGUAGE:$LANGUAGE"

echo 'start 6.5inchi'
# 6.7inchi
if [ ! -d "$ARTIFACTS/$LANGUAGE/6.5inchi/title_$INDEX.png" ]; then
  if [ -z "$TITLE" ]; then
    # 空文字で生成できない&何かしらlabelが必要だったので、`a` で出力して fillをnoneにして透明にしている
    convert -size 1284x330 -background none -font '/Library/Fonts/Arial Unicode.ttf' -pointsize 120 -fill none -gravity center label:"a" "$ARTIFACTS/$LANGUAGE/6.5inchi/title_$INDEX.png"
  else
    # TODO: SUBTITLE
    # subtitleを一旦表示しないのでたかさを330にする
    # convert -size 1284x270 -background none -font '/Library/Fonts/Arial Unicode.ttf' -pointsize 120 -fill 'white' -gravity center label:"$TITLE" "$ARTIFACTS/$LANGUAGE/6.5inchi/title_$INDEX.png"
    # convert -size 1284x196 -background none -font '/Library/Fonts/Arial Unicode.ttf' -pointsize 70 -fill 'white' -gravity center label:"$SUBTITLE" "$ARTIFACTS/$LANGUAGE/6.5inchi/subtitle_$INDEX.png"
    convert -size 1284x330 -background none -font '/Library/Fonts/Arial Unicode.ttf' -pointsize 120 -fill '#800080' -gravity center label:"$TITLE" "$ARTIFACTS/$LANGUAGE/6.5inchi/title_$INDEX.png"
  fi
else
  echo "Skipping 6.5inchi text for $LANGUAGE"
fi

echo "END text-to-image TITLE:$TITLE, SUBTITLE:$SUBTITLE, LANGUAGE:$LANGUAGE"

