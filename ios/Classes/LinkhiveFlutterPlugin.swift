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
            let shortCode = fetchDeferredLinkOnce()
            result(shortCode ?? "") // return empty string if nil
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func fetchDeferredLinkOnce() -> String? {
        guard let text = UIPasteboard.general.string, !text.isEmpty else {
            return nil
        }
        return extractShortCode(from: text)
    }

    private func extractShortCode(from text: String) -> String {
        // Case 1: plain shortCode (no scheme)
        if !text.contains("://") {
            return text
        }

        // Try parsing URL
        if let url = URL(string: text) {
            // Case 2: path-based shortCode
            if let last = url.pathComponents.last, !last.isEmpty {
                return last
            }

            // Case 3: query parameter ?shortCode=
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
               let shortCodeItem = components.queryItems?.first(where: { $0.name.lowercased() == "shortcode" }),
               let value = shortCodeItem.value {
                return value
            }
        }

        // Fallback: return original text
        return text
    }
}
