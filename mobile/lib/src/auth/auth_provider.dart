import 'dart:async';

import 'package:finny/src/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A provider for managing authentication state and handling sign in and sign out.
class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required this.authService,
  }) {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      checkAuthStatus();
    });
  }

  AuthService authService;

  final Logger _logger = Logger('AuthProvider');
  bool _isLoading = false;
  bool _isLoggedIn = Supabase.instance.client.auth.currentSession != null;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> signInWithEmail(String email, BuildContext context,
      Function(String, {bool isError}) showSnackBar) async {
    _setLoading(true, context);
    await authService.signInWithEmail(email, showSnackBar);
    if (context.mounted) {
      _setLoading(false, context);
    }
  }

  Future<void> signInWithApple(BuildContext context) async {
    try {
      _setLoading(true, context);
      await authService.signInWithApple();
    } catch (e) {
      _logger.severe('Error signing in with Apple', e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to sign in with Apple'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (context.mounted) {
        _setLoading(false, context);
      }
    }
  }

  Future<void> signOut() async {
    _isLoggedIn = false;
    notifyListeners();
    await authService.signOut();
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
