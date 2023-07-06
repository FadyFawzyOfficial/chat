import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var isSignIn = true;
  var _email = '', _username = '', _password = '';

  @override
  Widget build(context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  key: const ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  onSaved: (email) => _email = email ?? '',
                  validator: (email) =>
                      email == null || email.isEmpty || !email.contains('@')
                          ? 'Please, provide a valid email address.'
                          : null,
                ),
                if (isSignIn)
                  TextFormField(
                    key: const ValueKey('username'),
                    decoration: const InputDecoration(labelText: 'Username'),
                    onSaved: (username) => _username = username ?? '',
                    validator: (username) => username == null ||
                            username.isEmpty ||
                            username.length < 4
                        ? 'Username must be at least 4 characters'
                        : null,
                  ),
                TextFormField(
                  key: const ValueKey('password'),
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  onSaved: (password) => _password = password ?? '',
                  validator: (password) => password == null ||
                          password.isEmpty ||
                          password.length < 7
                      ? 'Password must be at least 7 characters long.'
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: ElevatedButton(
                    onPressed: authenticate,
                    child: Text(isSignIn ? 'Sign In' : 'Sign Up'),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => isSignIn = !isSignIn),
                  child: Text(
                    isSignIn
                        ? 'Create an account'
                        : 'I already have an account',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void authenticate() {
    // Hide the Soft Keyboard while Authentication
    FocusScope.of(context).unfocus();

    final formCurrentState = _formKey.currentState;
    final isValid = formCurrentState != null && formCurrentState.validate();

    if (!isValid) {
      return;
    }

    formCurrentState.save();
    print(_email);
    print(_username);
    print(_password);

    // Use these values to send an auth request ...
  }
}
