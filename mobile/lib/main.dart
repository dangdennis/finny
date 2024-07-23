import 'package:finny/src/auth/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/accounts/accounts_controller.dart';
import 'src/accounts/accounts_service.dart';
import 'src/auth/auth_controller.dart';
import 'src/auth/auth_service.dart';
import 'src/connections/connections_controller.dart';
import 'src/connections/connections_service.dart';
import 'src/powersync/powersync.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'src/transactions/transactions_controller.dart';

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
  final authService = AuthService();
  final connectionsService =
      ConnectionsService(accountsService: accountsService);
  final authProvider = AuthProvider(authService: authService);
  final settingsController = SettingsController(SettingsService(
    authProvider: authProvider,
  ));
  final authController = AuthController(authService);
  final accountsController = AccountsController(AccountsService());
  final transactionsController = TransactionsController();
  final connectionsController = ConnectionsController(connectionsService);

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => authProvider)],
      child: MyApp(
        settingsController: settingsController,
        authController: authController,
        accountsController: accountsController,
        transactionsController: transactionsController,
        connectionsController: connectionsController,
      ),
    ),
  );
}
