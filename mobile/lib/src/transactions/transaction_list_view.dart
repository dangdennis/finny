import 'package:finny/src/common/string_utils.dart';
import 'package:finny/src/routes.dart';
import 'package:finny/src/transactions/transaction_model.dart';
import 'package:finny/src/transactions/transactions_controller.dart';
import 'package:flutter/material.dart';

class TransactionListView extends StatelessWidget {
  const TransactionListView({
    super.key,
    required this.transactionsController,
  });

  final TransactionsController transactionsController;
  static const routeName = Routes.transactions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: StreamBuilder<List<Transaction>>(
        stream: transactionsController.watchTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for data
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Handle any errors
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Handle the case where no data is available
            return const Center(child: Text('No transactions available.'));
          }

          // Data is available
          final transactions = snapshot.data!;

          return ListView.builder(
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
                          ),
                        ),
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
                leading: const Icon(Icons.payment, color: Colors.blueAccent),
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
          );
        },
      ),
    );
  }
}
