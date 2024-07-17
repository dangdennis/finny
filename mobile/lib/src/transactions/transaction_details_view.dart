import 'package:finny/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:powersync/sqlite3.dart';

import '../powersync/powersync.dart';

/// Displays detailed information about a SampleItem.
class TransactionDetailsView extends StatelessWidget {
  TransactionDetailsView({super.key});

  final Logger _logger = Logger('TransactionDetailsView');
  static const routeName = Routes.transactionDetails;

  /// Get all list IDs
  Future<List<String>> getLists() async {
    ResultSet transactions = await db.getAll('SELECT * FROM transactions;');
    _logger.info("transactions list $transactions");
    return List<String>.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Get all list IDs
                getLists();
              },
              child: const Text('Get Transactions'),
            ),
          ),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  _logger.info("hey");
                },
                child: const Text("Press Me")),
          ),
        ],
      ),
    );
  }
}
