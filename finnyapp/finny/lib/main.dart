import 'package:finny/pages/account_page.dart';
import 'package:finny/pages/login_page.dart';
import 'package:finny/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://ogagpskctstoizavqalo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9nYWdwc2tjdHN0b2l6YXZxYWxvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU4MzIzMTYsImV4cCI6MjAzMTQwODMxNn0.RPp3l6grS9iAcWcsfwv_hEw0Wb_7wWQK0W4Q0Ouj-98',
  );
  runApp(const Finny());
}

class Finny extends StatelessWidget {
  const Finny({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finny',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
          ),
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/account': (_) => const AccountPage(),
      },
    );
  }
}
