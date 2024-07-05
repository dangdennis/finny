import 'dart:async';

import 'package:finny/src/context_extension.dart';
import 'package:finny/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';

class AuthController {
  final AuthService authService;
  bool _isLoading = false;
  bool _redirecting = false;
  late final StreamSubscription<AuthState> _authStateSubscription;

  AuthController(this.authService);

  bool get isLoading => _isLoading;

  void dispose() {
    _authStateSubscription.cancel();
  }

  void initAuthListener(BuildContext context) {
    _authStateSubscription = authService.authStateChanges.listen(
      (data) {
        if (_redirecting) return;
        final session = data.session;
        if (session != null) {
          _redirecting = true;
          Navigator.pushNamed(context, Routes.home);
        }
      },
      onError: (error) {
        if (error is AuthException) {
          context.showSnackBar(error.message, isError: true);
        } else {
          context.showSnackBar('Unexpected error occurred', isError: true);
        }
      },
    );
  }

  Future<void> signIn(String email, BuildContext context,
      Function(String, {bool isError}) showSnackBar) async {
    _setLoading(true, context);
    await authService.signInWithOtp(email, showSnackBar);
    if (context.mounted) {
      _setLoading(false, context);
    }
  }

  void _setLoading(bool isLoading, BuildContext context) {
    _isLoading = isLoading;
    (context as Element).markNeedsBuild();
  }
}
