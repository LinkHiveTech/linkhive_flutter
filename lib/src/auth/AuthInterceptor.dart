import 'package:dio/dio.dart';

import 'TokenManager.dart';

class AuthInterceptor extends Interceptor {
  final String baseUrl;
  Future<String?>? _refreshTokenFuture;
  final TokenManager tokenStorage; // a class that reads/writes tokens
  late Dio retryDio;

  AuthInterceptor(this.baseUrl, this.tokenStorage) {
    retryDio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await tokenStorage.getValidToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_isUnauthorized(err) && _shouldRefresh(err.requestOptions)) {
      // Attempt refresh if not already happening
      _refreshTokenFuture ??= _refreshAccessToken();

      final newToken = await _refreshTokenFuture;
      if (newToken != null) {
        // Retry the original request
        final clonedRequest = _retryRequest(err.requestOptions, newToken);
        try {
          final response = await retryDio.fetch(clonedRequest);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(e as DioException);
        }
      }
      // If refresh fails, newToken == null => pass the 401 up
    }
    return handler.next(err);
  }

  bool _isUnauthorized(DioException err) {
    return err.response?.statusCode == 401;
  }

  bool _shouldRefresh(RequestOptions requestOptions) {
    // Avoid refreshing again if it's the refresh token call
    return requestOptions.path.contains('/connect');
  }

  RequestOptions _retryRequest(RequestOptions requestOptions, String newToken) {
    final newHeaders = Map<String, dynamic>.from(requestOptions.headers);
    newHeaders['Authorization'] = 'Bearer $newToken';
    return requestOptions.copyWith(headers: newHeaders);
  }

  Future<String?> _refreshAccessToken() async {
    try {
      await tokenStorage.refreshToken();
      return tokenStorage.accessToken;
    } catch (e) {
      return null;
    } finally {
      _refreshTokenFuture = null;
    }
  }
}
