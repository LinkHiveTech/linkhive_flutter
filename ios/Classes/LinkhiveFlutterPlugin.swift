import Flutter
import UIKit

public class LinkhiveFlutterPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.linkhive.deferredlink",
            binaryMessenger: registrar.messenger()
        )
        let instance = LinkhiveFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getLinkShortCode":
            // Read from clipboard
            result(UIPasteboard.general.string ?? "")
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
