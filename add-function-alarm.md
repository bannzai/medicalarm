# AlarmKit機能追加プラン

## 概要
iOS 26+で利用可能なAlarmKitを使用して、サイレントモード・フォーカスモード時でも確実に服薬リマインダーを通知する機能を追加する。

## 前提条件
- iOS 26+でのみ利用可能
- Critical Alertを使用して確実に通知
- 既存のlocal notification機能との共存
- プレミアム機能として提供

## 実装フェーズ

### Phase 1: iOS Native実装

#### 1.1 AlarmKitManager.swift の追加
**ファイル位置**: `ios/Runner/AlarmKitManager.swift`

**実装内容**:
- AlarmKit機能へのアクセスを提供するマネージャークラス
- 認証状態の管理 (authorized, denied, notDetermined, notAvailable)
- アラーム登録・解除・停止機能

**主要メソッド**:
```swift
class AlarmKitManager {
    static let shared = AlarmKitManager()
    
    // 利用可能性チェック (iOS 26+)
    func isAvailableForCurrentOS() -> Bool
    
    // 認証状態取得
    func getAuthorizationStatus() -> String
    
    // 権限リクエスト
    func requestPermission() async -> Bool
    
    // 服薬アラーム登録
    func scheduleMedicationAlarm(
        localNotificationID: String,
        title: String,
        scheduledTime: Date
    ) async throws
    
    // 全アラーム解除
    func cancelAllMedicationAlarms() async throws
    
    // 全アラーム停止
    func stopAllAlarms() async throws
}
```

#### 1.2 AppIntent.swift の追加  
**ファイル位置**: `ios/Runner/AppIntent.swift`

**実装内容**:
- AlarmKit用のApp Intent実装
- Live Activity用のIntent
- アラーム停止時のアプリ起動

#### 1.3 iOS設定ファイルの更新

**Info.plist**:
```xml
<key>NSAlarmKitUsageDescription</key>
<string>服薬時刻にアラームを表示するために利用します</string>
```

**Xcode プロジェクト設定**:
- AlarmKit frameworkの追加
- App Intent Extensionの設定

#### 1.4 AppDelegate.swift の更新
**Method Channel**の追加:
- `isAlarmKitAvailable`
- `getAlarmKitAuthorizationStatus`  
- `requestAlarmKitPermission`
- `scheduleAlarmKitReminder`
- `cancelAllAlarmKitReminders`
- `stopAllAlarmKitAlarms`

### Phase 2: Flutter側実装

#### 2.1 AlarmKitService の追加
**ファイル位置**: `lib/utils/alarm_kit_service.dart`

**実装内容**:
```dart
enum AlarmKitAuthorizationStatus {
  authorized,
  denied, 
  notDetermined,
  notAvailable
}

class AlarmKitService {
  static const MethodChannel _channel = MethodChannel('method.channel.bannzai.Medicalarm');
  
  // 利用可能性チェック
  static Future<bool> isAvailable()
  
  // 認証状態取得
  static Future<AlarmKitAuthorizationStatus> getAuthorizationStatus()
  
  // 権限リクエスト
  static Future<bool> requestPermission()
  
  // アラーム登録
  static Future<void> scheduleMedicationReminder({
    required String localNotificationID,
    required String title,
    required DateTime reminderDateTime,
  })
  
  // 全アラーム解除
  static Future<void> cancelAllMedicationReminders()
  
  // 全アラーム停止
  static Future<void> stopAllAlarms()
}
```

#### 2.2 Setting エンティティの拡張
**ファイル位置**: `lib/entity/setting.codegen.dart`

**追加項目**:
```dart
/// AlarmKit機能の有効フラグ
@Default(false) bool useAlarmKit,

/// Critical Alert音量設定 (0.0-1.0)
@Default(0.5) double criticalAlertVolume,
```

### Phase 3: UI・設定画面の実装

#### 3.1 AlarmKit設定UI の追加
**ファイル位置**: `lib/features/settings/components/rows/alarm_kit.dart`

**実装内容**:
- iOS 26+でのみ表示
- プレミアム機能としての制限
- 権限状態の表示
- オン/オフ切り替え
- 音量調整スライダー

**主要機能**:
- 権限リクエスト処理
- エラーハンドリング
- ローディング状態管理

#### 3.2 設定画面への統合
**ファイル位置**: `lib/features/settings/page.dart`

**追加箇所**:
```dart
// Critical Alert設定の後に追加
AlarmKitSetting(
  setting: setting, 
  isPremium: user.isPremium, 
  isTrial: user.isTrial
),
```

### Phase 4: 通知システムとの統合

#### 4.1 RegisterReminderLocalNotification の更新
**ファイル位置**: `lib/utils/local_notification.dart`

**変更内容**:
- AlarmKit使用判定の追加
- Local NotificationとAlarmKitの並行登録
- エラー時のフォールバック処理

**実装例**:
```dart
// AlarmKit使用判定
final useAlarmKit = setting.useAlarmKit && await AlarmKitService.isAvailable();

// Local Notification登録
await localNotificationService.plugin.zonedSchedule(...)

// AlarmKit登録（エラーが発生しても継続）
if (useAlarmKit) {
  try {
    await AlarmKitService.scheduleMedicationReminder(...)
  } catch (e) {
    // ログ記録のみ、処理は継続
  }
}
```

#### 4.2 CancelReminderLocalNotification の更新
**実装内容**:
- Local Notification解除
- AlarmKit解除の追加
- エラーハンドリング

#### 4.3 TakePill の更新
**ファイル位置**: `lib/provider/take_pill.dart`

**変更内容**:
- 服用記録時のアラーム停止
- `AlarmKitService.stopAllAlarms()`の呼び出し

### Phase 5: テスト・デバッグ

#### 5.1 単体テスト
- AlarmKitService の各メソッドテスト
- 権限状態別のテスト
- エラーケースのテスト

#### 5.2 統合テスト  
- 既存通知機能との共存テスト
- プレミアム機能制限のテスト
- iOS 26未満での動作テスト

#### 5.3 実機テスト
- 実際のアラーム動作確認
- サイレントモード時の動作確認
- フォーカスモード時の動作確認

## 実装順序

1. ✅ **Phase 1**: iOS Native実装
   - [ ] AlarmKitManager.swift
   - [ ] AppIntent.swift  
   - [ ] Info.plist更新
   - [ ] AppDelegate.swift更新

2. ✅ **Phase 2**: Flutter側実装
   - [ ] AlarmKitService.dart
   - [ ] Setting エンティティ拡張

3. ✅ **Phase 3**: UI実装
   - [ ] AlarmKit設定画面
   - [ ] 設定画面統合

4. ✅ **Phase 4**: 通知システム統合
   - [ ] RegisterReminderLocalNotification更新
   - [ ] CancelReminderLocalNotification更新
   - [ ] TakePill更新

5. ✅ **Phase 5**: テスト・デバッグ
   - [ ] ビルドが通るかをテスト: flutter build ios --no-codesign
   - [ ] flutter test: flutter build ios --no-codesign

## 注意事項

### プレミアム機能
- 有料ユーザーのみ利用可能
- 無料ユーザーには案内のみ表示

### 既存機能との共存
- AlarmKitエラー時はlocal notificationで継続
- 両方同時登録で確実性向上
- 既存の通知設定を維持

### 権限管理
- 初回利用時の丁寧な権限説明
- 拒否時の再設定案内
- システム設定への誘導

### エラーハンドリング  
- AlarmKit関連エラーはログ記録のみ
- 既存機能への影響を最小限に
- ユーザーへの適切なエラーメッセージ

### パフォーマンス
- AlarmKit処理の非同期実行
- タイムアウト処理の実装
- メモリリークの防止

## 参考情報

### Pilllからの削除内容
- AlarmKitManager.swift (182行)
- AppIntent.swift (76行)  
- AlarmLiveActivityWidget.swift (93行)
- AlarmKitService.dart (204行)
- 設定画面コンポーネント
- 通知システム統合部分

### 実装時の参考
- [Apple AlarmKit Documentation](https://developer.apple.com/documentation/alarmkit)
- [App Intents Documentation](https://developer.apple.com/documentation/appintents)
- [Critical Alerts Documentation](https://developer.apple.com/documentation/usernotifications/asking_permission_to_use_notifications)
