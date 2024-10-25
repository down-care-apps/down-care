import 'package:flutter/material.dart';
import 'package:down_care/screens/login/auth_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthScreen(isSignIn: true);
  }
}