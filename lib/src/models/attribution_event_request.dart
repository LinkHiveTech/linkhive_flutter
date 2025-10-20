enum AttributionEventType { INSTALL, FIRST_OPEN, REOPEN, CLICK }

class AttributionEventRequest {
  final AttributionEventType eventType;
  final String platform; // ios / android
  final String deviceId;
  final String deviceModel;
  final String osVersion;
  final String appVersion;
  final String sdkVersion;
  final String? userAgent;
  final String? ipAddress;
  final String dynamicLinkId;

  AttributionEventRequest(
    this.userAgent,
    this.ipAddress, {
    required this.eventType,
    required this.platform,
    required this.deviceId,
    required this.deviceModel,
    required this.osVersion,
    required this.appVersion,
    required this.sdkVersion,
    required this.dynamicLinkId,
  });

  Map<String, dynamic> toJson() => {
    'eventType': eventType.name,
    'platform': platform,
    'deviceId': deviceId,
    'deviceModel': deviceModel,
    'osVersion': osVersion,
    'appVersion': appVersion,
    'sdkVersion': sdkVersion,
    'userAgent': userAgent,
    'ipAddress': ipAddress,
    'dynamicLinkId': dynamicLinkId,
  };
}
