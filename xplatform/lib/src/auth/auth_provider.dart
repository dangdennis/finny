import 'dart:async';

import 'package:finny/src/auth/auth_service.dart';
import 'package:finny/src/powersync/powersync.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A provider for app auth state.
class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required this.authService,
  }) {
    initAuthListener();
  }

  AuthService authService;
  final Logger _logger = Logger('AuthProvider');

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  bool _isLoggedIn = Supabase.instance.client.auth.currentSession != null;

  @override
  void dispose() {
    _logger.info("disposing auth provider");
    _authStateChangeSubscription.cancel();
    super.dispose();
  }

  late final StreamSubscription<AuthState> _authStateChangeSubscription;

  void initAuthListener() {
    PowersyncSupabaseConnector? currentConnector;

    if (isLoggedIn) {
      // If the user is already logged in, connect immediately.
      // Otherwise, connect once logged in.
      currentConnector = PowersyncSupabaseConnector(powersyncDb);
      powersyncDb.connect(connector: currentConnector);
    }

    _authStateChangeSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        // Connect to PowerSync when the user is signed in
        currentConnector = PowersyncSupabaseConnector(powersyncDb);
        powersyncDb.connect(connector: currentConnector!);
        _isLoggedIn = true;
        _isLoading = false;
        _logger.info('Signed in');
        notifyListeners();
      } else if (event == AuthChangeEvent.signedOut) {
        // Implicit sign out - disconnect, but don't delete data
        currentConnector = null;
        await powersyncDb.disconnect();
        _isLoggedIn = false;
        _isLoading = false;
        _logger.info('Signed out');
        notifyListeners();
      } else if (event == AuthChangeEvent.tokenRefreshed) {
        // Supabase token refreshed - trigger token refresh for PowerSync.
        currentConnector?.prefetchCredentials();
        _logger.info('Token refreshed');
      } else if (event == AuthChangeEvent.initialSession) {
        _logger.info("Initial session");
      } else if (event == AuthChangeEvent.userUpdated) {
        _logger.info("User updated");
      } else if (event == AuthChangeEvent.passwordRecovery) {
        _logger.info("Password recovery");
      }
    });
  }
}
