import 'dart:async';

import 'package:finny/src/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required this.authService,
  }) {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      checkAuthStatus();
    });
  }

  AuthService authService;
  late final StreamSubscription<AuthState> _authStateSubscription;

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  bool _isLoading = false;
  bool _isLoggedIn = Supabase.instance.client.auth.currentSession != null;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> signIn(String email, BuildContext context,
      Function(String, {bool isError}) showSnackBar) async {
    _setLoading(true, context);
    await authService.signInWithOtp(email, showSnackBar);
    if (context.mounted) {
      _setLoading(false, context);
    }
  }

  Future<void> signOut() async {
    await authService.signOut();
    _isLoggedIn = false;
    notifyListeners();
  }

  void checkAuthStatus() {
    _isLoggedIn = Supabase.instance.client.auth.currentSession != null;
    notifyListeners();
  }

  Future<void> deleteSelf() async {
    await authService.deleteSelf();
    await signOut();
  }

  void initAuthStateListener(BuildContext context) {
    authService.initAuthListener(context);
  }

  void _setLoading(bool isLoading, BuildContext context) {
    _isLoading = isLoading;
    (context as Element).markNeedsBuild();
  }

  
}
