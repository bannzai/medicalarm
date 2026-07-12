# グループ機能 設計ドキュメント (issue #241)

複数人での服薬管理共有（家族・介護・小規模医療現場）。shoppinglist のソログループモデルを踏襲する。
参照実装: `/Users/bannzai/ghq/github.com/bannzai/shoppinglist`（本ドキュメント内の「SL:」は shoppinglist のファイルパス）。

## 決定事項

| 論点 | 決定 |
|---|---|
| 移行方式 | クライアント起動時のオンデマンド移行。服薬履歴は全件移行（TTL 365 日で有界）。旧 `/users/{uid}` 配下データは残置 |
| 通知設定のメンバー個別化 | v1 に含める。`MedicationSchedule.notificationSetting` はテンプレート（デフォルト）として残し、メンバー個別設定を別ドキュメントに持つ |
| 課金モデル | 個別課金。解放機能も個人単位。メンバー数上限は設けない。作成系上限は「作成者単位」で判定 |
| アカウント引き継ぎ | 匿名→Apple/Google の linkWithCredential を実装。グループ利用中（メンバー 2 人以上）かつ未リンクならホームに推奨バナー |
| 命名 | 共有グループは `Group`。既存 `MedicationGroup`（表示用グルーピング）は現状維持。コンパイル衝突なし（grep 確認済み） |
| ソログループ | shoppinglist と異なり「参加 or 作成」画面は出さず、起動時に自動作成する（既存ユーザーの無断線移行のため） |

## データ配置

```
/users/{userID}                          ← AppUser（defaultGroupID / groupMigratedDateTime を追加）
/users/{userID}/privates/{userID}        ← fcmToken / apnsToken（既存）+ fcmTokens: string[]（新設、arrayUnion）
/groups/{groupID}                        ← Group
/groups/{groupID}/userProfiles/{GroupUserProfile_groups_{groupID}_users_{userID}}
/groups/{groupID}/medicines/{medicineID}
/groups/{groupID}/doseReceivers/{doseReceiverID}
/groups/{groupID}/medicationHistories/{historyID}
/groups/{groupID}/diaries/{diaryID}
/groups/{groupID}/memberNotificationSettings/{userID}   ← メンバー個別通知設定
/groupInvitations/{invitationID}         ← クライアント直アクセス禁止（Functions 専用）
```

- 既存の `userID` フィールドの意味は「作成者（creator）の userID」に再定義する。フィールド名は後方互換のため変更しない（各 entity にコメントで明記する）
- `MedicationHistory` に `recordedByUserID: String?` を追加（旧データは null。新規は記録者 uid。`userID` にも同じ値を入れる）

## Entity

### Group（新規 `lib/entity/group.dart`。SL: `lib/entity/group.dart`）

```dart
/// 無料ユーザーがソログループに加えて作成できるグループ数の上限。
/// NOTE: サーバー側(functions/src/functions/createGroup/function.ts の FREE_ADDITIONAL_GROUP_CREATION_LIMIT)と同じ値を維持すること。
const int freeAdditionalGroupCreationLimit = 1;

@freezed
abstract class Group with _$Group {
  const Group._();
  @JsonSerializable(explicitToJson: true)
  const factory Group({
    required String id,
    required List<String> memberUserIDs,
    required String? name,          // ソログループは null 許容。ユーザー作成グループは必須
    required String? ownerUserID,
    @Default('home') String iconName,  // home / family / hospital / medication / elderly / favorite
    // timestamps 4 種（他 entity と同一）
  }) = _Group;
}
```

### GroupInvitation（新規。SL: `lib/entity/group_invitation.dart`）

status: pending / accepted / expired。フィールドは SL と同一（groupID / inviterUserID / invitationCode / status / expiresDateTime + timestamps）。クライアントから直接 read/write しない。

### GroupUserProfile（新規。SL: `lib/entity/group_user_profile.dart`）

documentID は `GroupUserProfile_groups_{groupID}_users_{userID}` の複合 ID。displayName を記録者表示に使う。

### GroupMemberNotificationSettings（新規 `lib/entity/group_member_notification_settings.dart`）

```dart
/// グループ内の「自分だけ」の通知設定。medicineID -> scheduleID -> 設定。
/// MedicationSchedule.notificationSetting はテンプレート(共有デフォルト)として残る。
@freezed
abstract class GroupMemberNotificationSettings with _$GroupMemberNotificationSettings {
  const GroupMemberNotificationSettings._();
  @JsonSerializable(explicitToJson: true)
  const factory GroupMemberNotificationSettings({
    required String id,        // = userID
    required String groupID,
    required String userID,
    @Default({}) Map<String, Map<String, MemberScheduleNotificationSetting>> settings,
    // timestamps 4 種
  }) = _GroupMemberNotificationSettings;
}

@freezed
abstract class MemberScheduleNotificationSetting with _$MemberScheduleNotificationSetting {
  @JsonSerializable(explicitToJson: true)
  const factory MemberScheduleNotificationSetting({
    required bool isReminderEnabled,
    required bool isFollowupEnabled,
    required bool useCriticalAlert,
    @Default(0.5) double criticalAlertVolume,
    @Default(false) bool useAlarmKit,
    String? focusConnectScheduleID,   // Focus 連携も端末個人の設定なので個別部に含める
  }) = _MemberScheduleNotificationSetting;
}
```

**有効設定の解決規則**（`lib/utils/local_notification/` と通知設定 UI が共通で使う）:

1. `memberSettings.settings[medicineID][scheduleID]` があればそれを使う
2. なければテンプレート `schedule.notificationSetting` を使う。ただし自分がその薬の作成者（`medicine.userID == 自分の uid`）でない場合は `useCriticalAlert: false, useAlarmKit: false` に落とす（共有された薬の Critical Alert が勝手に鳴らないため）。focusConnectScheduleID は**作成者本人に限り**テンプレート `schedule.focusConnectSetting` から引き継ぐ（グループ機能以前に Focus 連携を設定していた既存ユーザーの動作を移行後も維持するため）。他メンバーには引き継がない（端末固有設定のため）

### AppUser（変更 `lib/entity/app_user.dart`）

```dart
String? defaultGroupID,
@NullableTimestampConverter() DateTime? groupMigratedDateTime,  // 移行完了マーカー。defaultGroupID とは別に持つ（途中失敗リカバリのため）
```

## Database / Provider

### GroupDatabase（`lib/features/resolver/database.dart` に追加。SL: 同パス）

- `_CollectionPath` に groups / userProfiles / memberNotificationSettings / groups 配下 4 コレクションのパスを追加
- `GroupDatabase(groupID:)` に `medicinesReference()` / `medicineReference(medicineID:)` / `doseReceiversReference()` / `medicationHistoriesReference()` / `diariesReference()` / `userProfilesReference()` / `userProfileReference(userID:)` / `memberNotificationSettingsReference(userID:)` / `groupReference()` を実装（withConverter パターンは既存 UserDatabase と同一）
- `UserDatabase` は user / privates 専用に縮退（既存の medicines 等の参照メソッドは移行処理でのみ使用するため残す。`@Deprecated` は付けない — 移行コードが正当な利用者）

### Provider の再配線方針（既存画面の変更を最小化する）

shoppinglist は「Page が currentGroupID を watch して family provider に引数で渡す」方式だが、medicalarm は全画面の呼び出し側変更を避けるため **`currentGroupDatabaseProvider`（非 family）** を導入する:

```dart
@Riverpod(dependencies: [currentGroupID])
GroupDatabase currentGroupDatabase(Ref ref) {
  final groupID = ref.watch(currentGroupIDProvider);
  if (groupID == null) {
    throw Exception('currentGroupID is null');  // CurrentGroupResolver が非 null を保証してから子を描画する
  }
  return GroupDatabase(groupID: groupID);
}
```

- `lib/provider/{medicine,dose_receiver,medication_history,diary}.dart` の各 provider / write クラスは `userDatabaseProvider` → `currentGroupDatabaseProvider` に差し替え。呼び出し側（Page）は無変更で済む
- write クラス（MedicineAdd 等）で `userID`（作成者）が必要な箇所は `appUserIDProvider` 経由で渡す
- グループ切替時は currentGroupID の変更で全 provider が自動的に再購読される
- 新規 provider: `currentGroupIDProvider`（Notifier<String?>、SL: `lib/provider/current_group_id.dart`）/ `userGroupsProvider`（memberUserIDs arrayContains、SL: `lib/provider/user_groups.dart`）/ `defaultGroupUpdateProvider` / `groupProvider(groupID:)` / `groupUserProfilesProvider(groupID:)` / `createGroupProvider` / `createGroupInvitationProvider` / `acceptGroupInvitationProvider`（Functions 呼び出し）/ `groupMemberNotificationSettingsProvider`（current group の自分の設定 Stream）

### Resolver チェーン（`lib/features/root/page.dart`）

```
AppLocalizationResolver → AuthResolver → UserDatabaseResolver → AppUserCreateResolver
  → ForceUpdateResolver → PurchaseSetupResolver
  → GroupMigrationResolver   ← 新設
  → CurrentGroupResolver     ← 新設（SL: lib/features/resolver/current_group_resolver.dart）
  → AppEntityPrepareResolver ← 「doseReceivers が空なら firstUser 作成」を current group スコープに変更
  → PromotionStartResolver → HomePage
```

## 起動時オンデマンド移行（GroupMigrationResolver）

```
if (appUser.groupMigratedDateTime != null) → 何もしない
else:
  1. groupID = appUser.defaultGroupID
     ?? await createGroup(name: null, setAsDefault: true, iconName: 'home')  // Functions 経由
  2. /users/{uid}/{medicines,doseReceivers,medicationHistories,diaries} を全件読み、
     /groups/{groupID}/ 配下へ同一ドキュメント ID で set()（WriteBatch、500 件ずつ）
     - medicationHistories は recordedByUserID: uid を付与
  3. users/{uid}.groupMigratedDateTime = now を set（最後に書く）
```

- **冪等**: 同一 ID への set は何度実行しても同じ結果。途中失敗時は次回起動時に defaultGroupID が既にあるので手順 1 をスキップして 2 から再開される
- 新規ユーザーはコピー対象 0 件なので「ソログループ作成 + マーカー」だけが走る
- 匿名認証のため 1 uid = 1 端末であり、旧クライアントとの並行書き込みによる分岐は実質発生しない
- 実行中は既存の Launch ローディング表示

## Cloud Functions（`functions/src/functions/` に追加）

既存 `startPromotion` と同じ構成: 素の `onCall`（v2）+ `region: "asia-northeast1"` + `FUNCTION_NAME` ガードで index.ts に登録 + `core/response.ts` の OK/NG レスポンス。shoppinglist は Genkit ラップだが**ロジックだけ移植して Genkit は使わない**。

| 関数 | 仕様（SL: `firebase/functions/src/functions/<同名>/function.ts` を移植） |
|---|---|
| `createGroup` | auth uid を使用（引数の createUserID は不要）。`hasPremiumEntitlement` はトランザクション外で判定 → tx 内で `ownerUserID == uid` のグループ数を read し、無料なら `FREE_ADDITIONAL_GROUP_CREATION_LIMIT(=1) + 1` 以上で拒否 → group + userProfile + （defaultGroupID 未設定 or setAsDefault なら）users.defaultGroupID を write。非冪等（新 ID 払い出し）である旨コメント |
| `createGroupInvitation` | メンバーチェック → 8 桁コード（`ABCDEFGHJKMNPQRSTVWXY3456789` の 28 文字、crypto.randomBytes の rejection sampling でバイアス排除）→ 重複チェック最大 10 回 → 有効期限 7 日で groupInvitations に作成。戻り値 {invitationCode, expiresDateTime} |
| `acceptGroupInvitation` | pending 検索 → 期限切れなら status=expired にして NG → tx 内で再検証 + memberUserIDs arrayUnion + status=accepted + userProfile 作成。既メンバーは冪等スキップ。戻り値 groupID |
| `removeGroupMember` | owner のみ。target == owner は拒否。tx: arrayRemove + userProfile 削除 + target の defaultGroupID がこのグループなら「target が owner の最古グループ」に付け替え（無ければ null。クライアント側は defaultGroupID null かつ移行済みなら再度ソログループを createGroup するフォールバックを持つ） |
| `sendMedicationRecordNotification` | 引数 {groupID, medicineID, medicineName, doseReceiverName}。呼び出し者がメンバーであること。displayName は userProfiles からサーバ側で解決。対象 = 自分以外の全メンバーの `privates.fcmTokens[]`（`'debug_mode'` は除外）。`sendEachForMulticast` → invalid-registration-token / registration-token-not-registered を arrayRemove でクリーンアップ。0 件なら送信スキップ。通知文言は v1 は日本語固定 |
| `utils/premium.ts` | `hasPremiumEntitlement(uid)`: GET `https://api.revenuecat.com/v1/subscribers/{uid}`、entitlement `Premium`、expires_date null は無期限、失敗時は false（fail-closed）。Secret は既存の `REVENUECAT_API_SECRET` を流用（startPromotion と同じ defineSecret 名にすること。実装前に `functions/src/functions/startPromotion/function.ts` で名前を確認） |

テスト: `jest` + `ts-jest` を devDependencies に追加し `npm test` を新設（現状テスト基盤なし）。SL のテストは Genkit をモックしているが、素の onCall なのでハンドラ関数を直接テストする。

## firestore.rules / storage.rules（新規作成、`firebase.json` に firestore / storage セクション追加）

SL: `firebase/firestore.rules` の構成を踏襲:

```
function isAuth() / isUserAuth(id) / isDebugUserOf(userDocID) / isMember(memberUserIDs)

match /users/{userID} {
  allow read, write: if isUserAuth(userID) || isDebugUserOf(userID);
  match /privates/{privateID} { 同上 }
  match /{legacyCollection}/{docID} {  // medicines / doseReceivers / medicationHistories / diaries（残置データ）
    allow read, write: if isUserAuth(userID) || isDebugUserOf(userID);
  }
}

match /groupInvitations/{invitationID} { allow read, write: if false; }

match /groups/{groupID} {
  allow read, update, delete: if isMember(resource.data.memberUserIDs);
  allow create: if false;   // createGroup Function 経由のみ
  function isGroupMember() { return isMember(get(.../groups/$(groupID)).data.memberUserIDs); }
  match /userProfiles/{id}    { allow read, write: if isGroupMember(); }
  match /medicines/{id}       { allow read, write: if isGroupMember(); }
  match /doseReceivers/{id}   { allow read, write: if isGroupMember(); }
  match /medicationHistories/{id} { allow read, write: if isGroupMember(); }
  match /diaries/{id}         { allow read, write: if isGroupMember(); }
  match /memberNotificationSettings/{userID} { allow read, write: if isGroupMember(); }
}
```

- デバッグユーザーパターン `{uid}_debug_[0-9]+`（1 台の Simulator での複数ユーザー E2E 用。SL 踏襲）
- **注意**: 現行 Console 上の rules は未エクスポート。デプロイ前にユーザーが `firebase init firestore` で Console から既存 rules をダウンロードし、本ファイルと突き合わせて差分がないことを確認すること
- storage.rules: 既存 `users/{userID}/medicines/{uuid}` は本人のみ。新規アップロード先 `groups/{groupID}/medicines/{uuid}` は `firestore.get()` による memberUserIDs チェック
- Rules 単体テスト: `@firebase/rules-unit-testing` + `firebase emulators:exec --only firestore`

## 通知

- ローカル通知は現行機構（変更のたびに全キャンセル→5 日分再登録）を維持。データソースが「current group の medicines + 自分の memberNotificationSettings + 当日の medicationHistories」になる
- 他メンバーの服用記録も snapshot listener で届くので、記録済みスケジュールの通知は再登録時に自然にキャンセルされる（既存ロジックのまま）
- 服薬記録時（take）に `sendMedicationRecordNotification` を fire-and-forget で呼ぶ（unawaited。失敗しても記録自体は成功扱い）
- FCM 受信: `FirebaseMessaging.onMessage` でフォアグラウンド時に SnackBar 表示（SL: `lib/provider/fcm_notification.dart` の薄い実装を踏襲）
- トークン登録: 既存の単一 `fcmToken` フィールドに加え `fcmTokens: FieldValue.arrayUnion([token])` を書く（Functions は fcmTokens を読む）

## 課金（個別課金ポリシー）

- **グループ作成数上限**: 無料 = ソロ + 追加 1、プレミアム = 無制限。判定は `ownerUserID == 自分` のグループ数（個人単位 ✓）。クライアント表示 + createGroup Function 内で二重チェック
- **メンバー数上限**: 設けない（グループ単位のゲートは個別課金ポリシーと構造的に矛盾するため。shoppinglist も無し）
- **Medicine / DoseReceiver の maxCount**: 「グループ内で自分が作成した件数（`entity.userID == 自分`）」でカウントする（作成者単位）。グループ合計でカウントすると「プレミアム会員が 10 件作ったグループでは無料会員が 1 件も作れない」という個別課金と噛み合わない状態になるため
- **MedicationSchedule の maxCount**: 薬の属性のため従来通り「操作者の entitlement × 現在のスケジュール数」で追加可否を判定（既存 5 件の薬を無料会員が開いても壊さない。追加だけがブロックされる）

## アカウント引き継ぎ（匿名 → Apple / Google リンク）

- `sign_in_with_apple` / `google_sign_in` パッケージを追加し、`currentUser.linkWithCredential` でリンク（uid は変わらないので Firestore / RevenueCat はそのまま）
- 設定画面に「アカウント引き継ぎ」セクション。リンク済みなら provider 表示
- ホームバナー: `MedicationsPage` 先頭に、`userGroups` のいずれかが memberUserIDs.length > 1 かつ `currentUser.providerData` に apple.com / google.com が無い場合に表示。「グループ共有中はアカウント引き継ぎ設定を強く推奨」
- 必要なユーザー作業（コード外）: Firebase Console で Apple / Google プロバイダ有効化、Xcode の Sign in with Apple capability、GoogleService-Info.plist の REVERSED_CLIENT_ID URL scheme。実装時に手順をまとめて報告する
- error ケース: `credential-already-in-use`（既に別アカウントにリンク済み）はエラーメッセージ表示のみ（v1 ではアカウント切替はやらない）

## UI

| 画面 | 内容 | SL 参照 |
|---|---|---|
| グループ切替チップ | MedicationsPage 上部。groups.length <= 1 なら非表示。切替時 currentGroupID 更新 + defaultGroupUpdate | `lib/features/shopping_list/components/group_chips_bar.dart` |
| グループ一覧 | 設定画面から遷移。作成 FAB（上限到達で非表示 + プレミアム誘導バナー） | `lib/features/group_list/page.dart` |
| グループ作成 | 名前（必須）+ アイコン 6 種。作成後に招待コードダイアログ | `lib/features/group_create/page.dart` |
| グループ設定 | 名前編集（オーナーのみ）/ メンバー一覧 / メンバー削除（オーナーのみ）/ 招待コード発行・共有 / 自分の表示名編集 | `lib/features/group_setting/page.dart` |
| 招待コード入力 | 8 桁入力 → acceptGroupInvitation → 成功で current group 切替 | `lib/features/group_invitation/page.dart` |
| 記録者表示 | 服薬記録一覧で recordedByUserID != null かつ自分以外なら「◯◯さんが記録」を userProfiles displayName で表示 | - |
| 通知個別設定 | 既存 `medicine_schedule_setting_form` を「自分の memberNotificationSettings への書き込み」に変更。初期値は有効設定の解決規則 | - |

ローカライズ: 新規文言は `lib/l10n/app_ja.arb`（テンプレート）+ `app_en.arb` に追加。他 70 言語は未翻訳キーがテンプレート(ja)にフォールバックするため、一括翻訳は別途実施（要ユーザー判断）。

## テスト

- flutter test: 有効設定の解決規則 / 移行ロジック（純粋関数部分）/ Entity の fromJson/toJson
- Functions: jest（新規整備）で各関数のハンドラロジック
- Rules: `@firebase/rules-unit-testing` + Emulator（メンバー/非メンバー/デバッグユーザーの read/write 可否）
- Maestro E2E: デバッグユーザー方式（SL: `maestro/flows/virtual_pairing/` + `lib/features/developer_options/`）で招待→参加→記録同期を 1 台の Simulator で再現
