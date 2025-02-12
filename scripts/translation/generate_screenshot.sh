#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"
PROJECT_ROOT_DIR=$SCRIPT_DIR/../
cd $PROJECT_ROOT_DIR

source scripts/ui_test_env.sh

rm -rf $GENERATE_SCREENSHOT_ARTIFACT

mkdir -p $GENERATE_SCREENSHOT_ARTIFACT

# set -e はしない。テストが失敗しても継続して欲しいから
set +e
flutter drive --driver=test_driver/screenshot_test.dart --target=integration_test/screenshot_medications_test.dart --device-id=$IPHONE_SIMULATOR_DEVICE_ID
set -e
