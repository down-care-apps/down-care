import 'package:down_care/providers/reminder_provider.dart';
import 'package:down_care/providers/scan_history_provider.dart';
import 'package:down_care/providers/user_provider.dart';
import 'package:down_care/providers/kids_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import './firebase_options.dart';
import 'package:down_care/screens/login/sign_up_screen.dart';
import 'package:down_care/screens/login/sign_in_screen.dart';
import 'package:down_care/screens/login/welcome.dart';
import 'package:down_care/widgets/bottom_navbar.dart';
import 'package:down_care/screens/home/maps/maps_screen.dart';
import 'package:down_care/screens/home/progress/progress_screen.dart';
import 'package:down_care/screens/home/reminder/reminder_page.dart';
import 'package:down_care/screens/home/kids/kids_profile_screen.dart';
import 'package:down_care/screens/home/kids/kids_add_screen.dart';
import 'package:down_care/screens/home/kids/kids_detail_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KidsProvider()),
        ChangeNotifierProvider(create: (_) => ScanHistoryProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if a user is already logged in
    User? user = FirebaseAuth.instance.currentUser;

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
      initialRoute: user != null ? '/main' : '/', // Navigate to MainScreen if user is logged in
      routes: {
        '/': (context) => const Welcome(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/main': (context) => const MainScreen(),
        '/maps': (context) => const MapPage(),
        '/progress': (context) => const ProgressScreen(),
        '/reminder': (context) => const ReminderPage(),
        '/kidsProfile': (context) => const KidsProfileScreen(),
        '/addKid': (context) => const KidAddScreen(),
        '/kidDetails': (context) => const KidDetailScreen(id: ''), // ID will be passed via arguments
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
      body: const BottomNavBar(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
