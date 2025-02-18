import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';

class AuthService {
  AuthService(SupabaseClient client) {
    _supabase = client;
  }

  static final _log = Logger('AuthService');
  late final SupabaseClient _supabase;

  Future<void> loginAnonymously() async {
    try {
      // Check if we're already authenticated
      final session = _supabase.auth.currentSession;
      if (session != null) {
        return;
      }

      // If not authenticated, perform anonymous sign in
      _log.info('Performing anonymous authentication');
      final response = await _supabase.auth.signInAnonymously();

      if (response.session != null) {
        _log.info('Anonymous authentication successful');
      } else {
        _log.warning('Anonymous authentication failed - no session returned');
      }
    } catch (e, stack) {
      _log.severe('Failed to ensure anonymous authentication', e, stack);
    }
  }
}
