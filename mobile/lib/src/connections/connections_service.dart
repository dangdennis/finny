import 'dart:convert';

import 'package:finny/src/accounts/accounts_service.dart';
import 'package:finny/src/app_config.dart';
import 'package:finny/src/connections/plaid_item.dart';
import 'package:finny/src/connections/plaid_items_list_dto.dart';
import 'package:logging/logging.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

/// Service API to initiate plaid links and manage plaid connections.
class ConnectionsService {
  ConnectionsService({required this.accountsService});

  final Logger _logger = Logger('ConnectionsService');
  final AccountsService accountsService;

  Future<void> openPlaidLink() async {
    _logger
        .info("${Supabase.instance.client.auth.currentSession?.accessToken}");

    final token = await createPlaidLinkToken();

    LinkConfiguration configuration = LinkTokenConfiguration(
      token: token,
    );

    PlaidLink.onSuccess.listen((LinkSuccess success) async {
      _logger.info("Success: ${success.toJson()}");
      await createPlaidItem(success.publicToken);
    });

    PlaidLink.onExit.listen((LinkExit exit) {
      // Handle the exit callback
      _logger.info("User exited the Plaid Link flow");
    });

    PlaidLink.onEvent.listen((LinkEvent event) {
      // Handle events (optional)
      _logger.info('Event: $event');
    });

    await PlaidLink.open(configuration: configuration);
  }

  Future<void> createPlaidItem(String publicToken) async {
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
      'publicToken': publicToken,
    });

    try {
      final response = await http.post(AppConfig.plaidItemsCreateUrl,
          headers: headers, body: body);
      if (response.statusCode == 200) {
        _logger.info('Success: ${response.body}');
        // Handle success
      } else {
        _logger.warning('Error: ${response.statusCode} ${response.body}');
        // Handle error
      }
    } catch (e) {
      _logger.warning('Exception: $e');
      // Handle exception
    }
  }

  Future<String> createPlaidLinkToken() async {
    final accessToken =
        Supabase.instance.client.auth.currentSession?.accessToken;

    if (accessToken == null) {
      throw Exception('No access token');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response =
        await http.post(AppConfig.plaidLinksCreateUrl, headers: headers);
    if (response.statusCode == 200) {
      _logger.info('Success: ${response.body}');
      // Handle success

      final data = json.decode(response.body);

      final String token = data['token'];

      return token;
    } else {
      _logger.warning('Error: ${response.statusCode} ${response.body}');

      throw Exception('Failed to create Plaid Link token');
      // Handle error
    }
  }

  Future<List<PlaidItem>> getPlaidItems() async {
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
      var accounts = await accountsService.loadAccounts();
      final response =
          await http.get(AppConfig.plaidItemsListUrl, headers: headers);
      if (response.statusCode == 200) {
        _logger.info('Success: ${response.body}');
        final data = json.decode(response.body) as Map<String, dynamic>;
        final plaidItemListDto = PlaidItemsListDto.fromJson(data);
        for (var item in plaidItemListDto.items) {
          item.accounts =
              accounts.where((account) => account.itemId == item.id).toList();
        }
        return plaidItemListDto.items.map((item) => item.toModel()).toList();
      } else {
        _logger.warning('Error: ${response.statusCode} ${response.body}');
        throw Exception('failed to fetch connections');
      }
    } catch (e) {
      _logger.warning('Exception: $e');
      rethrow;
    }
  }

  Future<void> deletePlaidItem(PlaidItem item) async {
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
      'itemId': item.id,
    });

    try {
      final response = await http.delete(AppConfig.plaidItemsDeleteUrl,
          headers: headers, body: body);
      if (response.statusCode == 200) {
        _logger.info('Success: ${response.body}');
        // Handle success
      } else {
        _logger.warning('Error: ${response.statusCode} ${response.body}');
        throw Exception('Failed to delete connection');
        // Handle error
      }
    } catch (e) {
      _logger.warning('Exception: $e');
      rethrow;
      // Handle exception
    }
  }
}
