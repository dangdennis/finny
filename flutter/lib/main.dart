import 'package:finny/pages/account_page.dart';
import 'package:finny/pages/login_page.dart';
import 'package:finny/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://tqonkxhrucymdyndpjzf.supabase.co',
    debug: true,
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRxb25reGhydWN5bWR5bmRwanpmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTYxNzk4MTAsImV4cCI6MjAzMTc1NTgxMH0.rGtsQPBxLHHatZaBs1JPxsp-E8chFQL11lFHfryKAxc',
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
