#!/bin/bash
# 同じ成果物を Runner の Simulator で起動し、白画面の原因を切り分ける一時診断。
set -euo pipefail

APP_PATH=build/ios/iphonesimulator/Runner.app
SIMULATOR_UDID=$(xcrun simctl list devices available --json | jq -r '[.devices | to_entries | sort_by(.key) | reverse | .[] | select(.key | contains("iOS")) | .value[] | select(.name == "iPhone 17")][0].udid')
BUNDLE_ID=$(/usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' "$APP_PATH/Info.plist")
mkdir -p tmp/startup-diagnostic
xcrun simctl bootstatus "$SIMULATOR_UDID" -b
find "$APP_PATH" -name Info.plist -print0 | while IFS= read -r -d '' plist; do
  executable=$(/usr/libexec/PlistBuddy -c 'Print CFBundleExecutable' "$plist" 2>/dev/null) || continue
  if [ -f "$(dirname "$plist")/$executable" ]; then
    chmod +x "$(dirname "$plist")/$executable"
  fi
done
xcrun simctl install "$SIMULATOR_UDID" "$APP_PATH"
xcrun simctl spawn "$SIMULATOR_UDID" log stream --level debug --style compact --predicate 'process == "Runner"' > tmp/startup-diagnostic/native.log 2>&1 &
LOG_PID=$!
trap 'kill "$LOG_PID" 2>/dev/null || true; xcrun simctl shutdown "$SIMULATOR_UDID"' EXIT
xcrun simctl launch --terminate-running-process --stdout="$PWD/tmp/startup-diagnostic/stdout.log" --stderr="$PWD/tmp/startup-diagnostic/stderr.log" "$SIMULATOR_UDID" "$BUNDLE_ID"
# 初期化の既存タイムアウト（Remote Config の 1 分）を超えた状態を一度観測する。
sleep 90
# SDK のログには識別子が含まれるため、全文を公開ログ・artifact へ出さず既知のメッセージの有無だけを報告する。
for pattern in 'flutter:' 'Resolved:' 'RemoteConfig:' 'Impeller' 'Metal' 'Failed to' 'Could not' 'Unhandled Exception' 'ParallelWaitError' 'TimeoutException' 'Firebase' 'GoogleMobileAds' 'Dart VM' 'permission' 'denied' 'jit' 'mprotect'; do
  if grep -qi -- "$pattern" tmp/startup-diagnostic/*.log; then
    printf '検出あり: %s\n' "$pattern"
  else
    printf '検出なし: %s\n' "$pattern"
  fi
done
# Flutter engine 自体の診断行のみ。SDK の識別子を含む任意ログは出力しない。
grep -hE '\[(ERROR|FATAL|IMPORTANT):flutter/' tmp/startup-diagnostic/*.log || true
