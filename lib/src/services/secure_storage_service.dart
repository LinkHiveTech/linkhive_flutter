import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();

  factory SecureStorageService() => _instance;

  SecureStorageService._internal();

  // FlutterSecureStorage instance with consistent iOS options
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    iOptions: IOSOptions(synchronizable: false),
  );

  static const String _authTokenKey = 'auth_token';
  static const String _deviceIdKey = 'device_unique_id';

  // Read auth token
  Future<String?> getAuthToken() async {
    return _storage.read(key: _authTokenKey);
  }

  // Write auth token
  Future<void> setAuthToken(String token) async {
    await _storage.write(key: _authTokenKey, value: token);
  }

  // Delete auth token
  Future<void> deleteAuthToken() async {
    await _storage.delete(key: _authTokenKey);
  }

  static Future<String> getDeviceId() async {
    return await _instance._getDeviceId();
  }

  // Generate and persist unique device ID
  Future<String> _getDeviceId() async {
    String? deviceId = await _storage.read(key: _deviceIdKey);

    if (deviceId == null) {
      deviceId = const Uuid().v4();

      // Delete first (optional safety)
      await _storage.delete(key: _deviceIdKey);
      await _storage.write(key: _deviceIdKey, value: deviceId);
    }
    return deviceId;
  }

  // Clear all secure storage (for testing)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
