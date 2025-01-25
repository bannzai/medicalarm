import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var channel: FlutterMethodChannel

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    channel = FlutterMethodChannel(
      name: "method.channel.bannzai.medicalarm",
      binaryMessenger: viewController.binaryMessenger
    )

    channel?.setMethodCallHandler({ call, _completionHandler in
      let completionHandler: (Dictionary<String, Any>) -> Void = {
        _completionHandler($0)
      }

      switch call.method {
        case "requestAppTrackingTransparency":
          requestAppTrackingTransparency(completion: completionHandler)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
