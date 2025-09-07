import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/AutoToken.dart';

/// Secure token storage using flutter_secure_storage
class TokenStorage {
  final _storage = const FlutterSecureStorage();
  static const _key = 'auth_token';

  Future<AuthToken?> loadToken() async {
    final jsonString = await _storage.read(key: _key);
    if (jsonString == null) return null;
    final jsonMap = jsonDecode(jsonString);
    return AuthToken.fromJson(jsonMap);
  }

  Future<void> saveToken(AuthToken token) async {
    await _storage.write(key: _key, value: jsonEncode(token.toJson()));
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _key);
  }
}
