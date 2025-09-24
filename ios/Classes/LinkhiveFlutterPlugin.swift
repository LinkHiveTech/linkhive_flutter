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
            result(shortCode) // Only return string
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func fetchDeferredLinkOnce() -> String {
        let pasteboard = UIPasteboard.general
        let defaults = UserDefaults.standard

        // Return cached shortCode if already saved
        if let cached = defaults.string(forKey: "deferredShortCode") {
            return cached
        }

        // Read clipboard
        if let text = pasteboard.string, !text.isEmpty {
            let shortCode = extractShortCode(from: text)
            defaults.set(shortCode, forKey: "deferredShortCode") // save as string
            pasteboard.string = "" // clear clipboard to avoid repeated popup
            return shortCode
        }

        return "" // nothing found
    }

    private func extractShortCode(from text: String) -> String {
        // Case 1: plain shortCode
        if !text.contains("://") {
            return text
        }

        // Try parsing URL
        if let url = URL(string: text) {
            let pathComponents = url.pathComponents.filter { $0 != "/" }
            if !pathComponents.isEmpty {
                // Case 2: https://subdomain.linkhive.tech/shortCode
                return pathComponents.last!
            }

            // Case 3: query parameter ?shortCode=
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
               let queryItems = components.queryItems {
                if let shortCodeItem = queryItems.first(where: { $0.name.lowercased() == "shortcode" }),
                   let value = shortCodeItem.value {
                    return value
                }
            }
        }

        // Fallback: return original text
        return text
    }
}
