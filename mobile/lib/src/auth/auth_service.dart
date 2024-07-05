import 'package:finny/src/powersync.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:finny/src/context_extension.dart';

class AuthService {
  bool _authListenerInitialized = false;

  Future<void> signInWithOtp(
      String email, Function(String, {bool isError}) showSnackBar) async {
    try {
      await Supabase.instance.client.auth.signInWithOtp(
        email: email.trim(),
        emailRedirectTo: kIsWeb ? null : 'com.belmont.finny://login-callback/',
      );
      showSnackBar('Check your email for a login link!');
    } on AuthException catch (error) {
      showSnackBar(error.message, isError: true);
    } catch (error) {
      showSnackBar('Unexpected error occurred', isError: true);
    }
  }

  Stream<AuthState> get authStateChanges =>
      Supabase.instance.client.auth.onAuthStateChange;

  bool get isLoggedIn =>
      Supabase.instance.client.auth.currentSession?.accessToken != null;

  void initAuthListener(BuildContext context) {
    SupabaseConnector? currentConnector;

    if (isLoggedIn) {
      // If the user is already logged in, connect immediately.
      // Otherwise, connect once logged in.
      currentConnector = SupabaseConnector(db);
      db.connect(connector: currentConnector);
    }

    if (_authListenerInitialized) {
      return;
    }

    Supabase.instance.client.auth.onAuthStateChange.listen(
      (data) async {
        final AuthChangeEvent event = data.event;
        if (event == AuthChangeEvent.signedIn) {
          // Connect to PowerSync when the user is signed in
          currentConnector = SupabaseConnector(db);
          db.connect(connector: currentConnector!);
          // Navigator.pushNamed(context, Routes.home);
        } else if (event == AuthChangeEvent.signedOut) {
          // Implicit sign out - disconnect, but don't delete data
          currentConnector = null;
          await db.disconnect();
        } else if (event == AuthChangeEvent.tokenRefreshed) {
          // Supabase token refreshed - trigger token refresh for PowerSync.
          currentConnector?.prefetchCredentials();
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

    _authListenerInitialized = true;
  }
}
