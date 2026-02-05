import 'package:conference_system/services/auth_service.dart';
import 'package:conference_system/data/models/auth_response.dart';

class AuthRepository {
  final AuthService authService = AuthService();

  Future<AuthResponse> login(String email, String password) async {
    return await authService.login(email, password);
  }

  Future<AuthResponse> register(String fullName, String email, String password) async {
    return await authService.register(fullName, email, password);
  }
}
