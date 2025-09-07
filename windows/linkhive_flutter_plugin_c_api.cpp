#include "include/linkhive_flutter/linkhive_flutter_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "linkhive_flutter_plugin.h"

void LinkhiveFlutterPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  linkhive_flutter::LinkhiveFlutterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
