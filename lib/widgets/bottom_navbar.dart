import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/camera_screen.dart';
import '../screens/kids_profile_screen.dart';
import '../screens/settings_screen.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  // List of all the screens
  final List<Widget> _screens = [
    HomeScreen(),
    ProgressScreen(),
    // Instead of using the CameraScreen here, we'll navigate to it
    Container(), // Placeholder for camera, we will handle the navigation
    KidsProfileScreen(),
    SettingsScreen(),
  ];

  void _onTabTapped(int index) {
    if (index == 2) {
      // Navigate to full-screen camera when the Camera tab is tapped
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(), // Full-screen camera
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex != 2
          ? _screens[_currentIndex]
          : null, // Do not show anything for camera
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped, // Handles tab selection
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).colorScheme.primary,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.child_care),
            label: 'Kids Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
