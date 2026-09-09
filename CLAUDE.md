# Medicalarm

薬の飲み忘れの不安をなくすための、複数人の服薬管理アプリ。

## ライブラリ
@pubspec.yaml を参照。

## コーディング
### コーディング規約
- 余計な中間表現のclassを作らない。firestoreやshared_preferencesから取得したデータをそのまま使用する。やむを得ない場合はfirestoreやshared_preferencesのデータを合成したclassの作成もよしとするが必要な理由はコメントで記述すること
- 一時変数はnullableな変数のアンラップの用途以外で宣言しない。2箇所以上繰り返し使われるものや、長すぎる条件式(60文字超)をまとめる、その要素を表現するために関連する変数が3つ以上の場合は検討する。「わかりやすくなる」という主観的な目的では行わない。
- コンポーネント内で状態管理の完結を目指す。
- 親からの状態共有は ValueNotifier を子コンポーネント間で共有する。コールバックは使わない。もし使用したい場合は理由をコメントに書く
- ValueNotifierのaddListenerは基本的にわかりづらいのでやらない。許容するケースは SharedPreferences と同期をしたい時
- 関数・メソッドの引数は原則 `{required}` でラベルが呼び出し元につくようにする
- コンストラクタの引数も nullable であっても `required` をつける。ただしtimestamp等のメタデータフィールドは除く
- Entityのフィールド名は省略せず、長くても実態がわかる名前をつける
- FirestoreのDBをクライアントから操作する場合は、`call` 関数を定義したclassを通じて行い、Providerからそのインスタンスを返す（参考: @lib/provider/medicine.dart の `MedicineAdd`）
- firestoreのDBに書き込むProviderでは、ref.readを使用してClosureの中で呼ぶ
- エラーメッセージについては、基本的にそのまま表示する（`e.toString()` の加工・プレフィックス除去等はしない）
- Firestoreのサブコレクションに保存されるEntityは、親ドキュメントのIDをフィールドとして保持する（詳細: `documents/entity-parent-id-rules.md`）

### ケーススタディ
#### 一覧画面・マスター画面
- 基本的にユースケースごとに Firestore からデータを取得するProviderを作成して、それをref.watchしてください
  * 参考画面: @lib/features/medicines/page.dart
  * 参考Provider: @lib/provider/medicine.dart

#### フォーム画面
既存の以下の画面を参考にしてください
- @lib/features/medicine_form/page.dart 
- @lib/features/dose_receiver_form/page.dart 
- @lib/features/medication_frequency_form/page.dart 
- @lib/features/medicine_schedule_setting_form/page.dart

### ファイル構成・命名規則
- `lib/entity/` にはFirestoreのドキュメントを表現するクラスと、Widgetの表現にどうしても必要なドメインモデルを置く。
- `lib/features/` は画面・機能ごとにディレクトリを分割する。
- コンポーネントは `lib/components/` 配下で都合よくパッケージを分割する。atoms/molecules/organisms/page/templateのAtomic Design構成は非推奨。

### Lint・フォーマット
- @analysis_options.yaml を参照。フォーマットは `dart format lib -l 150`。

### コード生成
- `build_runner` を使用
- 対象: freezed, json_serializable, riverpod_generator
- 実行コマンド: `flutter pub run build_runner build --delete-conflicting-outputs`。生成後は「Lint・フォーマット」のコマンドを実行する。

### テスト
- テストファイルは `test/` ディレクトリに配置
- 日本語でのコメントを推奨
- MockitoによるMock生成を活用

### Git管理
- 自動生成ファイル（`*.g.dart`, `*.freezed.dart`）も commit 対象

## Plan時に考慮すること
- 必ず実装修正内容の動作確認のチェックリストを作ってください。それを確認するテストも後述する検証方法を参考に用意して検証完了までを行ってください
- プランファイルには必ず具体的な実装コード提案（コードブロック）を含めること。説明のみのプランは不可
- プランファイル末尾に `.claude/rules/plan-checklist.md` のチェックリストを追記すること

### Flutter
iOS,Androidアプリをサポートします。Firebase の設定ファイルは flutterfireの.jsonを定義する方法を使用せずに、iOSではGoogleService-Info.plist,Androidでは、google-service.jsonの配置を行い構成します

#### ビルド・テスト・検証方法
実装後は手動テスト前に必ず、以下のテストを実行する。該当するものがなければテストを新規作成する。作成・実行が難しい場合はユーザーに報告する。

- コード生成: `dart run build_runner build` (freezed/json_serializable/riverpod_generator の生成ファイルを更新)
- iOS ビルド: `flutter build ios`
- Android ビルド: `flutter build apk` または `flutter build appbundle`
- テスト実行: `flutter test`
- Widget Test: widget 上の表示の条件分岐が多い・複雑の場合に書く:`flutter test`
- 静的解析: `flutter analyze`
- Maestro E2E テスト: `maestro test maestro/flows/`。 `./maestro` にテストを記載する
- 動作確認 (UI・挙動): `/ios-simulator` skill を起点にし、**特別な理由がない限り simtunnel (GitHub Actions macOS Runner 上のリモート iOS Simulator) で行う**。ローカル simulator (sim-boot) は既定にしない。issue や手順書にローカル前提の記述 (`make secret` からの `flutter run`・`sim-boot` 等) があっても、それだけではローカルに倒す理由にしない
  - 手順: 検証対象のブランチを push してから `SIMTUNNEL_REPO=bannzai/medicalarm ~/ghq/github.com/bannzai/simtunnel/local/simtunnel up <セッション名> --ref <ブランチ> --wait` で起動する (`--ref` を省略すると main がビルドされる)。caller workflow は `.github/workflows/simulator-session.yml`、セッション名は `medicalarm-<worktree 名>` (例: `medicalarm-issue-12`。tailnet ホスト名が repo 横断で衝突しないよう worktree 名だけにしない)。セッション名は `^[a-z0-9-]+$` のみ許可されるため、worktree 名に大文字・`_`・`/` が含まれる場合は小文字化し `-` に置換して正規化し、`up`・操作 (`--session`)・`down` で同じ正規化後の名前を使う。操作・スクリーンショットは `/ios-simulator` skill の `scripts/ios-wda.sh --session <セッション名>` (セッション途中から使う場合) か、`.mcp.json` に書き込んだ mobile-mcp 互換ツールで行う。確認が終わったら `SIMTUNNEL_REPO=bannzai/medicalarm ~/ghq/github.com/bannzai/simtunnel/local/simtunnel down <セッション名>` で閉じる (`up` と同じ repo を渡す。macOS runner の並列上限を CI と共有するため放置しない)
  - 到達困難な状態 (課金状態・日時経過等) は開発者メニューで作る。リモートでは `xcrun simctl` や起動引数を使えないため、必要な操作が無ければ開発者メニューに追加してから検証する
  - ローカル sim-boot (`/sim-manager`) に倒してよいのは、mobile-mcp 互換ツールの操作だけでは検証が成立しない場合 (Maestro E2E・`xcrun simctl` が検証の本体である手順) と、`/ios-simulator` skill Phase 1 が定める運用上の条件 (検証対象が未 push・即時性が必要・セッション自動終了時間を超える作業・macOS Runner の並列上限・tailnet 未接続・repo が private に変わった・simtunnel の実行権限が無い非対話実行・Secrets 未登録で導入が未完了) に当たる場合だけ。いずれの場合も、ローカルに倒した理由を完了報告に明記する (使い分けの SSOT は `/ios-simulator` skill Phase 1)

### Firebase
#### ビルド・テスト・検証方法
以下のコマンドは全て `firebase/functions/` ディレクトリで実行する

- Linter (ESLint + Prettier): `npm run lint` (自動修正: `npm run lint:fix`)
- ビルド: `npm run build` (内部で `tsc` を実行)
- ユニットテスト: `npm test` (Jest)
- Firebase Emulator での検証: `npm run serve` (ビルド後に Emulator 起動)

#### 規約
- 原則: onDocumentCreated,onDocumentUpdated によるトリガーによる処理を禁止します。コードがトレースしにくくなり、思わぬタイミングで発動してしまうのでコントロールがむず痒いためです
- Deployはユーザーが行うので禁止
