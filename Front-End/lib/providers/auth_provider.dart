class AuthProvider {
  static final AuthProvider _instance = AuthProvider._internal();
  factory AuthProvider() => _instance;
  AuthProvider._internal();

  String? jwtToken;

  void setToken(String token) => jwtToken = token;

  void clearToken() => jwtToken = null;

  String get token {
    if(jwtToken == null) throw Exception('User not logged in');
    return jwtToken!;
  }
}

