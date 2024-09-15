import 'package:finny/src/auth/auth_provider.dart';
import 'package:finny/src/context_extension.dart';
import 'package:finny/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.authProvider});

  static const routeName = Routes.login;

  final AuthProvider authProvider;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
    widget.authProvider.initAuthStateListener(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.authProvider.isLoggedIn) {
        Navigator.restorablePushNamed(context, Routes.accounts);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    widget.authProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Welcome to Finny',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Realize your financial freedom',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: widget.authProvider.isLoading
                      ? null
                      : () => widget.authProvider.signInWithEmail(
                          _emailController.text, context, context.showSnackBar),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.authProvider.isLoading
                        ? 'Logging...'
                        : 'Sign In with Email',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'OR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                SignInWithAppleButton(
                  onPressed: () {
                    widget.authProvider.signInWithApple(context);
                  },
                  style: SignInWithAppleButtonStyle.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
