import 'package:finny/src/common/string_utils.dart';
import 'package:finny/src/routes.dart';
import 'package:finny/src/transactions/transaction_model.dart';
import 'package:finny/src/transactions/transactions_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

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
        centerTitle: true,
        scrolledUnderElevation: 0,
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
          final groupedTransactions = _groupTransactionsByDate(transactions);

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final date = groupedTransactions.keys.elementAt(index);
                      final transactionsForDate = groupedTransactions[date]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _formatDate(date),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...transactionsForDate.map((transaction) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Icon(
                                      _getTransactionIcon(transaction),
                                      color: _getTransactionColor(
                                          transaction, context),
                                      size: 24,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            StringUtils.truncateWithEllipsis(
                                                transaction.name, 32),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          Text(
                                            transaction.date,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '\$${transaction.amount.abs().toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: _getTransactionColor(
                                                transaction, context),
                                          ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      );
                    },
                    childCount: groupedTransactions.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Map<DateTime, List<Transaction>> _groupTransactionsByDate(
      List<Transaction> transactions) {
    final grouped = <DateTime, List<Transaction>>{};
    for (var transaction in transactions) {
      final date = DateTime.parse(transaction.date);
      final dateWithoutTime = DateTime(date.year, date.month, date.day);
      grouped.putIfAbsent(dateWithoutTime, () => []).add(transaction);
    }
    return Map.fromEntries(
        grouped.entries.toList()..sort((a, b) => b.key.compareTo(a.key)));
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM d, y').format(date);
    }
  }

  IconData _getTransactionIcon(Transaction transaction) {
    return transaction.amount < 0
        ? Icons.arrow_circle_left
        : Icons.arrow_circle_right;
  }

  Color _getTransactionColor(Transaction transaction, BuildContext context) {
    return transaction.amount < 0
        ? Colors.green.shade600
        : Theme.of(context).colorScheme.primary;
  }
}
