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
