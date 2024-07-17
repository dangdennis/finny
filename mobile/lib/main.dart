import 'package:finny/src/accounts/accounts_controller.dart';
import 'package:finny/src/accounts/accounts_service.dart';
import 'package:finny/src/auth/auth_controller.dart';
import 'package:finny/src/auth/auth_service.dart';
import 'package:finny/src/connections/connections_controller.dart';
import 'package:finny/src/connections/connections_service.dart';
import 'package:finny/src/transactions/transactions_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'src/app.dart';
import 'src/powersync/powersync.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print(
          '[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');

      if (record.error != null) {
        print(record.error);
      }
      if (record.stackTrace != null) {
        print(record.stackTrace);
      }
    }
  });

  WidgetsFlutterBinding
      .ensureInitialized(); //required to get sqlite filepath from path_provider before UI has initialized

  await openDatabaseAndInitSupabase();

  final accountsService = AccountsService();
  final connectionsService =
      ConnectionsService(accountsService: accountsService);
  final settingsController = SettingsController(SettingsService());
  final authController = AuthController(AuthService());
  final accountsController = AccountsController(AccountsService());
  final transactionsController = TransactionsController();
  final connectionsController = ConnectionsController(connectionsService);

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(
    settingsController: settingsController,
    authController: authController,
    accountsController: accountsController,
    transactionsController: transactionsController,
    connectionsController: connectionsController,
    isLoggedIn: authController.isLoggedIn,
  ));
}
