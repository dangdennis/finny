import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:http/http.dart' as http;

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  const SampleItemDetailsView({super.key});

  static const routeName = '/sample_item';

  void _openPlaidLink() {
    LinkConfiguration configuration = LinkTokenConfiguration(
      token: "link-production-5fcef624-992a-4be7-b207-e6bda0ff1e7c",
    );

    PlaidLink.onSuccess.listen((LinkSuccess success) async {
      print("Success: ${success}");
      await _sendPostRequest(success.publicToken);
    });

    PlaidLink.onExit.listen((LinkExit exit) {
      // Handle the exit callback
      print("User exited the Plaid Link flow");
    });

    PlaidLink.onEvent.listen((LinkEvent event) {
      // Handle events (optional)
      print('Event: ${event}');
    });

    PlaidLink.open(configuration: configuration);
  }

  Future<void> _sendPostRequest(String publicToken) async {
    final url =
        Uri.parse('https://finny-backend.fly.dev/api/plaid-items/create');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsImtpZCI6IlFtdEZUekozSEd4T3ZzL1giLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNzIwMTU1Mjk5LCJpYXQiOjE3MjAwNjg4OTksImlzcyI6Imh0dHBzOi8vdHFvbmt4aHJ1Y3ltZHluZHBqemYuc3VwYWJhc2UuY28vYXV0aC92MSIsInN1YiI6IjRjZTRiOTU4LWVhMWUtNDFlNi1iZDZhLWY4YzQzOTIyYTY5OSIsImVtYWlsIjoiZGFuZ2dnZGVubmlzQGdtYWlsLmNvbSIsInBob25lIjoiIiwiYXBwX21ldGFkYXRhIjp7InByb3ZpZGVyIjoiZW1haWwiLCJwcm92aWRlcnMiOlsiZW1haWwiXX0sInVzZXJfbWV0YWRhdGEiOnsiZW1haWwiOiJkYW5nZ2dkZW5uaXNAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJwaG9uZV92ZXJpZmllZCI6ZmFsc2UsInN1YiI6IjRjZTRiOTU4LWVhMWUtNDFlNi1iZDZhLWY4YzQzOTIyYTY5OSJ9LCJyb2xlIjoiYXV0aGVudGljYXRlZCIsImFhbCI6ImFhbDEiLCJhbXIiOlt7Im1ldGhvZCI6Im90cCIsInRpbWVzdGFtcCI6MTcyMDA2ODg5OX1dLCJzZXNzaW9uX2lkIjoiZDRlYzIzMDItZDdlYy00YTcwLThjMDMtMjZiYjYxZmRiZThlIiwiaXNfYW5vbnltb3VzIjpmYWxzZX0.Nqd4vBWccx1T5q928X566m3kj4zXhB2SdZgsBozsFE8'
    };
    final body = json.encode({
      'publicToken': publicToken,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: ElevatedButton(
                  onPressed: _openPlaidLink, child: const Text("Press Me")),
            ),
            const Center(
              child: Column(
                children: [
                  Text('More Information Here'),
                  Text('link-production-5fcef624-992a-4be7-b207-e6bda0ff1e7c')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
