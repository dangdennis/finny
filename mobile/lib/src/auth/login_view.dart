import 'package:finny/src/auth/auth_provider.dart';
import 'package:finny/src/context_extension.dart';
import 'package:finny/src/routes.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(title: const Text('Sign In')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const Text('Sign in via the magic link with your email below'),
          const SizedBox(height: 18),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: widget.authProvider.isLoading
                ? null
                : () => widget.authProvider.signIn(
                    _emailController.text, context, context.showSnackBar),
            child: Text(widget.authProvider.isLoading
                ? 'Sending...'
                : 'Send Magic Link'),
          ),
        ],
      ),
    );
  }
}
