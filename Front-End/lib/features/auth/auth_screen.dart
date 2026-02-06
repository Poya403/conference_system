import 'package:conference_system/bloc/auth/auth_bloc.dart';
import 'package:conference_system/bloc/auth/auth_event.dart';
import 'package:conference_system/bloc/auth/auth_state.dart';
import 'package:conference_system/bloc/users/users_bloc.dart';
import 'package:conference_system/bloc/users/users_event.dart';
import 'package:conference_system/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/widgets/custom_text_fields/text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final authRepository = AuthRepository();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repaidPasswordController = TextEditingController();
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
            context.read<UsersBloc>().add(
                GetCurrentUser(state.authResponse.userId ?? 0)
            );
          } else if(state is AuthUnauthenticated){
            Navigator.pushReplacementNamed(context, '/auth');
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.purple, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50.0,
                    vertical: 35,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 35,
                    children: [
                      Text(
                        _isLogin ? AppTexts.login : AppTexts.signUp,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      if (!_isLogin) ...[
                        CustomTextField(
                          controller: _fullNameController,
                          labelText: AppTexts.fullName,
                          isPassword: false,
                        ),
                      ],
                      CustomTextField(
                        controller: _emailController,
                        labelText: AppTexts.email,
                      ),
                      CustomTextField(
                        controller: _passwordController,
                        labelText: AppTexts.password,
                        isPassword: true,
                      ),
                      if(!_isLogin)...[
                        CustomTextField(
                          controller: _repaidPasswordController,
                          labelText: AppTexts.repaidPassword,
                          isPassword: true,
                        ),
                      ],
                      ElevatedButton(
                        onPressed: state is AuthLoading ? null : () {
                          if(!_isLogin &&
                              _passwordController.text.trim() != _repaidPasswordController.text){
                            return;
                          }
                          context.read<AuthBloc>().add(
                              AuthSubmitted(
                                  isLogin: _isLogin,
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                  fullName: _isLogin ?
                                    null : _fullNameController.text.trim()
                              )
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          elevation: 0,
                        ),
                        child: Text(
                          _isLogin ? AppTexts.login : AppTexts.signUp,
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _isLogin = !_isLogin),
                        child: Text(
                          _isLogin
                              ? AppTexts.noAccountHint
                              : AppTexts.haveAccountHint,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
