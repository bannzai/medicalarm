.PHONY: secret
secret:
	echo $(FILE_FIREBASE_IOS) | base64 -D > ios/Firebase/GoogleService-Info.plist
	./scripts/secret.sh



# 引数なしの make で ios を実行する (人が手で動作確認するための入口。検査・テストは CI が行う)
.DEFAULT_GOAL := ios

.PHONY: verify
verify:
	flutter pub get
# make secret で生成した本物の secret.dart を失わないよう、無い時だけ CI (ci-test.yml) と同じサンプルから作る
	[ -f lib/secret/secret.dart ] || cp lib/secret/secret.dart.sample lib/secret/secret.dart
	flutter analyze
	flutter test

# sim-boot で用意したプロジェクト固有の iOS Simulator へ flutter run でビルドして起動する (QA.md の手順)。
# ビルドが参照する GoogleService-Info.plist と secret.dart は事前に make secret で用意する
.PHONY: ios
ios:
	@set -e; simulator_udid="$$(SCRIPT_QUIET=1 sim-boot | sed -n 's/^DEVICE_UDID=//p' | tail -n 1)"; [ -n "$$simulator_udid" ] || { echo "Error: sim-boot で Simulator を解決できません (sim-boot が PATH にあるか確認してください)" >&2; exit 1; }; flutter run -d "$$simulator_udid"
