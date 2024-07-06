import 'package:finny/src/auth/auth_controller.dart';
import 'package:finny/src/context_extension.dart';
import 'package:finny/src/routes.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.authController});

  static const routeName = Routes.login;

  final AuthController authController;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
    widget.authController.initAuthStateListener(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.authController.isLoggedIn) {
        Navigator.restorablePushNamed(context, Routes.accounts);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    widget.authController.dispose();
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
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: widget.authController.isLoading
                ? null
                : () => widget.authController.signIn(
                    _emailController.text, context, context.showSnackBar),
            child: Text(widget.authController.isLoading
                ? 'Sending...'
                : 'Send Magic Link'),
          ),
        ],
      ),
    );
  }
}
