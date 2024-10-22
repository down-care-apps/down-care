import 'package:flutter/material.dart';

class SignInSignUpFormScreen extends StatefulWidget {
  const SignInSignUpFormScreen({super.key});

  @override
  _SignInSignUpFormScreenState createState() => _SignInSignUpFormScreenState();
}

class _SignInSignUpFormScreenState extends State<SignInSignUpFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  bool _isSignIn = true;

  @override
  Widget build(BuildContext context) {
    // Check whether user wants to sign in or sign up based on arguments
    final String formType = ModalRoute.of(context)?.settings.arguments as String;
    _isSignIn = formType == 'signin';

    return Scaffold(
      appBar: AppBar(
        title: Text(_isSignIn ? 'Sign In' : 'Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Normally you would authenticate here
                    Navigator.pushReplacementNamed(context, '/main');
                  }
                },
                child: Text(_isSignIn ? 'Sign In' : 'Sign Up'),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Implement Google Sign-In logic here
                  Navigator.pushReplacementNamed(context, '/main');
                },
                icon: const Icon(Icons.login),
                label: const Text('Continue with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
