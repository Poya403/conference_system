import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthSubmitted extends AuthEvent {
  final bool isLogin;
  final String email;
  final String password;
  final String? fullName;

  AuthSubmitted({
    required this.isLogin,
    required this.email,
    required this.password,
    this.fullName,
  });

  @override
  List<Object?> get props => [isLogin, email, password, fullName];
}

class CheckAuthToken extends AuthEvent {}
class AuthLogout extends AuthEvent {}
