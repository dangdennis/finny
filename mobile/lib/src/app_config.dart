class AppConfig {
  static const powersyncUrl =
      "https://668757e925c6e47d23577e1f.powersync.journeyapps.com";
  static const supabaseUrl = "https://tqonkxhrucymdyndpjzf.supabase.co";
  static const supabaseAnonKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRxb25reGhydWN5bWR5bmRwanpmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAxNjI3NDIsImV4cCI6MjAzNTczODc0Mn0.sCXfp7mKFSQ0KKeS2MXAY7yRuBnMMr--7Gx4v_YEz1I";
  static const apiBaseUrl = "https://api.finny.finance";
  static final plaidItemsListUrl = Uri.parse("$apiBaseUrl/plaid-items/list");
  static final plaidItemsCreateUrl =
      Uri.parse("$apiBaseUrl/plaid-items/create");
  static final plaidItemsDeleteUrl =
      Uri.parse("$apiBaseUrl/plaid-items/delete");
  static final plaidLinksCreateUrl =
      Uri.parse("$apiBaseUrl/plaid-links/create");
  static final usersDeleteUrl = Uri.parse("$apiBaseUrl/users/delete");
}
