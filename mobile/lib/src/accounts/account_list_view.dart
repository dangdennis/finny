import 'package:finny/src/accounts/account_model.dart';
import 'package:finny/src/accounts/accounts_controller.dart';
import 'package:finny/src/connections/connections_list_view.dart';
import 'package:finny/src/routes.dart';
import 'package:finny/src/widgets/gradient_banner.dart';
import 'package:flutter/material.dart';

class AccountListView extends StatelessWidget {
  const AccountListView({
    super.key,
    required this.accountsController,
  });

  static const routeName = Routes.accounts;
  final AccountsController accountsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.restorablePushNamed(
                  context, ConnectionsListView.routeName);
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Account>>(
        stream: accountsController.watchAccounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No accounts available.'));
          }

          final accounts = snapshot.data!;
          final cashAccounts =
              accountsController.filterDepositoryAccounts(accounts);
          final investmentAccounts =
              accountsController.filterInvestmentAccounts(accounts);
          final creditCards =
              accountsController.filterCreditCardAccounts(accounts);
          final loanAccounts = accountsController.filterLoanAccounts(accounts);

          return SingleChildScrollView(
            child: GradientBanner(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AccountsListCard(
                      title: "Cash",
                      accounts: cashAccounts,
                      isLoading:
                          snapshot.connectionState == ConnectionState.waiting,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AccountsListCard(
                      title: "Investments",
                      accounts: investmentAccounts,
                      isLoading:
                          snapshot.connectionState == ConnectionState.waiting,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AccountsListCard(
                      title: "Credit Cards",
                      accounts: creditCards,
                      isLoading:
                          snapshot.connectionState == ConnectionState.waiting,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AccountsListCard(
                      title: "Loans",
                      accounts: loanAccounts,
                      isLoading:
                          snapshot.connectionState == ConnectionState.waiting,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AccountsListCard extends StatelessWidget {
  const AccountsListCard({
    super.key,
    required this.accounts,
    required this.title,
    required this.isLoading,
  });

  final List<Account> accounts;
  final String title;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            const SizedBox(height: 8),
            isLoading
                ? const Column(
                    children: [
                      SkeletonListTile(),
                      SkeletonListTile(),
                      SkeletonListTile(),
                    ],
                  )
                : Column(
                    children: accounts.map((account) {
                      return ListTile(
                        contentPadding: const EdgeInsets.only(
                            top: 2.0, left: 8.0, right: 8.0),
                        title: Text('${account.name} (...${account.mask})'),
                        subtitle: account.officialName != null
                            ? Text(account.officialName!)
                            : null,
                        leading: const CircleAvatar(
                          foregroundImage:
                              AssetImage('assets/images/flutter_logo.png'),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}

class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 4),
                Container(
                  width: 150,
                  height: 10,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
