import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  const SampleItemDetailsView({super.key});

  static const routeName = '/sample_item';

  void _openPlaidLink() {
    LinkConfiguration configuration = LinkTokenConfiguration(
      token: "link-sandbox-6502787a-a144-4308-9256-a823e74d4da4",
    );

    PlaidLink.open(configuration: configuration);
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
                  onPressed: _openPlaidLink,
                  child: const Text("Press Me")),
            ),
            const Center(
              child: Text('More Information Here'),
            ),
          ],
        ),
      ),
    );
  }
}
