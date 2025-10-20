import 'dart:convert';
import '../models/AutoToken.dart';
import '../services/secure_storage_service.dart';

/// Secure token storage using flutter_secure_storage
class TokenStorage {
  final storage = SecureStorageService();

  Future<AuthToken?> loadToken() async {
    final jsonString = await storage.getAuthToken();
    if (jsonString == null) return null;
    final jsonMap = jsonDecode(jsonString);
    return AuthToken.fromJson(jsonMap);
  }

  Future<void> saveToken(AuthToken token) async {
    await storage.setAuthToken(jsonEncode(token.toJson()));
  }

  Future<void> clearToken() async {
    await storage.deleteAuthToken();
  }
}
