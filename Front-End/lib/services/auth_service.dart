import 'dart:convert';
import 'package:conference_system/data/models/auth_response.dart';
import 'package:http/http.dart' as http;
import 'package:conference_system/config/api_config.dart';

class AuthService {
  Future<AuthResponse> login(String email, String password) async {
    final url = GetUri.login;

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AuthResponse.fromJson(data);
    } else {
      return AuthResponse.error("ورود ناموفق");
    }
  }

  Future<AuthResponse> register(String fullName, String email, String password, {String? phone}) async {
    final url = GetUri.register;

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "fullName": fullName,
        "email": email,
        "password": password,
        "phone": phone,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AuthResponse.fromJson(data);
    } else {
      return AuthResponse.error("ثبت نام ناموفق");
    }
  }
}
