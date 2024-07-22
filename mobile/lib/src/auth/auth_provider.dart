import 'package:finny/src/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required this.authService,
  });

  AuthService authService;

  bool _isLoggedIn = Supabase.instance.client.auth.currentSession != null;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> signOut() async {
    authService.signOut();
    _isLoggedIn = false;
    notifyListeners();
  }

  void checkAuthStatus() {
    _isLoggedIn = Supabase.instance.client.auth.currentSession != null;
    notifyListeners();
  }
}
