

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lyddipsjdjvcrnaehjbh.supabase.co',
    anonKey: 'sb_publishable_Q8V5bIW4paNlTp8MV2HK7A_rpwJ0JTC',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Esports Manager',
      home: LoginScreen(),
    );
  }
}

