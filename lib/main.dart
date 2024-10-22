import 'package:flutter/material.dart';
import 'screens/signin_signup_choice_screen.dart';
import 'screens/signin_signup_form_screen.dart';
import 'widgets/bottom_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DownCare App',
      theme: ThemeData(
        primaryColor: const Color(0xFF2260FF), // Define your primary color here
        primarySwatch: Colors.blue, // Optional, for creating a blue-based palette
      ),
      initialRoute: '/', // Start with the SignInSignUpChoiceScreen
      routes: {
        '/': (context) => const SignInSignUpChoiceScreen(), // First screen
        '/signin-signup-form': (context) => const SignInSignUpFormScreen(), // Form screen
        '/main': (context) => const MainScreen(), // Main app screen after login
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomNavBar(),
    );
  }
}