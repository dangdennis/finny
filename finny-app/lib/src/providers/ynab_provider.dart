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
  YnabAuthStatus _authStatus = YnabAuthStatus.unauthorized;
  double? _annualExpenses;

  YnabAuthStatus get authStatus => _authStatus;
  double? get annualExpenses => _annualExpenses;

  Future<void> authorize() async {
    try {
      if (_authStatus == YnabAuthStatus.loading) {
        return;
      }

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
        throw Exception('Failed to get oauth link: ${response.body}');
      }

      final data = json.decode(response.body);
      final authUrl = data['url'] as String;

      // Open YNAB authorization page in browser
      if (!await launchUrl(Uri.parse(authUrl), mode: LaunchMode.inAppWebView)) {
        throw Exception('Could not launch YNAB authorization URL');
      }

      // Poll for authorization status
      bool isAuthorized = false;
      int attempts = 0;
      const maxAttempts = 30; // 30 seconds timeout

      while (!isAuthorized && attempts < maxAttempts) {
        await Future.delayed(const Duration(seconds: 1));
        try {
          await fetchAuthorizationStatus();
          if (_authStatus == YnabAuthStatus.authorized) {
            isAuthorized = true;
            break;
          }
        } catch (e) {
          _log.warning('Authorization status check failed', e);
        }
        attempts++;
      }

      if (!isAuthorized) {
        throw Exception('Authorization timeout');
      } else {
        _authStatus = YnabAuthStatus.authorized;
        notifyListeners();
      }
    } catch (e) {
      _log.severe('Failed to initiate YNAB authorization', e);
      _authStatus = YnabAuthStatus.unauthorized;
      notifyListeners();
    }
  }

  Future<void> fetchExpenseTotal() async {
    if (_authStatus != YnabAuthStatus.authorized) {
      await fetchAuthorizationStatus();
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
      int expense = data['expense'] as int;
      _annualExpenses = expense.toDouble();
      notifyListeners();
    } catch (e) {
      _log.severe('Failed to fetch YNAB expenses', e);
      rethrow;
    }
  }

  Future<void> fetchAuthorizationStatus() async {
    final authToken = Supabase.instance.client.auth.currentSession?.accessToken;
    if (authToken == null) {
      throw Exception('No auth token');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/ynab/auth-status'),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch YNAB expenses: ${response.body}');
      }

      final data = json.decode(response.body);
      _authStatus = (data['connected'] as bool)
          ? YnabAuthStatus.authorized
          : YnabAuthStatus.unauthorized;

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
