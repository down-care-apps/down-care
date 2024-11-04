import 'package:flutter/material.dart';
import 'package:down_care/screens/login/sign_up_screen.dart';
import 'package:down_care/screens/login/sign_in_screen.dart';
import 'package:down_care/screens/login/welcome.dart';
import 'package:down_care/widgets/bottom_navbar.dart';
import 'package:down_care/screens/home/maps/maps_screen.dart';
import 'package:down_care/screens/home/progress/progress_screen.dart';
import 'package:down_care/screens/home/reminder/reminder_page.dart';
import 'package:down_care/screens/home/kids/kids_profile_screen.dart';

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
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF2965FF), // Define primary color
          secondary: const Color(0xFFDAE2FF), // Define secondary color
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/main',
      routes: {
        '/': (context) => const Welcome(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/main': (context) => const MainScreen(),
        '/maps': (context) => const MapPage(),
        '/progress': (context) => ProgressScreen(),
        '/reminder': (context) => const ReminderPage(),
        '/kidsProfile': (context) => KidsProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomNavBar(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Use defined color
    );
  }
}
