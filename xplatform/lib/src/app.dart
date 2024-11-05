import 'package:finny/src/accounts/account_details_view.dart';
import 'package:finny/src/accounts/account_list_view.dart';
import 'package:finny/src/accounts/accounts_controller.dart';
import 'package:finny/src/auth/auth_provider.dart';
import 'package:finny/src/auth/auth_service.dart';
import 'package:finny/src/auth/login_view.dart';
import 'package:finny/src/connections/connections_controller.dart';
import 'package:finny/src/connections/connections_list_view.dart';
import 'package:finny/src/finalytics/finalytics_controller.dart';
import 'package:finny/src/goals/goals_controller.dart';
import 'package:finny/src/dashboard/dashboard_view.dart';
import 'package:finny/src/goals/goals_new_form_view.dart';
import 'package:finny/src/onboarding/onboarding_controller.dart';
import 'package:finny/src/settings/settings_controller.dart';
import 'package:finny/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp(
      {super.key,
      required this.authService,
      required this.accountsController,
      required this.connectionsController,
      required this.goalsController,
      required this.settingsController,
      required this.finalyticsController,
      required this.onboardingController});

  final SettingsController settingsController;
  final AccountsController accountsController;
  final ConnectionsController connectionsController;
  final GoalsController goalsController;
  final FinalyticsController finalyticsController;
  final OnboardingController onboardingController;
  final AuthService authService;

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
          home: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.isLoggedIn) {
                return MainView(
                  authService: authService,
                  onboardingController: onboardingController,
                  accountsController: accountsController,
                  connectionsController: connectionsController,
                  goalsController: goalsController,
                  finalyticsController: finalyticsController,
                  settingsController: settingsController,
                );
              } else {
                return LoginView(authService: authService);
              }
            },
          ),

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case AccountListView.routeName:
                    return AccountListView(
                        accountsController: accountsController);
                  case AccountDetailsView.routeName:
                    return AccountDetailsView(
                      connectionsController: connectionsController,
                    );
                  case ConnectionsListView.routeName:
                    return ConnectionsListView(
                      connectionsController: connectionsController,
                    );
                  case DashboardView.routeName:
                    return DashboardView(
                      connectionsController: connectionsController,
                      onboardingController: onboardingController,
                      finalyticsController: finalyticsController,
                      goalsController: goalsController,
                    );
                  case GoalsNewFormView.routeName:
                    return GoalsNewFormView(
                      goalsController: goalsController,
                    );
                  case LoginView.routeName:
                    return LoginView(
                      authService: authService,
                    );
                  case SettingsView.routeName:
                    return SettingsView(
                      authService: authService,
                      settingsController: settingsController,
                    );
                  default:
                    return LoginView(
                      authService: authService,
                    );
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
    required this.accountsController,
    required this.connectionsController,
    required this.goalsController,
    required this.settingsController,
    required this.finalyticsController,
    required this.onboardingController,
    required this.authService,
  });

  final ConnectionsController connectionsController;
  final GoalsController goalsController;
  final SettingsController settingsController;
  final FinalyticsController finalyticsController;
  final OnboardingController onboardingController;
  final AccountsController accountsController;
  final AuthService authService;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      DashboardView(
        connectionsController: widget.connectionsController,
        onboardingController: widget.onboardingController,
        finalyticsController: widget.finalyticsController,
        goalsController: widget.goalsController,
      ),
      AccountListView(
        accountsController: widget.accountsController,
      ),
      SettingsView(
        settingsController: widget.settingsController,
        authService: widget.authService,
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        iconSize: 20.0, // Smaller icon size
        selectedIconTheme: const IconThemeData(size: 20.0),
        unselectedIconTheme: const IconThemeData(size: 20.0),
        selectedLabelStyle: const TextStyle(fontSize: 12.0),
        unselectedLabelStyle: const TextStyle(fontSize: 12.0),
      ),
    );
  }
}
