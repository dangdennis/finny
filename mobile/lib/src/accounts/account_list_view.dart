import 'package:flutter/material.dart';

import '../routes.dart';
import '../settings/settings_view.dart';
import 'account.dart';
import 'account_details_view.dart';

/// Displays a list of SampleItems.
class AccountListView extends StatelessWidget {
  const AccountListView({
    super.key,
    this.items = const [
      Account(
        id: '1',
        itemId: '1',
        userId: '1',
        plaidAccountId: '1',
        name: 'Checking',
        mask: '0000',
        officialName: 'Checking',
        currentBalance: 100.0,
        availableBalance: 100.0,
        isoCurrencyCode: 'USD',
        unofficialCurrencyCode: 'USD',
        type: 'depository',
        subtype: 'checking',
        createdAt: '2021-06-01T00:00:00Z',
        updatedAt: '2021-06-01T00:00:00Z',
        deletedAt: null,
      ),
    ],
  });

  static const routeName = Routes.accounts;

  final List<Account> items;

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
        restorationId: 'accountListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ListTile(
              title: Text('SampleItem ${item.id}'),
              leading: const CircleAvatar(
                // Display the Flutter Logo image asset.
                foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
              onTap: () {
                // Navigate to the details page. If the user leaves and returns to
                // the app after it has been killed while running in the
                // background, the navigation stack is restored.
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
