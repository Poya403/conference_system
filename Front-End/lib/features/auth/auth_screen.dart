import 'package:flutter/material.dart';
import 'package:conference_system/utils/app_texts.dart';
import 'package:conference_system/server/services/auth_service.dart';
import 'package:conference_system/widgets/text_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _loading = false;

  Future<void> _handleAuth() async {
    setState(() => _loading = true);

    await authenticate(
      context: context,
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      isLogin: _isLogin,
    );

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Colors.purple,
              width: 2,
            )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 35),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isLogin ? AppTexts.login : AppTexts.signUp,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                const SizedBox(height: 50),
                CustomTextField(
                  controller: _emailController,
                  labelText: AppTexts.email,
                ),
                const SizedBox(height: 35),
                CustomTextField(
                  controller: _passwordController,
                  labelText: AppTexts.password,
                  isPassword: true,
                ),
                const SizedBox(height: 35),
                ElevatedButton(
                  onPressed: _loading ? null : _handleAuth,
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
                  child: Text(_isLogin ? AppTexts.login : AppTexts.signUp),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(
                    _isLogin ? AppTexts.noAccountHint : AppTexts.haveAccountHint,
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
      ),
    );
  }
}
