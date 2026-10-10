import Flutter
import UIKit
import AlarmKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var channel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // UIScene ライフサイクル (Info.plist の UIApplicationSceneManifest) では didFinishLaunchingWithOptions の時点で
  // window.rootViewController の FlutterViewController がまだ無いため、プラグインの登録と MethodChannel の作成は
  // 暗黙の FlutterEngine が初期化された後のこのコールバックで行う (https://docs.flutter.dev/to/uiscene-migration)。
  // iOS 27 SDK (Xcode 27) でビルドしたアプリは UIScene を採用しないと起動時にクラッシュする (#370)
  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    channel = FlutterMethodChannel(
      name: "method.channel.bannzai.Medicalarm",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )

    channel?.setMethodCallHandler({ call, _completionHandler in
      let completionHandler: (Dictionary<String, Any>) -> Void = {
        _completionHandler($0)
      }

      switch call.method {
      case "requestAppTrackingTransparency":
        requestAppTrackingTransparency(completion: completionHandler)
      case "isAlarmKitAvailable":
        completionHandler([
          "result": "success",
          "isAlarmKitAvailable": AlarmKitManager.shared.isAvailableForCurrentOS()
        ])
      case "getAlarmKitAuthorizationStatus":
        let authStatus = AlarmKitManager.shared.getAuthorizationStatus()
        completionHandler([
          "result": "success",
          "authorizationStatus": authStatus
        ])
      case "requestAlarmKitPermission":
        if #available(iOS 26.0, *) {
          Task {
            let authorized = await AlarmKitManager.shared.requestPermission()
            await MainActor.run {
              completionHandler([
                "result": "success",
                "authorized": authorized
              ])
            }
          }
        } else {
          completionHandler([
            "result": "failure",
            "message": "AlarmKit is not available on this OS version"
          ])
        }
      case "scheduleAlarmKitReminder":
        if let arguments = call.arguments as? [String: Any],
           let localNotificationID = arguments["localNotificationID"] as? String,
           let title = arguments["title"] as? String,
           let scheduledTimeMs = arguments["scheduledTimeMs"] as? NSNumber {

          if #available(iOS 26.0, *) {
            let scheduledTime = dartTypeDate(nsNumber: scheduledTimeMs)
            Task {
              do {
                try await AlarmKitManager.shared.scheduleMedicationAlarm(
                  localNotificationID: localNotificationID,
                  title: title,
                  scheduledTime: scheduledTime
                )
                await MainActor.run {
                  completionHandler(["result": "success"])
                }
              } catch {
                await MainActor.run {
                  completionHandler([
                    "result": "failure",
                    "message": error.localizedDescription
                  ])
                }
              }
            }
          } else {
            completionHandler([
              "result": "failure",
              "message": "AlarmKit is not available on this OS version"
            ])
          }
        } else {
          completionHandler([
            "result": "failure",
            "message": "Invalid arguments for scheduleAlarmKitReminder"
          ])
        }
      case "cancelAllAlarmKitReminders":
        if #available(iOS 26.0, *) {
          Task {
            do {
              try await AlarmKitManager.shared.cancelAllMedicationAlarms()
              await MainActor.run {
                completionHandler(["result": "success"])
              }
            } catch {
              await MainActor.run {
                completionHandler([
                  "result": "failure",
                  "message": error.localizedDescription
                ])
              }
            }
          }
        } else {
          completionHandler([
            "result": "failure",
            "message": "AlarmKit is not available on this OS version"
          ])
        }
      case "stopAllAlarmKitAlarms":
        if #available(iOS 26.0, *) {
          Task {
            do {
              try await AlarmKitManager.shared.stopAllAlarms()
              await MainActor.run {
                completionHandler(["result": "success"])
              }
            } catch {
              await MainActor.run {
                completionHandler([
                  "result": "failure",
                  "message": error.localizedDescription
                ])
              }
            }
          }
        } else {
          completionHandler([
            "result": "failure",
            "message": "AlarmKit is not available on this OS version"
          ])
        }
      default:
        return
      }
    })
  }
}

// Dartの日付のタイムスタンプはmillisecondsで渡ってくる。それをSwiftのDate型にマッピングする
func dartTypeDate(nsNumber: NSNumber) -> Date {
  Date(timeIntervalSince1970: nsNumber.doubleValue / 1000)
}
