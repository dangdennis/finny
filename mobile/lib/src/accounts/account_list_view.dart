import 'package:finny/src/accounts/accounts_controller.dart';
import 'package:finny/src/connections/connections_list_view.dart';
import 'package:flutter/material.dart';

import '../routes.dart';
import 'account.dart';

class AccountListView extends StatefulWidget {
  const AccountListView({
    super.key,
    required this.accountsController,
  });

  static const routeName = Routes.accounts;
  final AccountsController accountsController;

  @override
  State<AccountListView> createState() => _AccountListViewState();
}

class _AccountListViewState extends State<AccountListView> {
  List<Account> accounts = [];

  @override
  void initState() {
    print('AccountListView.initState');
    super.initState();
    initAccounts();
  }

  @override
  void didChangeDependencies() {
    print('AccountListView.didChangeDependencies');
    super.didChangeDependencies();
    initAccounts();
  }

  void initAccounts() async {
    accounts = await widget.accountsController.loadAccounts();
    print('Fetched accounts: $accounts');
    setState(() {
      accounts = accounts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts List'),
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
      body: ListView.builder(
        restorationId: 'accountListView',
        itemCount: accounts.length,
        itemBuilder: (BuildContext context, int index) {
          final account = accounts[index];

          return ListTile(
            title: Text('${account.name} (...${account.mask})'),
            leading: const CircleAvatar(
              foregroundImage: AssetImage('assets/images/flutter_logo.png'),
            ),
            // onTap: () {
            //   Navigator.restorablePushNamed(
            //     context,
            //     AccountDetailsView.routeName,
            //   );
            // }
          );
        },
      ),
    );
  }
}
