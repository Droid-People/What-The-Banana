import Flutter
import UIKit
import CoreMotion

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  let controller = window?.rootViewController as! FlutterViewController
      let methodChannel = FlutterMethodChannel(name: "pedometer/check", binaryMessenger: controller.binaryMessenger)

      methodChannel.setMethodCallHandler { (call, result) in
        if call.method == "isStepCountingAvailable" {
          if CMPedometer.isStepCountingAvailable() {
            result(true)  // 걸음 수 측정 가능
          } else {
            result(false) // 걸음 수 측정 불가
          }
        } else {
          result(FlutterMethodNotImplemented)
        }
      }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
