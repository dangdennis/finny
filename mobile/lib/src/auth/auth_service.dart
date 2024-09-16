import 'dart:convert';

import 'package:finny/src/powersync/powersync.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:finny/src/context_extension.dart';
import 'package:finny/src/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';

class AuthService {
  AuthService({required this.powersyncDb});

  final Logger _logger = Logger('AuthService');
  final PowerSyncDatabase powersyncDb;
  static const appRedirectUrl = 'com.belmont.finny://login-callback/';
  bool _authListenerInitialized = false;

  Future<void> signInWithEmail(
      String email, Function(String, {bool isError}) showSnackBar) async {
    try {
      await Supabase.instance.client.auth.signInWithOtp(
        email: email.trim(),
        emailRedirectTo: kIsWeb ? null : appRedirectUrl,
      );
      showSnackBar('Check your email for a login link!');
    } on AuthException catch (error) {
      showSnackBar(error.message, isError: true);
    } catch (error) {
      showSnackBar('Unexpected error occurred', isError: true);
    }
  }

  Future<AuthResponse> signInWithApple() async {
    final rawNonce = Supabase.instance.client.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    print('Credential: $credential');

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException(
          'Could not find ID Token from generated credential.');
    }

    print('ID Token: $idToken');

    final res = await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );

    print('Signed in with Apple: $res');

    return res;
  }

  Future<void> signOut() async {
    await PowersyncSupabaseConnector.disconnectAndClearDb();
    await Supabase.instance.client.auth.signOut();
  }

  Future<void> deleteSelf() async {
    final accessToken =
        Supabase.instance.client.auth.currentSession?.accessToken;

    if (accessToken == null) {
      throw Exception('No access token');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.delete(
        AppConfig.usersDeleteUrl,
        headers: headers,
      );
      if (response.statusCode == 200) {
        _logger.info('User deleted');
      } else {
        _logger.warning('Error: ${response.statusCode} ${response.body}');
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      _logger.warning('Exception: $e');
      rethrow;
    }
  }

  Stream<AuthState> get authStateChanges =>
      Supabase.instance.client.auth.onAuthStateChange;

  bool get isLoggedIn =>
      Supabase.instance.client.auth.currentSession?.accessToken != null;

  void initAuthListener(BuildContext context) {
    PowersyncSupabaseConnector? currentConnector;

    if (isLoggedIn) {
      // If the user is already logged in, connect immediately.
      // Otherwise, connect once logged in.
      currentConnector = PowersyncSupabaseConnector(powersyncDb);
      powersyncDb.connect(connector: currentConnector);
    }

    if (_authListenerInitialized) {
      return;
    }

    Supabase.instance.client.auth.onAuthStateChange.listen(
      (data) async {
        final AuthChangeEvent event = data.event;
        if (event == AuthChangeEvent.signedIn) {
          // Connect to PowerSync when the user is signed in
          currentConnector = PowersyncSupabaseConnector(powersyncDb);
          powersyncDb.connect(connector: currentConnector!);
          // Navigator.pushNamed(context, Routes.home);
        } else if (event == AuthChangeEvent.signedOut) {
          // Implicit sign out - disconnect, but don't delete data
          currentConnector = null;
          await powersyncDb.disconnect();
        } else if (event == AuthChangeEvent.tokenRefreshed) {
          // Supabase token refreshed - trigger token refresh for PowerSync.
          currentConnector?.prefetchCredentials();
        }
      },
      onError: (error) {
        if (error is AuthException) {
          if (context.mounted) {
            context.showSnackBar(error.message, isError: true);
          }
        } else {
          if (context.mounted) {
            context.showSnackBar('Unexpected error occurred', isError: true);
          }
        }
      },
    );

    _authListenerInitialized = true;
  }
}
