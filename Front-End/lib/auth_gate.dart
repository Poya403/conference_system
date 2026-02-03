import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_system/bloc/auth/auth_state.dart';
import 'package:conference_system/bloc/auth/auth_bloc.dart';
import 'package:conference_system/bloc/users/users_bloc.dart';
import 'package:conference_system/bloc/users/users_event.dart';
import 'package:conference_system/features/auth/auth_screen.dart';
import 'package:conference_system/main_wrapper.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthUnauthenticated || state is AuthInitial) {
          return const AuthScreen();
        } else if (state is AuthSuccess) {
          context.read<UsersBloc>().add(
              GetCurrentUser(state.authResponse.userId ?? 1)
          );
          return const MainWrapper(page: PageType.home);
        } else if (state is AuthFailure) {
          return const AuthScreen();
        } else {
          // loading
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
