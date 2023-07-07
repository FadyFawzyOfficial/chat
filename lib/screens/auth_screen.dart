import 'package:flutter/material.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: const AuthForm(),
    );
  }
}
