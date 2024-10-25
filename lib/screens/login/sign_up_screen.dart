import 'package:flutter/material.dart';
import 'package:down_care/screens/login/auth_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthScreen(isSignIn: false);
  }
}
