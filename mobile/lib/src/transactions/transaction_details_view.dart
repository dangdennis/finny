import 'package:finny/src/routes.dart';
import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class TransactionDetailsView extends StatelessWidget {
  const TransactionDetailsView({super.key});

  static const routeName = Routes.transactionDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}
