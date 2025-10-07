# LinkHive Flutter Plugin

The `linkhive_flutter` plugin enables Flutter applications to interact with **LinkHive**, a platform for managing and using **dynamic links**. With this plugin, you can create, update, retrieve, and delete dynamic links as well as handle deferred links. To get started, you will need to create an account on **LinkHive Console** and obtain your API credentials (Base URL, Project ID, Client ID).

To use this plugin, follow the steps below:
1. **Create an account**: Go to [LinkHive Console](https://linkhive.tech) and sign up for an account.
2. **Create a new project**: Once logged in, create a new project in the LinkHive Console.
3. **Obtain credentials**: After creating your project, you will receive:
    - `Base URL` for API endpoint
    - `Project ID` (Unique identifier for your project)
    - `Client ID` (Unique identifier for your client)

To use this plugin, add `linkhive_flutter` as a dependency in your `pubspec.yaml` file:
```yaml
dependencies:
   linkhive_flutter: ^1.4.1
  
```
## Example Usage

Once you've set up the plugin and installed the dependencies, you can begin using the `link_hive_flutter` package to interact with LinkHive's dynamic link API.

### Connect to the LinkHive API

Before you can interact with the API, you need to connect by providing your **Base URL**, **Project ID**, and **Client ID** (which can be obtained from the LinkHive Console).

```dart
import 'package:link_hive_flutter/link_hive_flutter.dart';

await LinkHiveClient.instance.connect(
  baseUrl: 'YOUR_BASE_URL_HERE',  // Replace with your LinkHive API base URL
  projectId: 'YOUR_PROJECT_ID_HERE',  // Replace with your project ID
  clientId: 'YOUR_CLIENT_ID_HERE',  // Replace with your client ID
);
```
### Create a Dynamic Link
Now, to create a dynamic link using the LinkHiveClient:
```dart
import 'package:link_hive_flutter/link_hive_flutter.dart';

final request = DynamicLinkRequest(
  platformIds: {
    '123e4567-e89b-12d3-a456-426614174000', // UUIDs as Set
    '987e4567-e89b-12d3-a456-426614174001'
  },
  utm_medium: 'twitter',
);

// Create a new dynamic link via LinkHiveClient
final dynamicLink = await LinkHiveClient.instance.dynamicLinks.create(request);

print('Created dynamic link: ${dynamicLink}'
);
```
### Update a Dynamic Link

```dart
final updatedLink = await LinkHiveClient.instance.dynamicLinks.update(
'linkId',  // Replace with actual link ID
request,
);
print('Updated dynamic link: ${updatedLink}');
```

### Get a Dynamic Link by ID
```dart
final dynamicLinkById = await LinkHiveClient.instance.dynamicLinks.getById('linkId');
print('Fetched dynamic link by ID: ${dynamicLinkById}');
```

### Get a Dynamic Link by Short Code
```dart
final dynamicLinkByShortCode = await LinkHiveClient.instance.dynamicLinks.getByShortCode('shortCode');
print('Fetched dynamic link by short code: ${dynamicLinkByShortCode}');
```

### Delete a Dynamic Link
```dart
await LinkHiveClient.instance.dynamicLinks.delete('linkId');
print('Dynamic link deleted.');
```

### Get Deferred Link (After App Install)
```dart
final deferredLink = await LinkHiveClient.instance.dynamicLinks.getDeferredLink();
if (deferredLink != null) {
print('Deferred link: ${deferredLink}');
} else {
print('No deferred link found');
}
```

### Handle Dynamic Links with `app_links`

```dart
// Get initial dynamic link (cold start)
final initialLink = await LinkHiveClient.instance.dynamicLinks.getInitialLink();
if (initialLink != null) {
  print('Initial dynamic link: ${initialLink}');
} else {
  print('No initial dynamic link found');
}

// Listen for dynamic links while app is running
LinkHiveClient.instance.dynamicLinks.onLinkReceived.listen((link) {
  print('Received dynamic link: $link');
});
```

## Error Handling

The `LinkHiveClient.instance.dynamicLinks` methods throw exceptions on errors:

- **NotFoundException**: Thrown when a resource is not found (404).
- **ApiException**: Thrown for API-related errors with status codes other than 404.
- **NetworkException**: Thrown for general network-related errors.

---
# Android Integration & Domain Verification
## 1. Configure AndroidManifest.xml

Add inside your `<activity>` tag:

```xml
<intent-filter android:autoVerify="true">
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="https" android:host="subdomain.linkhive.tech" />
</intent-filter>
```
Replace your.domain.com with your domain.

> **Important:**  
> Since this plugin uses third-party deep linking libraries (e.g., `app_links`), make sure to add the following inside your `<activity>` tag in `AndroidManifest.xml` to disable Flutter's native deep linking:
>
> ```xml
> <meta-data android:name="flutter_deeplinking_enabled" android:value="false"/>
> ```
>
> This prevents conflicts between native Flutter deep linking and your plugin.

## 2. assetlinks.json

The `assetlinks.json` file is automatically hosted by the LinkHive at: https://subdomain.linkhive.tech/.well-known/assetlinks.json

It contains your app's package name and SHA256 fingerprint to verify domain ownership.

Example content:
```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.example.your_app_package",
      "sha256_cert_fingerprints": ["YOUR_SHA256_CERT_FINGERPRINT"]
    }
  }
]
```
Note: Ensure your app’s package name and SHA256 fingerprint are correctly configured  in LinkHive dashboard.

## 3. Verify Domain Link

To check if your app’s domain verification is successful, run:

```bash
adb shell pm get-app-links com.example.your_app_package
```
Look for a line like:
`
Domain verification state:
your.domain.com: verified
`
If the domain shows verified, your setup is correct.

## 4. Test Deep Link with adb

Use the following command to simulate opening a deep link on your Android device or emulator:

```bash
adb shell am start -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "https://subdomain.linkhive.tech/shortCode"
```

Replace the URL with your actual deep link.
If your app is properly configured, this command will open your app directly to the linked content.

## Notes

- **LinkHive Account**: You must create an account at [LinkHive Console](https://linkhive.tech) to obtain your `baseUrl`, `projectId`, and `clientId`.

- **Dio Setup**: `Dio` is a powerful HTTP client used to make requests to the LinkHive server. Ensure that you have the necessary permissions for network requests on both Android and iOS.

- **Platform-Specific Setup**: Make sure to configure your Android and iOS projects for **universal links** according to the following guides:

   - **iOS Universal Links**: Follow the official [Apple documentation](https://developer.apple.com/documentation/xcode/setting-up-universal-links) to configure universal links for iOS.

   - **Android App Links**: Follow the official [Android documentation](https://developer.android.com/training/app-links) to configure App Links for Android.

  Also, ensure that your Flutter project has the required permissions and settings for deep linking, as outlined in the [Flutter Plugin Documentation](https://flutter.dev/docs/get-started/install).

- **LinkHive Documentation**: For detailed information about LinkHive, check the [LinkHive Docs](https://linkhive-docs.vercel.app/docs/intro).

---





