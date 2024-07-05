import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase;

  AuthService(this.supabase);

  Future<void> signInWithOtp(
      String email, Function(String, {bool isError}) showSnackBar) async {
    try {
      await supabase.auth.signInWithOtp(
        email: email.trim(),
        emailRedirectTo: kIsWeb ? null : 'com.belmont.finny://login-callback/',
      );
      showSnackBar('Check your email for a login link!');
    } on AuthException catch (error) {
      showSnackBar(error.message, isError: true);
    } catch (error) {
      showSnackBar('Unexpected error occurred', isError: true);
    }
  }

  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;
}
