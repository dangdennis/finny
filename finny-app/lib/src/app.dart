import 'package:finny/src/providers/navigation_provider.dart';
import 'package:finny/src/views/calculator/financial_calculator_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

/// The Widget that configures your application.
class FinnyApp extends StatelessWidget {
  const FinnyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
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
        home: MainView());
  }
}

class MainView extends StatefulWidget {
  const MainView({
    super.key,
  });

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    _widgetOptions = [
      const FinancialCalculatorView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finny',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Consumer<NavigationProvider>(
        builder: (context, navigationProvider, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Find Your FIRE Number'),
              // actions: [
              //   IconButton(
              //     icon: const Icon(Icons.settings),
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => const SettingsView()),
              //       );
              //     },
              //   ),
              // ],
            ),
            body: IndexedStack(
              index: navigationProvider.selectedIndex,
              children: _widgetOptions,
            ),
            // todo: uncomment when we need a bottom nav
            // bottomNavigationBar: BottomNavigationBar(
            //   items: const <BottomNavigationBarItem>[
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.calculate),
            //       label: 'Calculate',
            //     ),
            //   ],
            //   currentIndex: navigationProvider.selectedIndex,
            //   onTap: _onItemTapped,
            // )
          );
        },
      ),
    );
  }
}
