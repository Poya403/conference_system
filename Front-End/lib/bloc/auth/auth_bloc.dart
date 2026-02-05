import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../data/repositories/auth_repository.dart';
import 'package:conference_system/data/models/auth_response.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthSubmitted>(_onAuthSubmitted);
    on<AuthLogout>(_onAuthLogout);
  }

  Future<void> _onAuthSubmitted(
      AuthSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final AuthResponse response;
      if (event.isLogin) {
        response = await authRepository.login(event.email, event.password);
      } else {
        response = await authRepository.register(
          event.fullName!,
          event.email,
          event.password,
        );
      }

      if (response.success) {
        emit(AuthSuccess(response));
      } else {
        emit(AuthFailure(response.message ?? 'خطای نامشخص'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }


  void _onAuthLogout(AuthLogout event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticated());
  }
}
