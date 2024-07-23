import 'dart:convert';

import 'package:finny/src/app_config.dart';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

class UsersService {
  final Logger _logger = Logger('UsersService');

  Future<void> deleteUser(String userId) async {
    final accessToken =
        Supabase.instance.client.auth.currentSession?.accessToken;

    if (accessToken == null) {
      throw Exception('No access token');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final body = json.encode({
      'userId': userId,
    });

    try {
      final response = await http.delete(
        AppConfig.usersDeleteUrl,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        _logger.info('Success: ${response.body}');
        // Handle success
        // todo: delete db, sign user out, and navigate them to the login screen
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
