// This file performs setup of the PowerSync database
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_config.dart';
import './schema.dart';
import '../supabase.dart';

final logger = Logger('powersync-supabase');

/// Use Supabase for authentication.
/// Uses API for data updates.
class SupabaseConnector extends PowerSyncBackendConnector {
  PowerSyncDatabase db;

  Future<void>? _refreshFuture;

  SupabaseConnector(this.db);

  /// Get a Supabase token to authenticate against the PowerSync instance.
  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    // Wait for pending session refresh if any
    await _refreshFuture;

    // Use Supabase token for PowerSync
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      // Not logged in
      return null;
    }

    // Use the access token to authenticate against PowerSync
    final token = session.accessToken;

    // userId and expiresAt are for debugging purposes only
    final userId = session.user.id;
    final expiresAt = session.expiresAt == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000);
    return PowerSyncCredentials(
        endpoint: AppConfig.powersyncUrl,
        token: token,
        userId: userId,
        expiresAt: expiresAt);
  }

  @override
  void invalidateCredentials() {
    // Trigger a session refresh if auth fails on PowerSync.
    // Generally, sessions should be refreshed automatically by Supabase.
    // However, in some cases it can be a while before the session refresh is
    // retried. We attempt to trigger the refresh as soon as we get an auth
    // failure on PowerSync.
    //
    // This could happen if the device was offline for a while and the session
    // expired, and nothing else attempt to use the session it in the meantime.
    //
    // Timeout the refresh call to avoid waiting for long retries,
    // and ignore any errors. Errors will surface as expired tokens.
    _refreshFuture = Supabase.instance.client.auth
        .refreshSession()
        .timeout(const Duration(seconds: 5))
        .then((response) => null, onError: (error) => null);
  }

  // Upload pending changes to Supabase.
  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    // This function is called whenever there is data to upload, whether the
    // device is online or offline.
    // If this call throws an error, it is retried periodically.
    final transaction = await database.getNextCrudTransaction();
    if (transaction == null) {
      return;
    }

    CrudEntry? lastOp;
    try {
      // Note: If transactional consistency is important, use database functions
      // or edge functions to process the entire transaction in a single call.

      // todo: make API request to API, send op as JSON.
      for (var op in transaction.crud) {
        lastOp = op;
        if (op.op == UpdateType.put) {
          logger.info('put $op');
        } else if (op.op == UpdateType.patch) {
          logger.info('patch $op');
        } else if (op.op == UpdateType.delete) {
          logger.info('delete $op');
        }
      }

      // All operations successful.
      await transaction.complete();
    } on ApiException catch (e) {
      if (e.code != null) {
        /// Instead of blocking the queue with these errors,
        /// discard the (rest of the) transaction.
        ///
        /// Note that these errors typically indicate a bug in the application.
        /// If protecting against data loss is important, save the failing records
        /// elsewhere instead of discarding, and/or notify the user.
        logger.severe('Data upload error - discarding $lastOp', e);
        await transaction.complete();
      } else {
        // Unexpected errors may be retryable - e.g. network error or temporary server error.
        // Throwing an error here causes this call to be retried after a delay.
        rethrow;
      }
    }
  }
}

class ApiException implements Exception {
  final String message;
  final String? code;

  ApiException(this.message, {this.code});

  @override
  String toString() {
    return 'ApiException: $message';
  }
}

/// Global reference to the database
late final PowerSyncDatabase powersyncDb;

bool isLoggedIn() {
  return Supabase.instance.client.auth.currentSession?.accessToken != null;
}

/// id of the user currently logged in
String? getUserId() {
  return Supabase.instance.client.auth.currentSession?.user.id;
}

Future<String> getDatabasePath() async {
  final dir = await getApplicationSupportDirectory();
  return join(dir.path, 'finny1.db');
}

/// Initializes powersync database and connects to Supabase.
Future<void> openDatabaseAndInitSupabase() async {
  // Open the local database
  powersyncDb = PowerSyncDatabase(
      schema: schema, path: await getDatabasePath(), logger: attachedLogger);
  await powersyncDb.initialize();

  await loadSupabase();

  SupabaseConnector? currentConnector;

  if (isLoggedIn()) {
    // If the user is already logged in, connect immediately.
    // Otherwise, connect once logged in.
    currentConnector = SupabaseConnector(powersyncDb);
    powersyncDb.connect(connector: currentConnector);
  }

  Supabase.instance.client.auth.onAuthStateChange.listen(
    (data) async {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        // Connect to PowerSync when the user is signed in
        currentConnector = SupabaseConnector(powersyncDb);
        powersyncDb.connect(connector: currentConnector!);
        // Navigator.pushNamed(context, Routes.home);
      } else if (event == AuthChangeEvent.signedOut) {
        // Implicit sign out - disconnect, but don't delete data
        currentConnector = null;
        await powersyncDb.disconnect();
      } else if (event == AuthChangeEvent.tokenRefreshed) {
        // Supabase token refreshed - trigger token refresh for PowerSync.
        currentConnector?.prefetchCredentials();
      }
    },
    onError: (error) {
      if (error is AuthException) {
        Logger.root.warning('auth error: ${error.message}');
        // context.showSnackBar(error.message, isError: true);
      } else {
        Logger.root.severe('Unexpected auth error: $error');
        // context.showSnackBar('Unexpected error occurred', isError: true);
      }
    },
  );

  // Demo using SQLite Full-Text Search with PowerSync.
  // See https://docs.powersync.com/usage-examples/full-text-search for more details
  // await configureFts(db);
}

/// Explicit sign out - clear database and log out.
Future<void> logout() async {
  await Supabase.instance.client.auth.signOut();
  await powersyncDb.disconnectAndClear();
}
