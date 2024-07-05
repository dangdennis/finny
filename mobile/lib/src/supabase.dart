import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_config.dart';

final supabase = Supabase.instance.client;

loadSupabase() async {
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );
}
