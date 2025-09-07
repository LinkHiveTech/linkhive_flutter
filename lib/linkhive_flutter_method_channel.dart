import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'linkhive_flutter_platform_interface.dart';

/// An implementation of [LinkhiveFlutterPlatform] that uses method channels.
class MethodChannelLinkhiveFlutter extends LinkhiveFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('linkhive_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
