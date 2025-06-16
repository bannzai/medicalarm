# Medicalarm

Medicalarmは薬の飲み忘れの不安をなくす。をコンセプトとした服薬管理アプリです。iOSアプリです。Critical Alertが備え付けられているアプリです。
複数人の人を管理できることを前提にして設計されております。お子さんがいる方など、誰かの代わりに服薬管理をする必要がある場合にも特に便利にお使いいただけます
アプリ上では薬を登録してリマインダーの設定をすることで通知を受け取り、服用日時を服薬記録として振り返ることができます

## ライブラリ
@pubspec.yaml を参照。以下基礎的な部分の概要です

- firebase_auth: ユーザー認証。匿名認証がアプリ開始時に走る
- cloud_firestore: DB。基本的にsnapshot listenerによりデータを取得
- purchases_flutter(RevenueCat): サブスクリプション管理
- flutter_hooks: インターナルな状態管理。Pageより下の状態管理。コンポーネント間の状態管理
- riverpod: アプリ全体の状態管理。全体で使用する設定。非同期処理の結果をAsyncValueを通じて使用する
- freezed: firestoreのドキュメントごとの構造を表現。そのほかのデータ構造を表現

## コーディング
コーディング時に見て欲しいルール

### コーディング規約
- 余計な中間表現のclassを作らない。firestoreやshared_preferencesから取得したデータをそのまま使用する。やむを得ない場合はfirestoreやshared_preferencesのデータを合成したclassの作成もよしとするが必要な理由はコメントで記述すること
- 一時変数はnullableな変数のアンラップの用途以外で宣言しない。2箇所以上繰り返し使われるものや、長すぎる条件式(60文字超)をまとめる、その要素を表現するために関連する変数が3つ以上の場合は検討する。「わかりやすくなる」という主観的な目的では行わない。
- コンポーネント内で状態管理の完結を目指す。
- 親からの状態共有は ValueNotifier を子コンポーネント間で共有する。コールバックは使わない。もし使用したい場合は理由をコメントに書く
- ValueNotifierのaddListenerは基本的にわかりづらいのでやらない。許容するケースは SharedPreferences と同期をしたい時
- 関数、メソッドの引数は、{required} をつけましょう。引数ラベルがないとわかりづらいです

### ケースうスタディ
#### 一覧画面・マスター画面
- 基本的にユースケースごとに Firestore からデータを取得するProviderを作成して、それをref.watchしてください
  * 参考画面: @lib/features/medicines/page.dart
  * 参考Provider: @lib/provider/medicine.dart

#### フォーム画面
- final state = useState(0); のようにuseStateを多用すると思います
- ref.watch(mutationProvider) のようにFirestoreの変更をする場合は専用の call 関数を持つclassのproviderを作成してください。 ref: @lib/provider/medicine.dart の `MedicineAdd`

既存の以下の画面を参考にしてください
- @lib/features/medicine_form/page.dart 
- @lib/features/dose_receiver_form/page.dart 
- @lib/features/medication_frequency_form/page.dart 
- @lib/features/medicine_schedule_setting_form/page.dart

### ファイル構成・命名規則
- **エンティティ**: `lib/entity/`: Firestoreのドキュメントを表現するクラス。また、Widgetの表現にどうしても必要な中間表現、いわゆるドメインモデルも含まれる
- **Provider**: `lib/provider/`: Riverpodプロバイダー
- **機能別ディレクトリ**: `lib/features/`: 各画面・機能ごとにディレクトリを分割
- **コンポーネント**: `lib/components/` 
  * Deprecated: atoms/molecules/organisms/page/templateのAtomic Design構成
  * components/の下は特にルールなく都合よくパッケージを切っていきましょう
- **スタイル**: アプリのコンポーネントに適応するスタイル群。Button等に共通で使用するStyleがある
- **テーマ**: アプリ全体のスタイルを決定するテーマ。例えばForm画面のテーマなどがある
- **ユーティリティ**: 便利関数。クラスたち

### Lintルール (analysis_options.yaml)
- 1ラインは150行
- その他は、 @analysis_options.yaml を参照

### コード生成
- `build_runner` を使用
- 対象: freezed, json_serializable, riverpod_generator
- 実行コマンド: `flutter pub run build_runner build --delete-conflicting-outputs;dart format lib -l 150`

### テスト
- テストファイルは `test/` ディレクトリに配置
- 日本語でのコメントを推奨
- MockitoによるMock生成を活用

### Git管理
- 自動生成ファイル（`*.g.dart`, `*.freezed.dart`）も commit 対象