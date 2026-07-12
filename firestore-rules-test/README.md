# firestore-rules-test

リポジトリルートの `firestore.rules` を Firestore Emulator 上で検証する単体テスト。
`@firebase/rules-unit-testing` + Jest。medicalarm 本体 (Flutter) / `functions/` とは独立した npm パッケージ。

## 前提

- Java (Firestore Emulator の実行に必要。JDK 11 以上)
- Firebase CLI (`firebase`) が PATH に通っていること (`npm i -g firebase-tools`)
- Node.js / npm

## セットアップ

```sh
cd firestore-rules-test
npm install
```

## テスト実行

```sh
npm test
```

内部で以下を実行する:

```sh
firebase emulators:exec --only firestore --project demo-medicalarm 'jest'
```

`emulators:exec` が Firestore Emulator を起動し、環境変数 `FIRESTORE_EMULATOR_HOST` を
子プロセス (jest) に渡す。テストは `../firestore.rules` を読み込んで Emulator にロードし、
`demo-medicalarm` (demo プロジェクト = 実 GCP プロジェクト不要) に対して評価する。

## 検証しているケース (firestore.rules)

- グループメンバーは `groups/{id}` 本体と全サブコレクション (userProfiles / medicines /
  doseReceivers / medicationHistories / diaries / memberNotificationSettings) を read/write できる
- 非メンバー・未認証は read/write とも拒否される
- クライアントからの `groups` 作成は拒否 (createGroup Function 経由のみ)、`groupInvitations` は read/write とも拒否
- `users/{uid}` ツリー (privates・レガシー medicines 等を含む) は本人のみアクセス可能
- デバッグユーザーパターン (`{uid}_debug_[0-9]+`): uid=alice は `users/alice_debug_1` を操作できるが `users/bob_debug_1` は拒否

## 対象外

- `storage.rules` はこのパッケージでは検証しない。グループ画像パスは Firestore への
  クロスサービス参照 (`firestore.get()`) を含み、Storage Emulator + Firestore Emulator の
  併用が必要なため。構文の妥当性は
  `firebase emulators:exec --only firestore,storage --project demo-medicalarm 'true'`
  でエミュレータ起動時にロード検証できる。
