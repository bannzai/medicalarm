#!/bin/zsh
# リリース PR のマージ・ビルド・App Store Connect へのアップロード・tag・GitHub release を行う。
# 実行のたびに新しいバージョンを発行してアップロードするため冪等にできない。
# 使い方: scripts/release.sh [--dry-run]
#   --dry-run: 何も変更せず、実行するコマンドを表示する
set -eu
set -o pipefail

# 綴りを間違えた引数で本番のリリースが走らないよう、未知の引数は拒否する
case "${1:-}" in
  "") DRY_RUN=0 ;;
  --dry-run) DRY_RUN=1 ;;
  *)
    echo "Usage: $0 [--dry-run]" >&2
    exit 2
    ;;
esac

if [[ "$DRY_RUN" == 0 ]]; then
  set -x
fi

# ビルドやアップロードの時点で欠けていると、リリース PR のマージ後に止まるため先に確かめる
command -v fvm >/dev/null || {
  echo "fvm が見つかりません" >&2
  exit 1
}
: "${ASC_API_KEY_ID:?ASC_API_KEY_ID が未設定です}"
: "${ASC_API_KEY_ISSUER_ID:?ASC_API_KEY_ISSUER_ID が未設定です}"
# 探す場所は `xcrun altool --help` の --api-key の説明のとおり
if ! [[ -f ./private_keys/AuthKey_$ASC_API_KEY_ID.p8 ||
  -f ~/private_keys/AuthKey_$ASC_API_KEY_ID.p8 ||
  -f ~/.private_keys/AuthKey_$ASC_API_KEY_ID.p8 ||
  -f ~/.appstoreconnect/private_keys/AuthKey_$ASC_API_KEY_ID.p8 ||
  -f ${API_PRIVATE_KEYS_DIR:-./private_keys}/AuthKey_$ASC_API_KEY_ID.p8 ]]; then
  echo "AuthKey_$ASC_API_KEY_ID.p8 が見つかりません (~/.appstoreconnect/private_keys に置く)" >&2
  exit 1
fi

# 状態を変えるコマンドを実行する。--dry-run の時は実行せず表示だけする。
run() {
  if [[ "$DRY_RUN" == 1 ]]; then
    print -r -- "[dry-run]" ${(q)@}
  else
    "$@"
  fi
}

DATE=$(date '+%Y%m.%d.%H%M%S')
run git fetch origin
run git switch -c release/$DATE origin/main

# REVENUE_CAT_PUBLIC_API_KEY=$REVENUE_CAT_PUBLIC_API_KEY_PROD
# FILE_FIREBASE_IOS=$FILE_FIREBASE_IOS_PROD

run make secret

CURRENT_VERSION=$(grep -E '^version:' "pubspec.yaml" | awk '{print $2}')
BUILD_NUMBER=$(echo "$CURRENT_VERSION" | grep -oE '\+[0-9]+' | tr -d '+')
NEW_BUILD_NUMBER=$((BUILD_NUMBER + 1))
NEW_VERSION="$DATE+$NEW_BUILD_NUMBER"
run sed -i "" "s/^version: .*/version: $NEW_VERSION/" pubspec.yaml


run git add pubspec.yaml
run git commit -m ":up: to $DATE"

run git push origin release/$DATE
run gh pr create --fill --base main --head release/$DATE

run git fetch origin

# wait for create pull-request
run sleep 5

# NOTE: --merge option will be create merge commit
run gh pr merge --merge --delete-branch

run git fetch origin
run git switch -d origin/main

# ビルドに使う版をログに残す。PATH の Flutter は版が保証されないため、CI の flutter-version と同じ版を .fvmrc で固定している
run fvm flutter --version
if [[ "$DRY_RUN" == 1 ]]; then
  print -r -- "[dry-run] .fvmrc:" $(grep '"flutter"' .fvmrc)
fi
run fvm flutter build ipa --release --export-options-plist=$(pwd -P)/ios/Config/ExportOptions.plist
run xcrun altool --upload-app --type ios -f "./build/ios/ipa/medicalarm.ipa" --api-key "$ASC_API_KEY_ID" --api-issuer "$ASC_API_KEY_ISSUER_ID"

run git tag $DATE
run git push origin --tags

run gh release create $DATE --generate-notes

