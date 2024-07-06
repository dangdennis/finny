import 'package:finny/src/accounts/accounts_controller.dart';
import 'package:flutter/material.dart';

import '../routes.dart';
import '../settings/settings_view.dart';
import 'account.dart';
import 'account_details_view.dart';

/// Displays a list of SampleItems.
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
    super.initState();
    initAccounts();
  }

  void initAccounts() async {
    accounts = await widget.accountsController.loadAccounts();
    setState(() {
      accounts = accounts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
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
              onTap: () {
                Navigator.restorablePushNamed(
                  context,
                  AccountDetailsView.routeName,
                );
              });
        },
      ),
    );
  }
}
