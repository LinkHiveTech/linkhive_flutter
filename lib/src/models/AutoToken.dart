/// AuthToken model using expiresAt as Unix timestamp (milliseconds)
class AuthToken {
  final String accessToken;
  final DateTime expiresAt;

  AuthToken({required this.accessToken, required this.expiresAt});

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'expiresAt': expiresAt.toUtc().toIso8601String(),
  };

  static AuthToken fromJson(Map<String, dynamic> json) => AuthToken(
    accessToken: json['accessToken'],
    expiresAt: DateTime.parse(json['expiresAt']),
  );
}
