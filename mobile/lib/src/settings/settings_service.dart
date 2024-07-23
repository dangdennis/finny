import 'package:finny/src/app_config.dart';
import 'package:finny/src/auth/auth_provider.dart';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  SettingsService({
    required this.authProvider,
  });

  AuthProvider authProvider;

  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async => ThemeMode.system;

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
  }

  final Logger _logger = Logger('SettingsService');

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
        await authProvider.signOut();
      } else {
        _logger.warning('Error: ${response.statusCode} ${response.body}');
        throw Exception('Failed to delete user');
        // Handle error
      }
    } catch (e) {
      _logger.warning('Exception: $e');
      rethrow;
      // Handle exception
    }
  }
}
