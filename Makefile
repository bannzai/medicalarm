.PHONY: secret
secret:
	echo $(FILE_FIREBASE_IOS) | base64 -D > ios/Firebase/GoogleService-Info.plist
	./scripts/secret.sh



# 引数なしの make で動作確認 (verify) を実行する
.DEFAULT_GOAL := verify

.PHONY: verify
verify:
	flutter pub get
# make secret で生成した本物の secret.dart を失わないよう、無い時だけ CI (ci-lint.yml) と同じサンプルから作る
	[ -f lib/secret/secret.dart ] || sed "s/\"/'/g" lib/secret/secret.dart.sample > lib/secret/secret.dart
	flutter analyze
	flutter test
