class AuthResponse {
  final bool success;
  final String? message;
  final String? token;
  final int? userId;

  AuthResponse({
    required this.success,
    this.message,
    this.token,
    this.userId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'],
      token: json['token'],
      userId: json['user']['id'],
    );
  }

  factory AuthResponse.error(String errorMessage) {
    return AuthResponse(
      success: false,
      message: errorMessage,
    );

  }
}