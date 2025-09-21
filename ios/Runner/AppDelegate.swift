import Flutter
import UIKit
import AlarmKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var channel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let viewController = window?.rootViewController as! FlutterViewController
    channel = FlutterMethodChannel(
      name: "method.channel.MizukiOhashi.Medicalarm",
      binaryMessenger: viewController.binaryMessenger
    )

    channel?.setMethodCallHandler({ call, _completionHandler in
      let completionHandler: (Dictionary<String, Any>) -> Void = {
        _completionHandler($0)
      }

      switch call.method {
      case "requestAppTrackingTransparency":
        requestAppTrackingTransparency(completion: completionHandler)
      case "isAlarmKitAvailable":
        self.isAlarmKitAvailable(completion: completionHandler)
      case "getAlarmKitAuthorizationStatus":
        self.getAlarmKitAuthorizationStatus(completion: completionHandler)
      case "requestAlarmKitPermission":
        self.requestAlarmKitPermission(completion: completionHandler)
      case "scheduleAlarmKitReminder":
        self.scheduleAlarmKitReminder(call: call, completion: completionHandler)
      case "cancelAllAlarmKitReminders":
        self.cancelAllAlarmKitReminders(completion: completionHandler)
      case "stopAllAlarmKitAlarms":
        self.stopAllAlarmKitAlarms(completion: completionHandler)
      default:
        return
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // MARK: - AlarmKit Methods
  
  private func isAlarmKitAvailable(completion: @escaping (Dictionary<String, Any>) -> Void) {
    let isAvailable = AlarmKitManager.isAlarmKitAvailable()
    completion(["success": true, "data": isAvailable])
  }
  
  private func getAlarmKitAuthorizationStatus(completion: @escaping (Dictionary<String, Any>) -> Void) {
    Task {
      let status = await AlarmKitManager.getAlarmKitAuthorizationStatus()
      DispatchQueue.main.async {
        completion(["success": true, "data": status])
      }
    }
  }
  
  private func requestAlarmKitPermission(completion: @escaping (Dictionary<String, Any>) -> Void) {
    Task {
      let result = await AlarmKitManager.requestAlarmKitPermission()
      DispatchQueue.main.async {
        completion(["success": true, "data": result])
      }
    }
  }
  
  private func scheduleAlarmKitReminder(call: FlutterMethodCall, completion: @escaping (Dictionary<String, Any>) -> Void) {
    guard let args = call.arguments as? [String: Any],
          let identifier = args["identifier"] as? String,
          let title = args["title"] as? String,
          let body = args["body"] as? String,
          let hour = args["hour"] as? Int,
          let minute = args["minute"] as? Int,
          let repeating = args["repeating"] as? Bool,
          let criticalAlert = args["criticalAlert"] as? Bool else {
      completion(["success": false, "error": "Invalid arguments"])
      return
    }
    
    Task {
      let success = await AlarmKitManager.scheduleAlarmKitReminder(
        identifier: identifier,
        title: title,
        body: body,
        hour: hour,
        minute: minute,
        repeating: repeating,
        criticalAlert: criticalAlert
      )
      DispatchQueue.main.async {
        completion(["success": success, "data": success])
      }
    }
  }
  
  private func cancelAllAlarmKitReminders(completion: @escaping (Dictionary<String, Any>) -> Void) {
    Task {
      let success = await AlarmKitManager.cancelAllAlarmKitReminders()
      DispatchQueue.main.async {
        completion(["success": success, "data": success])
      }
    }
  }
  
  private func stopAllAlarmKitAlarms(completion: @escaping (Dictionary<String, Any>) -> Void) {
    Task {
      let success = await AlarmKitManager.stopAllAlarmKitAlarms()
      DispatchQueue.main.async {
        completion(["success": success, "data": success])
      }
    }
  }
}
