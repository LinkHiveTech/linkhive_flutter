class Utils {
  static String? extractShortCode(Uri uri) {
    if (uri.pathSegments.isNotEmpty && uri.pathSegments.length == 1) {
      return uri.pathSegments.first;
    }

    final deepLinkParam = uri.queryParameters['link'];
    if (deepLinkParam != null && deepLinkParam.isNotEmpty) {
      try {
        final decoded = Uri.decodeFull(deepLinkParam);
        final deepLinkUri = Uri.parse(decoded);
        final code = deepLinkUri.queryParameters['shortCode'];
        if (code != null && code.isNotEmpty) return code;

        if (deepLinkUri.pathSegments.isNotEmpty) {
          return deepLinkUri.pathSegments.last;
        }
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
