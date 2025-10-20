## 1.5.0 - 2025-10-18
### Added
- Structured logging with configurable logger.
- Attribution and analytics event tracking APIs.
- Improved error handling with detailed logging.
- Optional debug logging toggle.

## 1.4.1 - 2025-10-07
### Fixed
- Corrected Android integration documentation:
  - Added reminder to include `<meta-data android:name="flutter_deeplinking_enabled" android:value="false"/>` in `AndroidManifest.xml` when using third-party deep linking plugins.
  - Improved clarity on domain verification and deep link testing steps.
  
## 1.4.0 - 2025-10-07
### Added
- Improved Android deferred deep link support:
  - Native Android implementation to retrieve deferred link short codes.
  - Example Android plugin implementation included.
  - Detailed documentation added for Android integration and domain verification.
  
## 1.3.0 - 2025-09-30
### Added
- Support for App Store campaign tracking parameters in the Flutter SDK:
  - `appStoreProviderToken` (`pt`) — identifies the provider of the link.
  - `appStoreCampaignToken` (`ct`) — campaign tracking token.
  - `appStoreMediaType` (`mt`) — media type identifier (defaults to `"8"`).
  - `appStoreAffiliateToken` (`at`) — affiliate token for tracking/referrals.

## 1.2.3 - 2025-09-30
### Fixed
- Deferred links on Android now work reliably using the Install Referrer API.

## 1.2.2 - 2025-09-29
### Changed
- Refactored token serialization and parsing for clarity and consistency.
- Tokens are now always stored and compared in UTC.
- 
## 1.2.1 - 2025-09-29
### Fixed
- Updated token parsing to correctly handle ISO-8601 UTC `expiresAt` strings from the server.
- Tokens are now consistently stored and compared in UTC.
- Resolved `type 'String' is not a subtype of type 'int'` error during token refresh.

## 1.2.0 – 2025-09-25
### Changed
- iOS deferred link handling updated:
  - Removed native caching; always reads the clipboard fresh.
  - Developers can now decide in Flutter/Dart whether to cache the shortCode.
  - Returns the shortCode as a simple string.
  
## 1.1.1 – 2025-09-24
### Changed
- Improved iOS deferred link handling:
    - Reads clipboard only once per install.
    - Automatically caches the link to prevent repeated popups.
    - Returns the shortCode as a simple string.
## 1.1.0 - 2025-09-21
### Added
- Added integration with [`app_links`](https://pub.dev/packages/app_links) to handle live dynamic link clicks while the app is running.
- Introduced `getInitialLink()` and `onLinkReceived` methods in `DynamicLinksService` to support dynamic link handling during cold start and runtime.
- Utility function `extractShortCode(Uri)` added to handle both short and full dynamic links consistently.

## 1.0.0
- Initial release of the `link_hive_flutter` package.
- Provides functionality for creating, updating, retrieving, and deleting dynamic links.
- Supports deferred deep linking for iOS and Android.
- Easy configuration for universal links on both iOS and Android.
- Integration with LinkHive API to manage dynamic links and short links.
- Handles UTM parameters and social media metadata for dynamic links.
- Built-in support for generating QR codes for dynamic links.
