import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/home/home_screen.dart';
import '../screens/camera/history_screen.dart';
import '../screens/profile/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    HistoryPage(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  BottomNavigationBarItem _buildNavItem(String assetPath, String label, int index) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        assetPath,
        color: _currentIndex == index ? Colors.white : Colors.white54,
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
        ),
        child: SizedBox(
          height: 64,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).primaryColor,
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            selectedLabelStyle: GoogleFonts.leagueSpartan(fontWeight: FontWeight.w500, fontSize: 12),
            unselectedLabelStyle: GoogleFonts.leagueSpartan(fontWeight: FontWeight.w500, fontSize: 12),
            items: [
              _buildNavItem('assets/icon/home.svg', 'Beranda', 0),
              _buildNavItem('assets/icon/camera.svg', 'Pindai', 1),
              _buildNavItem('assets/icon/profile-circle.svg', 'Profil', 2),
            ],
          ),
        ),
      ),
    );
  }
}
