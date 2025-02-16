import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum YnabAuthStatus {
  authorized,
  unauthorized,
  loading,
}

class YNABProvider extends ChangeNotifier {
  YNABProvider({
    required String baseUrl,
  }) : _baseUrl = baseUrl;

  static final _log = Logger('YNABProvider');
  final String _baseUrl;
  YnabAuthStatus _authStatus = YnabAuthStatus.authorized;
  double? _annualExpenses;

  YnabAuthStatus get authStatus => _authStatus;
  double? get annualExpenses => _annualExpenses;

  Future<void> authorize() async {
    try {
      _authStatus = YnabAuthStatus.loading;
      notifyListeners();

      final authToken =
          Supabase.instance.client.auth.currentSession?.accessToken;
      if (authToken == null) {
        throw Exception('No auth token');
      }

      // Get the authorization URL from your backend
      final response = await http.get(
        Uri.parse('$_baseUrl/oauth/ynab/authorize'),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get auth URL: ${response.body}');
      }

      final data = json.decode(response.body);
      final authUrl = data['url'] as String;

      // Open YNAB authorization page in browser
      if (!await launchUrl(Uri.parse(authUrl),
          mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch YNAB authorization URL');
      }

      // Note: The authorization callback will be handled by your Go backend
      // We'll need to poll to check if authorization was successful
      await _pollAuthStatus();
    } catch (e) {
      _log.severe('Failed to initiate YNAB authorization', e);
      _authStatus = YnabAuthStatus.unauthorized;
      notifyListeners();
    }
  }

  Future<void> _pollAuthStatus() async {
    final authToken = Supabase.instance.client.auth.currentSession?.accessToken;
    if (authToken == null) {
      throw Exception('No auth token');
    }

    // Poll the backend to check if YNAB authorization was successful
    for (var i = 0; i < 60; i++) {
      // Poll for up to 1 minute
      await Future.delayed(const Duration(seconds: 1));

      try {
        final response = await http.get(
          Uri.parse('$_baseUrl/oauth/ynab/status'),
          headers: {'Authorization': 'Bearer $authToken'},
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['authorized'] == true) {
            _authStatus = YnabAuthStatus.authorized;
            notifyListeners();
            await fetchAnnualExpenses();
            return;
          }
        }
      } catch (e) {
        _log.warning('Failed to check YNAB auth status', e);
      }
    }

    // If we get here, authorization timed out
    _authStatus = YnabAuthStatus.unauthorized;
    notifyListeners();
    throw Exception('YNAB authorization timed out');
  }

  Future<void> fetchAnnualExpenses() async {
    if (_authStatus != YnabAuthStatus.authorized) {
      throw Exception('Not authorized with YNAB');
    }

    final authToken = Supabase.instance.client.auth.currentSession?.accessToken;
    if (authToken == null) {
      throw Exception('No auth token');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/expenses/get-expense'),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch YNAB expenses: ${response.body}');
      }

      final data = json.decode(response.body);
      _annualExpenses = data['annual_expenses'] as double;
      notifyListeners();
    } catch (e) {
      _log.severe('Failed to fetch YNAB expenses', e);
      rethrow;
    }
  }

  void reset() {
    _authStatus = YnabAuthStatus.unauthorized;
    _annualExpenses = null;
    notifyListeners();
  }
}
