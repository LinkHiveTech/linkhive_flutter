import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'linkhive_flutter_method_channel.dart';

abstract class LinkhiveFlutterPlatform extends PlatformInterface {
  /// Constructs a LinkhiveFlutterPlatform.
  LinkhiveFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static LinkhiveFlutterPlatform _instance = MethodChannelLinkhiveFlutter();

  /// The default instance of [LinkhiveFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelLinkhiveFlutter].
  static LinkhiveFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LinkhiveFlutterPlatform] when
  /// they register themselves.
  static set instance(LinkhiveFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
