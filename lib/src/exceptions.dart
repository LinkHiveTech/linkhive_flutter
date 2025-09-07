/// Base class for all LinkHive exceptions
abstract class LinkHiveException implements Exception {
  final String message;
  final Object? cause;

  const LinkHiveException(this.message, {this.cause});

  @override
  String toString() {
    return 'LinkHiveException: $message'
        '${cause != null ? ' (cause: $cause)' : ''}';
  }
}

/// Thrown when a requested resource cannot be found (404).
class NotFoundException extends LinkHiveException {
  const NotFoundException(super.message, {super.cause});
}

/// Thrown when the API returns an error (4xx, 5xx).
class ApiException extends LinkHiveException {
  final int? statusCode;
  final Map<String, dynamic>? details;

  const ApiException(
    super.message, {
    this.statusCode,
    this.details,
    super.cause,
  });

  @override
  String toString() {
    return 'ApiException($statusCode): $message'
        '${details != null ? ' details=$details' : ''}'
        '${cause != null ? ' cause=$cause' : ''}';
  }
}

/// Thrown for network-level issues (timeouts, no internet, DNS errors).
class NetworkException extends LinkHiveException {
  const NetworkException(super.message, {super.cause});
}

/// Thrown when SDK usage is invalid (e.g., bad arguments).
class InvalidRequestException extends LinkHiveException {
  const InvalidRequestException(super.message, {super.cause});
}
