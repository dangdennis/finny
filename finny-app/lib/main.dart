import 'package:finny/src/providers/navigation_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'src/app.dart';

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

  WidgetsFlutterBinding.ensureInitialized();

  final navigationProvider = NavigationProvider();

  if (kReleaseMode) {
    await SentryFlutter.init((options) {
      options.dsn =
          'https://75caf3fc5616317f736eb5b4daa28f57@o4507494754746368.ingest.us.sentry.io/4507692070535168';
    },
        appRunner: () => runApp(
              MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (_) => navigationProvider),
                ],
                child: FinnyApp(),
              ),
            ));
  } else {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => navigationProvider),
        ],
        child: FinnyApp(),
      ),
    );
  }
}
