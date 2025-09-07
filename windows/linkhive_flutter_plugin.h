#ifndef FLUTTER_PLUGIN_LINKHIVE_FLUTTER_PLUGIN_H_
#define FLUTTER_PLUGIN_LINKHIVE_FLUTTER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace linkhive_flutter {

class LinkhiveFlutterPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  LinkhiveFlutterPlugin();

  virtual ~LinkhiveFlutterPlugin();

  // Disallow copy and assign.
  LinkhiveFlutterPlugin(const LinkhiveFlutterPlugin&) = delete;
  LinkhiveFlutterPlugin& operator=(const LinkhiveFlutterPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace linkhive_flutter

#endif  // FLUTTER_PLUGIN_LINKHIVE_FLUTTER_PLUGIN_H_
