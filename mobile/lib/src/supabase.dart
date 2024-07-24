import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_config.dart';

class SupabaseService {
  static Future<void> loadSupabase() async {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
  }
}
