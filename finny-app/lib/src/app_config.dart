class AppConfig {
  static const supabaseUrl = "https://tqonkxhrucymdyndpjzf.supabase.co";
  static const supabaseAnonKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRxb25reGhydWN5bWR5bmRwanpmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAxNjI3NDIsImV4cCI6MjAzNTczODc0Mn0.sCXfp7mKFSQ0KKeS2MXAY7yRuBnMMr--7Gx4v_YEz1I";
  // static const apiBaseUrl = "https://api.finny.finance";
  static const apiBaseUrl = "https://finny-production.up.railway.app";
  static final usersDeleteUrl = Uri.parse("$apiBaseUrl/users/delete");
}
