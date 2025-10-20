import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:linkhive_flutter/src/services/secure_storage_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfoUtils {
  // Generate & persist UUID deviceId securely
  static Future<String> getDeviceId() async {
    return await SecureStorageService.getDeviceId();
  }

  static Future<String> getDeviceModel() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return '${info.manufacturer} ${info.model}';
    } else {
      final info = await deviceInfo.iosInfo;
      return '${info.name} ${info.model}';
    }
  }

  static Future<String> getOsVersion() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return 'Android ${info.version.release}';
    } else {
      final info = await deviceInfo.iosInfo;
      return '${info.systemName} ${info.systemVersion}';
    }
  }

  static Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version}+${packageInfo.buildNumber}';
  }

  static Future<String> getSdkVersion() async {
    return '1.5.0';
  }

  static Future<String> getPlatform() async {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }
}
