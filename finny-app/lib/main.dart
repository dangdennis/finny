import 'package:finny/src/auth/auth_provider.dart';
import 'package:finny/src/finalytics/finalytics_controller.dart';
import 'package:finny/src/finalytics/finalytics_service.dart';
import 'package:finny/src/goals/goals_controller.dart';
import 'package:finny/src/goals/goals_service.dart';
import 'package:finny/src/onboarding/onboarding_controller.dart';
import 'package:finny/src/profile/profile_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'src/app.dart';
import 'src/accounts/accounts_controller.dart';
import 'src/accounts/accounts_service.dart';
import 'src/auth/auth_service.dart';
import 'src/connections/connections_controller.dart';
import 'src/connections/connections_service.dart';
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

  await PowersyncSupabaseConnector.openDatabaseAndInitSupabase();

  // services
  final accountsService = AccountsService(appDb: appDb);
  final profileService = ProfileService(appDb: appDb);
  final goalsService = GoalsService(
    accountsService: accountsService,
    appDb: appDb,
  );
  final settingsService = SettingsService();

  final authService = AuthService(
    powersyncDb: powersyncDb,
  );
  final connectionsService =
      ConnectionsService(accountsService: accountsService);
  final finalyticsService = FinalyticsService(
    appDb: appDb,
  );

  // providers
  final authProvider = AuthProvider(authService: authService);

  // controllers
  final accountsController = AccountsController(accountsService);
  final connectionsController = ConnectionsController(connectionsService);
  final goalsController = GoalsController(
    accountsService: accountsService,
    goalsService: goalsService,
    profileService: profileService,
  );
  final onboardingController = OnboardingController(
    accountService: accountsService,
    profileService: profileService,
  );
  final settingsController = SettingsController(
    profileService: profileService,
    settingsService: settingsService,
    authProvider: authProvider,
  );
  final finalyticsController =
      FinalyticsController(finalyticsService, profileService);
  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  if (kReleaseMode) {
    await SentryFlutter.init((options) {
      options.dsn =
          'https://75caf3fc5616317f736eb5b4daa28f57@o4507494754746368.ingest.us.sentry.io/4507692070535168';
    },
        appRunner: () => runApp(
              MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (_) => authProvider)
                ],
                child: MyApp(
                  authProvider: authProvider,
                  accountsController: accountsController,
                  connectionsController: connectionsController,
                  finalyticsController: finalyticsController,
                  goalsController: goalsController,
                  onboardingController: onboardingController,
                  settingsController: settingsController,
                ),
              ),
            ));
  } else {
    runApp(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => authProvider)],
        child: MyApp(
          authProvider: authProvider,
          accountsController: accountsController,
          connectionsController: connectionsController,
          finalyticsController: finalyticsController,
          goalsController: goalsController,
          onboardingController: onboardingController,
          settingsController: settingsController,
        ),
      ),
    );
  }
}
