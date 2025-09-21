import 'package:app_links/app_links.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import '../Utils.dart';
import '../exceptions.dart';
import '../models/DynamicLink.dart';
import '../models/DynamicLinkRequest.dart';

class DynamicLinksService {
  final Dio _dio;
  final String _projectId;
  static const MethodChannel _channel = MethodChannel(
    'com.linkhive.deferredlink',
  );
  final _appLinks = AppLinks();

  DynamicLinksService(this._dio, this._projectId);

  Future<DynamicLink> create(DynamicLinkRequest request) async {
    try {
      final response = await _dio.post(
        '/api/dynamicLinks/create',
        data: request.toJson(),
        queryParameters: {
          'projectId': _projectId,
          'platformIds': request.platformIds.join(','),
        },
      );
      return DynamicLink.fromJson(response.data);
    } on DioException catch (e) {
      throw _mapDioException(e, 'Failed to create dynamic link');
    }
  }

  Future<DynamicLink> update(String id, DynamicLinkRequest request) async {
    try {
      final response = await _dio.put(
        '/api/dynamicLinks/$_projectId/$id',
        data: request.toJson(),
      );
      return DynamicLink.fromJson(response.data);
    } on DioException catch (e) {
      throw _mapDioException(e, 'Failed to update dynamic link');
    }
  }

  Future<DynamicLink> getById(String id) async {
    try {
      final response = await _dio.get('/api/dynamicLinks/$_projectId/$id');
      return DynamicLink.fromJson(response.data);
    } on DioException catch (e) {
      throw _mapDioException(e, 'Failed to fetch dynamic link by ID');
    }
  }

  Future<DynamicLink> getByShortCode(String shortCode) async {
    try {
      final response = await _dio.get(
        '/api/dynamicLinks/$_projectId/code/$shortCode',
      );
      return DynamicLink.fromJson(response.data);
    } on DioException catch (e) {
      throw _mapDioException(e, 'Failed to fetch dynamic link by short code');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _dio.delete('/api/dynamicLinks/$_projectId/$id');
    } on DioException catch (e) {
      throw _mapDioException(e, 'Failed to delete dynamic link');
    }
  }

  Future<DynamicLink?> getDeferredLink() async {
    try {
      final String? referrer = await _channel.invokeMethod('getLinkShortCode');
      if (referrer == null || referrer.isEmpty) return null;
      return getByShortCode(referrer);
    } on PlatformException catch (e) {
      throw NetworkException('Failed to get deferred link', cause: e);
    }
  }

  /// Handle cold start dynamic link (from app_links)
  Future<DynamicLink?> getInitialLink() async {
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri == null) return null;

      final String? shortCode = Utils.extractShortCode(initialUri);
      if (shortCode == null) return null;

      return await getByShortCode(shortCode);
    } catch (e) {
      throw NetworkException('Failed to get initial dynamic link', cause: e);
    }
  }

  /// Listen for live dynamic links while app is running
  Stream<DynamicLink> get onLinkReceived {
    return _appLinks.uriLinkStream.asyncMap((uri) async {
      final String? shortCode = Utils.extractShortCode(uri);
      if (shortCode == null) {
        throw FormatException('Invalid dynamic link: no shortCode in $uri');
      }
      return await getByShortCode(shortCode);
    });
  }

  Exception _mapDioException(DioException e, String context) {
    final status = e.response?.statusCode;
    if (status == 404) {
      return NotFoundException('$context: resource not found', cause: e);
    }
    if (status != null) {
      return ApiException(
        context,
        statusCode: status,
        details: e.response?.data,
        cause: e,
      );
    }
    return NetworkException('$context: ${e.message}', cause: e);
  }
}
