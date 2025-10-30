import 'package:flutter/material.dart';
import 'package:conference_system/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ktaludfxeaqgrdsbunwc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt0YWx1ZGZ4ZWFxZ3Jkc2J1bndjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE1NTg4MzUsImV4cCI6MjA3NzEzNDgzNX0.HSasX0BiEVhszDuPop7ujfoSlriEPOUYdE6Jk_h3Y7o',
  );

  runApp(const MyApp());
}

