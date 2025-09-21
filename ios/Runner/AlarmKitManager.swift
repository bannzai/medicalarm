import Foundation
import AlarmKit
import UserNotifications

@available(iOS 18.0, *)
class AlarmKitManager: NSObject {
    
    // AlarmKitが利用可能かどうかを確認
    static func isAlarmKitAvailable() -> Bool {
        if #available(iOS 18.0, *) {
            return true
        } else {
            return false
        }
    }
    
    // AlarmKitの認証状態を取得
    static func getAlarmKitAuthorizationStatus() async -> String {
        guard #available(iOS 18.0, *) else {
            return "unavailable"
        }
        
        let status = await ALAlarmManager.authorizationStatus()
        switch status {
        case .notDetermined:
            return "notDetermined"
        case .denied:
            return "denied"
        case .authorized:
            return "authorized"
        @unknown default:
            return "unknown"
        }
    }
    
    // AlarmKitの使用許可をリクエスト
    static func requestAlarmKitPermission() async -> String {
        guard #available(iOS 18.0, *) else {
            return "unavailable"
        }
        
        do {
            let granted = try await ALAlarmManager.requestAuthorization()
            return granted ? "authorized" : "denied"
        } catch {
            print("AlarmKit authorization request failed: \(error)")
            return "denied"
        }
    }
    
    // AlarmKitでアラームをスケジュール
    static func scheduleAlarmKitReminder(
        identifier: String,
        title: String,
        body: String,
        hour: Int,
        minute: Int,
        repeating: Bool,
        criticalAlert: Bool
    ) async -> Bool {
        guard #available(iOS 18.0, *) else {
            return false
        }
        
        // 認証状態を確認
        let authStatus = await ALAlarmManager.authorizationStatus()
        guard authStatus == .authorized else {
            print("AlarmKit not authorized")
            return false
        }
        
        do {
            // アラーム時刻を設定
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            // アラームの詳細設定
            let sound: ALAlarmSound
            if criticalAlert {
                // Critical Alertの場合はシステムデフォルトの音量で
                sound = .default
            } else {
                sound = .default
            }
            
            // アラームを作成
            let alarm = ALAlarm(
                dateComponents: dateComponents,
                title: title,
                isEnabled: true,
                repeating: repeating,
                sound: sound
            )
            
            // アラームをスケジュール
            try await ALAlarmManager.shared.save(alarm)
            
            print("AlarmKit reminder scheduled successfully: \(identifier)")
            return true
            
        } catch {
            print("Failed to schedule AlarmKit reminder: \(error)")
            return false
        }
    }
    
    // 全てのAlarmKitアラームをキャンセル
    static func cancelAllAlarmKitReminders() async -> Bool {
        guard #available(iOS 18.0, *) else {
            return false
        }
        
        do {
            let alarms = try await ALAlarmManager.shared.alarms()
            
            for alarm in alarms {
                try await ALAlarmManager.shared.remove(alarm)
            }
            
            print("All AlarmKit reminders cancelled successfully")
            return true
            
        } catch {
            print("Failed to cancel AlarmKit reminders: \(error)")
            return false
        }
    }
    
    // 全てのAlarmKitアラームを停止
    static func stopAllAlarmKitAlarms() async -> Bool {
        guard #available(iOS 18.0, *) else {
            return false
        }
        
        do {
            let alarms = try await ALAlarmManager.shared.alarms()
            
            for alarm in alarms {
                if alarm.isEnabled {
                    let disabledAlarm = ALAlarm(
                        dateComponents: alarm.dateComponents,
                        title: alarm.title,
                        isEnabled: false,
                        repeating: alarm.repeating,
                        sound: alarm.sound
                    )
                    try await ALAlarmManager.shared.save(disabledAlarm)
                }
            }
            
            print("All AlarmKit alarms stopped successfully")
            return true
            
        } catch {
            print("Failed to stop AlarmKit alarms: \(error)")
            return false
        }
    }
    
    // 特定のアラームを取得
    static func getScheduledAlarms() async -> [[String: Any]] {
        guard #available(iOS 18.0, *) else {
            return []
        }
        
        do {
            let alarms = try await ALAlarmManager.shared.alarms()
            var result: [[String: Any]] = []
            
            for alarm in alarms {
                let alarmDict: [String: Any] = [
                    "id": alarm.identifier?.uuidString ?? "",
                    "title": alarm.title,
                    "hour": alarm.dateComponents.hour ?? 0,
                    "minute": alarm.dateComponents.minute ?? 0,
                    "isEnabled": alarm.isEnabled,
                    "repeating": alarm.repeating
                ]
                result.append(alarmDict)
            }
            
            return result
            
        } catch {
            print("Failed to get scheduled alarms: \(error)")
            return []
        }
    }
}