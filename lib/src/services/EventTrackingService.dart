import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../device_utils_info.dart';
import '../models/attribution_event_request.dart';

class EventTrackingService {
  final Dio _dio;
  final Logger logger;

  EventTrackingService(this._dio, this.logger);

  /// Send Attribution event only (e.g. INSTALL, FIRST_OPEN)
  Future<void> sendAttribution(AttributionEventRequest event) async {
    try {
      await _dio.post('/api/attribution', data: event.toJson());
    } on DioException catch (e) {
      logger.e('Failed to send attribution event', error: e);
    }
  }

  Future<void> createAttributionEventRequest(
    String dynamicLinkId,
    AttributionEventType attributionEventType,
  ) async {
    await sendAttribution(
      AttributionEventRequest(
        null,
        null,
        eventType: attributionEventType,
        platform: await DeviceInfoUtils.getPlatform(),
        deviceId: await DeviceInfoUtils.getDeviceId(),
        deviceModel: await DeviceInfoUtils.getDeviceModel(),
        osVersion: await DeviceInfoUtils.getOsVersion(),
        appVersion: await DeviceInfoUtils.getAppVersion(),
        sdkVersion: await DeviceInfoUtils.getSdkVersion(),
        // or get from pubspec
        dynamicLinkId: dynamicLinkId,
      ),
    );
  }

  /// Send Link Analytics (geo, device context, etc.)
  Future<void> sendAnalytics(String dynamicLinkId) async {
    try {
      await _dio.get('/api/analytics/$dynamicLinkId');
    } on DioException catch (e) {
      logger.e('Failed to send analytics', error: e);
    }
  }
}
