import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:conference_system/features/auth/auth_screen.dart';
import 'package:conference_system/main_wrapper.dart';
import 'package:conference_system/features/profile_panel/profile_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/auth': (_) => const AuthScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/home': (_) => const MainWrapper(page: PageType.home),
        '/halls': (_) => const MainWrapper(page: PageType.halls),
        '/courses': (_) => const MainWrapper(page: PageType.courses),
        '/aboutUs': (_) => const MainWrapper(page: PageType.aboutUs),
      },
      initialRoute: session == null ? '/auth' : '/home',
    );
  }
}

