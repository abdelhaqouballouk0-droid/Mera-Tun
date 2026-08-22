import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private lazy var flutterEngine = FlutterEngine(name: "tryit_engine")
  private var platformChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    flutterEngine.run()
    GeneratedPluginRegistrant.register(with: flutterEngine)
    configurePlatformChannel(binaryMessenger: flutterEngine.binaryMessenger)

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = FlutterViewController(
      engine: flutterEngine,
      nibName: nil,
      bundle: nil
    )
    window?.makeKeyAndVisible()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func configurePlatformChannel(binaryMessenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(
      name: "com.yourcompany.tryit/platform",
      binaryMessenger: binaryMessenger
    )
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "getString":
        guard let key = call.arguments as? String else {
          result(FlutterError(code: "invalid_arguments", message: nil, details: nil))
          return
        }
        result(UserDefaults.standard.string(forKey: key))
      case "setString":
        guard
          let arguments = call.arguments as? [String: Any],
          let key = arguments["key"] as? String,
          let value = arguments["value"] as? String
        else {
          result(FlutterError(code: "invalid_arguments", message: nil, details: nil))
          return
        }
        UserDefaults.standard.set(value, forKey: key)
        result(nil)
      case "remove":
        guard let key = call.arguments as? String else {
          result(FlutterError(code: "invalid_arguments", message: nil, details: nil))
          return
        }
        UserDefaults.standard.removeObject(forKey: key)
        result(nil)
      case "openUrl":
        guard
          let rawUrl = call.arguments as? String,
          let url = URL(string: rawUrl),
          ["https", "mailto"].contains(url.scheme?.lowercased() ?? "")
        else {
          result(false)
          return
        }
        UIApplication.shared.open(url, options: [:]) { success in result(success) }
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    platformChannel = channel
  }
}
