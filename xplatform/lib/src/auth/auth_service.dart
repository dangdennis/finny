import 'dart:convert';

import 'package:finny/src/powersync/powersync.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:finny/src/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';

class AuthService {
  AuthService({required this.powersyncDb});

  final Logger _logger = Logger('AuthService');
  final PowerSyncDatabase powersyncDb;
  static const appRedirectUrl = 'com.belmont.finny://login-callback/';

  Future<void> signInWithEmail(
      String email, Function(String, {bool isError}) showSnackBar) async {
    try {
      await Supabase.instance.client.auth.signInWithOtp(
        email: email.trim(),
        emailRedirectTo: kIsWeb ? null : appRedirectUrl,
      );
      showSnackBar('Check your email for a login link!');
    } on AuthException catch (error) {
      _logger.severe('AuthException: $error');
      showSnackBar("That didn't work. Try again.", isError: true);
    } catch (error) {
      showSnackBar('Something unexpected happened. We\'re on it.',
          isError: true);
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

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException(
          'Could not find ID Token from generated credential.');
    }

    final res = await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );

    return res;
  }

  Future<void> signOut() async {
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

    await PowersyncSupabaseConnector.disconnectAndClearDb();
  }
}
