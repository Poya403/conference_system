import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:conference_system/utils/app_texts.dart';

Future<void> authenticate({
  required BuildContext context,
  required String email,
  required String password,
  required bool isLogin,
}) async {
  final supabase = Supabase.instance.client;

  try {
    if (isLogin) {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppTexts.successfulLogin)),
      );
    } else {
      await supabase.auth.signUp(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppTexts.successfulSignUp)),
      );
    }
    Navigator.of(context).pushReplacementNamed('/home');
  } on AuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message)),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppTexts.error)),
    );
  }
}

Future<void> logout(BuildContext context) async {
  try {
    await Supabase.instance.client.auth.signOut();
    Navigator.of(context).pushReplacementNamed('/auth');
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppTexts.error)),
    );
  }
}
