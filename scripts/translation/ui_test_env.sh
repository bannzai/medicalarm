#!/bin/bash

# xcrun simctl list devices | grep Max で見つける。
# iPhone 16 Pro Max (B81B9598-3086-4574-8AFB-674E1F641D76) (Booted)
export IPHONE_SIMULATOR_DEVICE_ID="B81B9598-3086-4574-8AFB-674E1F641D76"


# ここを変更する場合はgenerate_metadata.pyも編集する
export GENERATE_SCREENSHOT_ARTIFACT="artifacts/screenshots"