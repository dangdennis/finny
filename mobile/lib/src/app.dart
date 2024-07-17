import 'package:finny/src/accounts/accounts_controller.dart';
import 'package:finny/src/auth/auth_controller.dart';
import 'package:finny/src/auth/login_view.dart';
import 'package:finny/src/connections/connections_controller.dart';
import 'package:finny/src/connections/connections_list_view.dart';
import 'package:finny/src/transactions/transaction_details_view.dart';
import 'package:finny/src/transactions/transaction_list_view.dart';
import 'package:finny/src/transactions/transactions_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'accounts/account_details_view.dart';
import 'accounts/account_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
    required this.authController,
    required this.accountsController,
    required this.transactionsController,
    required this.connectionsController,
    required this.isLoggedIn,
  });

  final SettingsController settingsController;
  final AuthController authController;
  final AccountsController accountsController;
  final TransactionsController transactionsController;
  final ConnectionsController connectionsController;
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            // AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          // onGenerateTitle: (BuildContext context) =>
          //     AppLocalizations.of(context)!.appTitle,

          title: "Finny",

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          home: isLoggedIn
              ? MainView(
                  accountsController: accountsController,
                  authController: authController,
                  settingsController: settingsController,
                  transactionsController: transactionsController,
                )
              : LoginView(authController: authController),

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case LoginView.routeName:
                    return LoginView(
                      authController: authController,
                    );
                  case SettingsView.routeName:
                    return SettingsView(settingsController: settingsController);
                  case AccountListView.routeName:
                    return AccountListView(
                        accountsController: accountsController);
                  case AccountDetailsView.routeName:
                    return AccountDetailsView(
                      connectionsController: connectionsController,
                    );
                  case TransactionListView.routeName:
                    return TransactionListView(
                      transactionsController: transactionsController,
                    );
                  case TransactionDetailsView.routeName:
                    return TransactionDetailsView();
                  case ConnectionsListView.routeName:
                    return ConnectionsListView(
                      connectionsController: connectionsController,
                    );
                  default:
                    return LoginView(authController: authController);
                }
              },
            );
          },
        );
      },
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({
    super.key,
    required this.authController,
    required this.settingsController,
    required this.accountsController,
    required this.transactionsController,
  });

  final AuthController authController;
  final SettingsController settingsController;
  final AccountsController accountsController;
  final TransactionsController transactionsController;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      AccountListView(
        accountsController: widget.accountsController,
      ),
      TransactionListView(
        transactionsController: widget.transactionsController,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
          // Add other BottomNavigationBarItem as needed
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
