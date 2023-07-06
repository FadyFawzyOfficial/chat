import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  var _isSignIn = true, _isLoading = false;
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
                  onSaved: (email) => _email = email?.trim() ?? '',
                  validator: (email) =>
                      email == null || email.isEmpty || !email.contains('@')
                          ? 'Please, provide a valid email address.'
                          : null,
                ),
                if (!_isSignIn)
                  TextFormField(
                    key: const ValueKey('username'),
                    decoration: const InputDecoration(labelText: 'Username'),
                    onSaved: (username) => _username = username?.trim() ?? '',
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
                const SizedBox(height: 16),
                _isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : Column(
                        children: [
                          ElevatedButton(
                            onPressed: _validateThenAuthenticate,
                            child: Text(_isSignIn ? 'Sign In' : 'Sign Up'),
                          ),
                          TextButton(
                            onPressed: () =>
                                setState(() => _isSignIn = !_isSignIn),
                            child: Text(
                              _isSignIn
                                  ? 'Create an account'
                                  : 'I already have an account',
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateThenAuthenticate() {
    // Hide the Soft Keyboard while Authentication
    FocusScope.of(context).unfocus();

    final formCurrentState = _formKey.currentState;
    final isValid = formCurrentState != null && formCurrentState.validate();

    if (!isValid) {
      return;
    }

    formCurrentState.save();
    _authenticate();
  }

  Future<void> _authenticate() async {
    UserCredential userCredential;

    try {
      setState(() => _isLoading = true);
      if (_isSignIn) {
        userCredential = await auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
      } else {
        userCredential = await auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Store the username after SignUp the user
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(
          {
            'username': _username,
            'email': _email,
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      displayErrorMessage(e);
      setState(() => _isLoading = false);
    } on PlatformException catch (e) {
      displayErrorMessage(e);
      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('$e');
      setState(() => _isLoading = false);
    }
  }

  void displayErrorMessage(dynamic e) {
    var message = 'An error occurred, please check your credentials!';

    if (e.message != null) {
      message = e.message!;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
