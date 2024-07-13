import 'dart:convert';

import 'package:finny/src/app_config.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

/// Service API to initiate plaid links and manage plaid connections.
class ConnectionsService {
  void openPlaidLink() async {
    print("${Supabase.instance.client.auth.currentSession?.accessToken}");
    // final token = await createPlaidLinkToken();

    // LinkConfiguration configuration = LinkTokenConfiguration(
    //   token: token,
    // );

    // PlaidLink.onSuccess.listen((LinkSuccess success) async {
    //   print("Success: ${success.toJson()}");
    //   await createPlaidItem(success.publicToken);
    // });

    // PlaidLink.onExit.listen((LinkExit exit) {
    //   // Handle the exit callback
    //   print("User exited the Plaid Link flow");
    // });

    // PlaidLink.onEvent.listen((LinkEvent event) {
    //   // Handle events (optional)
    //   print('Event: $event');
    // });

    // PlaidLink.open(configuration: configuration);
  }

  Future<void> createPlaidItem(String publicToken) async {
    final accessToken =
        Supabase.instance.client.auth.currentSession?.accessToken;

    if (accessToken == null) {
      throw Exception('No access token');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ${Supabase.instance.client.auth.currentSession?.accessToken}',
    };

    final body = json.encode({
      'publicToken': publicToken,
    });

    try {
      final response = await http.post(AppConfig.createPlaidItemUrl,
          headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Success: ${response.body}');
        // Handle success
      } else {
        print('Error: ${response.statusCode} ${response.body}');
        // Handle error
      }
    } catch (e) {
      print('Exception: $e');
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
      'Authorization':
          'Bearer ${Supabase.instance.client.auth.currentSession?.accessToken}',
    };

    final response =
        await http.post(AppConfig.createPlaidLinkTokenUrl, headers: headers);
    if (response.statusCode == 200) {
      print('Success: ${response.body}');
      // Handle success

      final data = json.decode(response.body);

      final String token = data['token'];

      return token;
    } else {
      print('Error: ${response.statusCode} ${response.body}');

      throw Exception('Failed to create Plaid Link token');
      // Handle error
    }
  }
}
