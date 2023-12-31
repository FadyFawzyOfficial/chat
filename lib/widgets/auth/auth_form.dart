import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'image_input.dart';

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
  File? _image;

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
                if (!_isSignIn) ImageInput(onPickImage: _onPickImage),
                TextFormField(
                  key: const ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
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
                    autocorrect: true,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.words,
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

  void _onPickImage({File? imageFile}) => _image = imageFile;

  void _validateThenAuthenticate() {
    // Hide the Soft Keyboard while Authentication
    FocusScope.of(context).unfocus();

    final formCurrentState = _formKey.currentState;
    final isValid = formCurrentState != null && formCurrentState.validate();

    if (!_isSignIn && _image == null) {
      displayErrorMessage('Please, pick an image');
      return;
    }

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

        final imageUrl = await _uploadUserImage(
          userId: userCredential.user!.uid,
          imageFile: _image!,
        );

        // Store the user name, email & image after SignUp the user
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(
          {
            'username': _username,
            'email': _email,
            'imageUrl': imageUrl,
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      displayErrorMessage(e.message);
      setState(() => _isLoading = false);
    } on PlatformException catch (e) {
      displayErrorMessage(e.message);
      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('$e');
      setState(() => _isLoading = false);
    }
  }

  Future<String> _uploadUserImage({
    required String userId,
    required File imageFile,
  }) async {
    // Store the user image after SignUp the user
    // Set the image path
    final reference = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('$userId.jpg');

    // Upload the image file
    await reference.putFile(_image!);

    // Get the image url
    final imageUrl = await reference.getDownloadURL();

    return imageUrl;
  }

  void displayErrorMessage(String? errorMessage) {
    var message = 'An error occurred, please check your credentials!';

    if (errorMessage != null) {
      message = errorMessage;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
