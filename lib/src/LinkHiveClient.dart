import 'package:dio/dio.dart';
import 'package:linkhive_flutter/src/services/EventTrackingService.dart';
import 'package:logger/logger.dart';
import 'auth/AuthInterceptor.dart';
import 'auth/TokenManager.dart';
import 'auth/TokenStorage.dart';
import 'exceptions.dart';
import 'models/AutoToken.dart';
import 'services/DynamicLinksService.dart';

class LinkHiveClient {
  static final LinkHiveClient _instance = LinkHiveClient._internal();

  static LinkHiveClient get instance => _instance;

  late final DynamicLinksService dynamicLinks;

  late final EventTrackingService eventTrackingService;

  LinkHiveClient._internal();

  late final Dio _dio;

  bool _connected = false;

  late final Logger _logger;

  late TokenManager _tokenManager;
  final TokenStorage _tokenStorage = TokenStorage();

  Future<void> connect({
    required String baseUrl,
    required String projectId,
    required String clientId,
    bool enableLogging = false,
  }) async {
    if (_connected) return;

    _logger = Logger(level: enableLogging ? Level.debug : Level.off);

    _logger.i('Connecting to $baseUrl with projectId $projectId');

    _dio = Dio(BaseOptions(baseUrl: baseUrl));
    _tokenManager = TokenManager(baseUrl, _tokenStorage, clientId);

    // Add interceptor after TokenManager is initialized
    _dio.interceptors.add(AuthInterceptor(baseUrl, _tokenManager));

    try {
      // Authenticate user
      final response = await _dio.post(
        '/api/users/connect',
        options: Options(headers: {'X-CLIENT-ID': clientId}),
      );

      final data = response.data;
      final token = AuthToken(
        accessToken: data['accessToken'],
        expiresAt: DateTime.parse(data['expiresAt']).toUtc(),
      );

      // Save token securely
      await _tokenStorage.saveToken(token);

      // Initialize token manager
      await _tokenManager.init();

      _logger.i(
        'Authentication succeeded. Access token expires at: ${data['expiresAt']}',
      );

      // Initialize services
      eventTrackingService = EventTrackingService(_dio, _logger);
      dynamicLinks = DynamicLinksService(
        _dio,
        projectId,
        eventTrackingService,
        _logger,
      );

      _connected = true;
    } on DioException catch (e) {
      // Map Dio errors to LinkHiveExceptions
      if (e.response != null) {
        throw ApiException(
          'Authentication failed',
          statusCode: e.response?.statusCode,
          details: e.response?.data,
          cause: e,
        );
      } else {
        throw NetworkException('Connection failed: ${e.message}', cause: e);
      }
    }
  }

  bool get isConnected => _connected;
}
