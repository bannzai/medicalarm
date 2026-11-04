#!/bin/bash
# scripts/release.sh の --dry-run と引数・環境変数の検査を確かめる。リポジトリのルートで実行する。
# 状態を変えるコマンドは PATH の先頭の偽物に差し替えて呼び出しを記録し、本物のリリースが走らないようにする。
# zsh -f で起動する。~/.zshenv を読むと本物の ASC_API_KEY_* が入り、未設定の検査ができないため。
set -u

failures=0
mkdir -p tmp
work_dir=$(mktemp -d "$PWD/tmp/release-dry-run.XXXXXX")
stub_dir="$work_dir/bin"
calls_file="$work_dir/calls"
mkdir -p "$stub_dir" "$work_dir/home/.appstoreconnect/private_keys"
touch "$work_dir/home/.appstoreconnect/private_keys/AuthKey_FAKEKEYID.p8"

for command_name in git gh make xcrun fvm flutter sleep sed; do
  cat >"$stub_dir/$command_name" <<'EOF'
#!/bin/bash
echo "$(basename "$0") $*" >>"$CALLS_FILE"
EOF
  chmod +x "$stub_dir/$command_name"
done

# 第 1 引数の説明で、残りの引数の判定コマンドの成否を PASS / FAIL と表示する。失敗すると failures を増やす。
assert() {
  local description=$1
  shift
  if "$@"; then
    echo "PASS: $description"
  else
    echo "FAIL: $description"
    failures=$((failures + 1))
  fi
}

# 偽物の呼び出しの記録を空にして release.sh を実行し、output と exit_code に結果を入れる
run_release() {
  : >"$calls_file"
  exit_code=0
  output=$(env -u ASC_API_KEY_ID -u ASC_API_KEY_ISSUER_ID -u APPLE_ID -u APPLE_APP_PASSWORD -u API_PRIVATE_KEYS_DIR HOME="$work_dir/home" PATH="$stub_dir:$PATH" CALLS_FILE="$calls_file" "$@" 2>&1) || exit_code=$?
}

# release.sh の出力が固定文字列を含むかを返す。
output_has() { grep -qF -- "$1" <<<"$output"; }
# release.sh の出力が正規表現に一致しないかを返す。
output_lacks() { ! grep -qE -- "$1" <<<"$output"; }
# 偽物のコマンドの呼び出しの記録全体が引数と等しいかを返す。
calls_are() { [ "$(cat "$calls_file")" = "$1" ]; }

pubspec_before=$(cksum pubspec.yaml)

run_release ASC_API_KEY_ID=FAKEKEYID ASC_API_KEY_ISSUER_ID=FAKEISSUER APPLE_ID=apple-id-value APPLE_APP_PASSWORD=app-password-value \
  zsh -f scripts/release.sh --dry-run
assert "--dry-run は exit 0" [ "$exit_code" -eq 0 ]
assert "ビルドは fvm の Flutter を使う" output_has "[dry-run] fvm flutter build ipa --release"
assert "fvm を介さない flutter build を表示しない" output_lacks '^\[dry-run\] flutter build'
assert "アップロードは ASC の API key を使う" output_has "--api-key FAKEKEYID --api-issuer FAKEISSUER"
assert "Apple ID を使わない" output_lacks "apple-id-value"
assert "アプリ用パスワードを使わない" output_lacks "app-password-value"
assert ".fvmrc の版を表示する" output_has '[dry-run] .fvmrc: "flutter":'
assert "コマンドは表示だけで何も実行しない" calls_are ""
assert "pubspec.yaml を書き換えない" [ "$pubspec_before" = "$(cksum pubspec.yaml)" ]

run_release ASC_API_KEY_ISSUER_ID=FAKEISSUER zsh -f scripts/release.sh --dry-run
assert "ASC_API_KEY_ID が無ければ失敗する" [ "$exit_code" -ne 0 ]
assert "未設定の変数名を出す" output_has "ASC_API_KEY_ID が未設定です"

run_release zsh -f scripts/release.sh
assert "本番の実行でも環境変数が無ければ失敗する" [ "$exit_code" -ne 0 ]
assert "環境変数が無ければ何も実行しない" calls_are ""

run_release ASC_API_KEY_ID=NOKEYFILE ASC_API_KEY_ISSUER_ID=FAKEISSUER zsh -f scripts/release.sh
assert "API key のファイルが無ければ失敗する" [ "$exit_code" -ne 0 ]
assert "無いファイル名を出す" output_has "AuthKey_NOKEYFILE.p8 が見つかりません"
assert "API key のファイルが無ければ何も実行しない" calls_are ""

# 本物の fvm を見つけないよう、偽物の fvm を消した PATH (標準のコマンドだけ) で実行する
fvm_stub="$stub_dir/fvm"
mv "$fvm_stub" "$fvm_stub.disabled"
run_release ASC_API_KEY_ID=FAKEKEYID ASC_API_KEY_ISSUER_ID=FAKEISSUER PATH="$stub_dir:/usr/bin:/bin" /bin/zsh -f scripts/release.sh
mv "$fvm_stub.disabled" "$fvm_stub"
assert "fvm が無ければ失敗する" [ "$exit_code" -ne 0 ]
assert "fvm が無いことを出す" output_has "fvm が見つかりません"
assert "fvm が無ければ何も実行しない" calls_are ""

run_release ASC_API_KEY_ID=FAKEKEYID ASC_API_KEY_ISSUER_ID=FAKEISSUER zsh -f scripts/release.sh --dryrun
assert "未知の引数は exit 2" [ "$exit_code" -eq 2 ]
assert "未知の引数では何も実行しない" calls_are ""

run_release ASC_API_KEY_ID=FAKEKEYID ASC_API_KEY_ISSUER_ID=FAKEISSUER zsh -f scripts/release.sh ""
assert "空の引数は exit 2" [ "$exit_code" -eq 2 ]
assert "空の引数では何も実行しない" calls_are ""

run_release ASC_API_KEY_ID=FAKEKEYID ASC_API_KEY_ISSUER_ID=FAKEISSUER zsh -f scripts/release.sh --dry-run extra
assert "余分な引数は exit 2" [ "$exit_code" -eq 2 ]

unreadable_key="$work_dir/home/.appstoreconnect/private_keys/AuthKey_UNREADABLE.p8"
touch "$unreadable_key"
chmod 000 "$unreadable_key"
run_release ASC_API_KEY_ID=UNREADABLE ASC_API_KEY_ISSUER_ID=FAKEISSUER zsh -f scripts/release.sh
assert "読み取れない API key のファイルでは失敗する" [ "$exit_code" -ne 0 ]
assert "読み取れない API key のファイルでは何も実行しない" calls_are ""

run_release ASC_API_KEY_ID=FAKEKEYID ASC_API_KEY_ISSUER_ID=FAKEISSUER zsh -f scripts/release.sh
# 偽物のコマンドの呼び出しの記録が固定文字列を含むかを返す。
calls_have() { grep -qF -- "$1" "$calls_file"; }
# 偽物のコマンドの呼び出しの記録が正規表現に一致しないかを返す。
calls_lack() { ! grep -qE -- "$1" "$calls_file"; }
assert "本番の実行は exit 0" [ "$exit_code" -eq 0 ]
assert "本番の実行は fvm の Flutter でビルドする" calls_have "fvm flutter build ipa --release"
assert "本番の実行は PATH の Flutter を呼ばない" calls_lack '^flutter '
assert "本番の実行は ASC の API key でアップロードする" calls_have "xcrun altool --upload-app --type ios -f ./build/ios/ipa/medicalarm.ipa --api-key FAKEKEYID --api-issuer FAKEISSUER"
assert "本番の実行は tag と release まで進む" calls_have "gh release create"

if [ "$failures" -ne 0 ]; then
  echo "$failures 件失敗"
  exit 1
fi
echo "全件 PASS"
