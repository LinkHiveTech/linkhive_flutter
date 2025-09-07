import 'dart:async';

import 'package:dio/dio.dart';

import '../models/AutoToken.dart';
import 'TokenStorage.dart';

class TokenManager {
  final String baseUrl;
  final TokenStorage _storage;
  final String clientId;
  late Dio retryDio;
  AuthToken? _token;

  TokenManager(this.baseUrl, this._storage, this.clientId) {
    retryDio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  Future<void> init() async {
    _token = await _storage.loadToken();
  }

  bool get hasValidToken => _token != null && !_token!.isExpired;

  String? get accessToken => hasValidToken ? _token!.accessToken : null;

  /// Returns a valid token, refreshing it if expired or about to expire
  Future<String?> getValidToken() async {
    if (_token == null ||
        _token!.expiresAt.isBefore(DateTime.now().add(Duration(minutes: 1)))) {
      await refreshToken();
    }
    return _token?.accessToken;
  }

  Future<void> refreshToken() async {
    try {
      final response = await retryDio.post(
        '/api/users/connect',
        options: Options(headers: {'X-CLIENT-ID': clientId}),
      );
      final data = response.data;
      final newToken = AuthToken(
        accessToken: data['accessToken'],
        expiresAt: DateTime.fromMillisecondsSinceEpoch(data['expiresAt']),
      );

      _token = newToken;
      await _storage.saveToken(newToken);
    } on DioException catch (e) {
      print('DioError caught during token refresh: $e');
      // Handle Dio-specific errors (e.g., network issues, timeout, etc.)
    } catch (e) {
      print('General Error caught during token refresh: $e');
      // Handle other errors
    }
  }
}
