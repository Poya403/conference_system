import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:conference_system/features/auth/auth_screen.dart';
import 'package:conference_system/main_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (_) => const MainAppScreen(),
        '/auth': (_) => const AuthScreen(),
      },

      home: session == null ? const AuthScreen() : const MainAppScreen(),
    );
  }
}

