import 'dart:async';

// import 'package:finny/src/context_extension.dart';
import 'package:finny/src/powersync.dart' as powersync;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';

class AuthController {
  final AuthService authService;
  bool _isLoading = false;
  late final StreamSubscription<AuthState> _authStateSubscription;

  AuthController(this.authService);

  bool get isLoading => _isLoading;
  bool get isLoggedIn => powersync.isLoggedIn();

  void dispose() {
    _authStateSubscription.cancel();
  }

  void initAuthStateListener(BuildContext context) {
    authService.initAuthListener(context);
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
