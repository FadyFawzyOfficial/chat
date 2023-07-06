import 'package:flutter/material.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        authenticate: _authenticate,
      ),
    );
  }

  void _authenticate({
    required String email,
    required String username,
    required String password,
    required bool isSignIn,
  }) {}
}
