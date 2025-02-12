#!/bin/sh
set -eu
set -o pipefail

DATE=$(date '+%Y%m.%d.%H%M%S')
git fetch origin
git switch -c release/$DATE origin/main

REVENUE_CAT_PUBLIC_API_KEY=$REVENUE_CAT_PUBLIC_API_KEY_PROD
FILE_FIREBASE_IOS=$FILE_FIREBASE_IOS_PROD

make secret

CURRENT_VERSION=$(grep -E '^version:' "pubspec.yaml" | awk '{print $2}')
BUILD_NUMBER=$(echo "$CURRENT_VERSION" | grep -oE '\+[0-9]+' | tr -d '+')
NEW_BUILD_NUMBER=$((BUILD_NUMBER + 1))
NEW_VERSION="$DATE+$NEW_BUILD_NUMBER"
sed -i "" "s/^version: .*/version: $NEW_VERSION/" pubspec.yaml


git add pubspec.yaml
git commit -m ":up: to $DATE"

git push origin $(git rev-parse --abbrev-ref HEAD)
gh pr create --fill --base main --head $(git rev-parse --abbrev-ref HEAD)

git fetch origin

# wait for create pull-request
sleep 5

# NOTE: --merge option will be create merge commit
gh pr merge --merge --delete-branch

git fetch origin
git switch -d origin/main

flutter build ipa --release --export-options-plist=$(pwd -P)/ios/Config/ExportOptions.plist
xcrun altool --upload-app --type ios -f "./build/ios/ipa/medicalarm.ipa" -u "$APPLE_ID" -p "$APPLE_APP_PASSWORD"

git tag $DATE
git push origin --tags

gh release create $DATE --generate-notes

