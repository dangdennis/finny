import 'package:finny/src/common/string_utils.dart';
import 'package:finny/src/transactions/transaction.dart';
import 'package:finny/src/transactions/transactions_controller.dart';
import 'package:flutter/material.dart';

import '../routes.dart';
import '../settings/settings_view.dart';

/// Displays a list of SampleItems.
class TransactionListView extends StatefulWidget {
  const TransactionListView({
    super.key,
    required this.transactionsController,
  });

  final TransactionsController transactionsController;
  static const routeName = Routes.transactions;

  @override
  State<TransactionListView> createState() => _TransactionListViewState();
}

class _TransactionListViewState extends State<TransactionListView> {
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    initTransactions();
  }

  void initTransactions() async {
    transactions = await widget.transactionsController.getTransactions();
    setState(() {
      transactions = transactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'transactionListView',
        itemCount: transactions.length,
        itemBuilder: (BuildContext context, int index) {
          final transaction = transactions[index];

          return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                          StringUtils.truncateWithEllipsis(
                              transaction.name, 32),
                          style: const TextStyle(
                            fontSize: 12,
                          )),
                      const Spacer(),
                      Text(
                        '\$${transaction.amount * -1}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    transaction.date,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              leading: const CircleAvatar(
                // Display the Flutter Logo image asset.
                foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
              // onTap: () {
              //   // Navigate to the details page. If the user leaves and returns to
              //   // the app after it has been killed while running in the
              //   // background, the navigation stack is restored.
              //   Navigator.restorablePushNamed(
              //     context,
              //     TransactionDetailsView.routeName,
              //   );
              // }
              );
        },
      ),
    );
  }
}
