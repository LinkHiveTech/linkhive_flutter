class DynamicLinkRequest {
  final Set<String> platformIds;
  final String? androidFallbackUrl;
  final String? iosFallbackUrl;
  final String? webFallbackUrl;
  final String? utmSource;
  final String? utmMedium;
  final String? utmCampaign;
  final String? utmContent;
  final String? utmTerm;
  final String? appStoreProviderToken; // pt
  final String? appStoreCampaignToken; // ct
  final String? appStoreMediaType; // mt (default "8")
  final String? appStoreAffiliateToken; // at
  final String? socialMediaTitle;
  final String? socialMediaDescription;
  final String? socialMediaImageUrl;
  final bool? skipPreviewPage;
  final bool? generateQrCode;
  final Map<String, dynamic>? linkMetadata;

  DynamicLinkRequest({
    required this.platformIds,
    this.androidFallbackUrl,
    this.iosFallbackUrl,
    this.webFallbackUrl,
    this.utmSource,
    this.utmMedium,
    this.utmCampaign,
    this.utmContent,
    this.utmTerm,
    this.appStoreAffiliateToken,
    this.appStoreCampaignToken,
    this.appStoreMediaType,
    this.appStoreProviderToken,
    this.socialMediaTitle,
    this.socialMediaDescription,
    this.socialMediaImageUrl,
    this.skipPreviewPage,
    this.generateQrCode,
    this.linkMetadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'platforms': platformIds.map((id) => {'id': id}).toList(),
      'androidFallbackUrl': androidFallbackUrl,
      'iosFallbackUrl': iosFallbackUrl,
      'webFallbackUrl': webFallbackUrl,
      'utmSource': utmSource,
      'utmMedium': utmMedium,
      'utmCampaign': utmCampaign,
      'utmContent': utmContent,
      'utmTerm': utmTerm,
      'appStoreAffiliateToken': appStoreAffiliateToken,
      'appStoreProviderToken': appStoreProviderToken,
      'appStoreMediaType': appStoreMediaType,
      'appStoreCampaignToken': appStoreCampaignToken,
      'socialMediaTitle': socialMediaTitle,
      'socialMediaDescription': socialMediaDescription,
      'socialMediaImageUrl': socialMediaImageUrl,
      'skipPreviewPage': socialMediaImageUrl,
      'generateQrCode': generateQrCode,
      'linkMetadata': linkMetadata,
    };
  }
}
