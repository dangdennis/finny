import 'package:finny/src/providers/navigation_provider.dart';
import 'package:finny/src/providers/ynab_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:finny/src/services/auth_service.dart';

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

  await Supabase.initialize(
    url: 'https://tqonkxhrucymdyndpjzf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRxb25reGhydWN5bWR5bmRwanpmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAxNjI3NDIsImV4cCI6MjAzNTczODc0Mn0.sCXfp7mKFSQ0KKeS2MXAY7yRuBnMMr--7Gx4v_YEz1I',
  );

  final navigationProvider = NavigationProvider();
  final ynabProvider = YNABProvider(
    baseUrl: 'https://finny-production.up.railway.app',
  );
  final authService = AuthService(Supabase.instance.client);

  await authService.loginAnonymously();

  if (kReleaseMode) {
    await SentryFlutter.init((options) {
      options.dsn =
          'https://75caf3fc5616317f736eb5b4daa28f57@o4507494754746368.ingest.us.sentry.io/4507692070535168';
    },
        appRunner: () => runApp(
              MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (_) => navigationProvider),
                  ChangeNotifierProvider(create: (_) => ynabProvider),
                ],
                child: FinnyApp(),
              ),
            ));
  } else {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => navigationProvider),
          ChangeNotifierProvider(create: (_) => ynabProvider),
        ],
        child: FinnyApp(),
      ),
    );
  }
}
