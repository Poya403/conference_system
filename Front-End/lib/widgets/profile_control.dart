import 'package:conference_system/bloc/auth/auth_event.dart';
import 'package:conference_system/bloc/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/bloc/auth/auth_bloc.dart';

class ProfileControl extends StatelessWidget {
  const ProfileControl({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc,AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                context.read<AuthBloc>().add(AuthLogout());
              },
              icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
              ),
              tooltip: 'خروج',
            ),
          ],
        ),
      ),
    );
  }
}
