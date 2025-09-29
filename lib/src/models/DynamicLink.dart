class DynamicLink {
  final String id;
  final String fullDynamicLink;
  final String shortDynamicLink;
  final String? androidFallbackUrl;
  final String? iosFallbackUrl;
  final String? webFallbackUrl;
  final bool openInApp;
  final String? iosRedirectUrl;
  final String? androidRedirectUrl;
  final String? webRedirectUrl;
  final String? utmSource;
  final String? utmMedium;
  final String? utmCampaign;
  final String? utmContent;
  final String? utmTerm;
  final String? previewUrl;
  final Map<String, dynamic>? linkMetadata;
  final int clickCount;
  final String? qrCodeUrl;
  final DateTime createdAt;

  DynamicLink({
    required this.id,
    required this.fullDynamicLink,
    required this.shortDynamicLink,
    this.androidFallbackUrl,
    this.iosFallbackUrl,
    this.webFallbackUrl,
    this.openInApp = false,
    this.iosRedirectUrl,
    this.androidRedirectUrl,
    this.webRedirectUrl,
    this.utmSource,
    this.utmMedium,
    this.utmCampaign,
    this.utmContent,
    this.utmTerm,
    this.previewUrl,
    this.linkMetadata,
    required this.clickCount,
    this.qrCodeUrl,
    required this.createdAt,
  });

  factory DynamicLink.fromJson(Map<String, dynamic> json) {
    return DynamicLink(
      id: json['id'],
      fullDynamicLink: json['fullDynamicLink'],
      shortDynamicLink: json['shortDynamicLink'],
      androidFallbackUrl: json['androidFallbackUrl'],
      iosFallbackUrl: json['iosFallbackUrl'],
      webFallbackUrl: json['webFallbackUrl'],
      openInApp: json['openInApp'] ?? false,
      iosRedirectUrl: json['iosRedirectUrl'],
      androidRedirectUrl: json['androidRedirectUrl'],
      webRedirectUrl: json['webRedirectUrl'],
      utmSource: json['utmSource'],
      utmMedium: json['utmMedium'],
      utmCampaign: json['utmCampaign'],
      utmContent: json['utmContent'],
      utmTerm: json['utmTerm'],
      previewUrl: json['previewUrl'],
      linkMetadata: json['linkMetadata'] != null
          ? Map<String, dynamic>.from(json['linkMetadata'])
          : null,
      clickCount: json['clickCount'] ?? 0,
      qrCodeUrl: json['qrCodeUrl'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullDynamicLink': fullDynamicLink,
      'shortDynamicLink': shortDynamicLink,
      'androidFallbackUrl': androidFallbackUrl,
      'iosFallbackUrl': iosFallbackUrl,
      'webFallbackUrl': webFallbackUrl,
      'openInApp': openInApp,
      'iosRedirectUrl': iosRedirectUrl,
      'androidRedirectUrl': androidRedirectUrl,
      'webRedirectUrl': webRedirectUrl,
      'utmSource': utmSource,
      'utmMedium': utmMedium,
      'utmCampaign': utmCampaign,
      'utmContent': utmContent,
      'utmTerm': utmTerm,
      'previewUrl': previewUrl,
      'linkMetadata': linkMetadata,
      'clickCount': clickCount,
      'qrCodeUrl': qrCodeUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
