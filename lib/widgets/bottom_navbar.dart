import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/home/home_screen.dart';
import '../screens/camera/history_screen.dart';
import '../screens/profile/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  final int initialIndex;

  const BottomNavBar({super.key, this.initialIndex = 0});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _currentIndex;

  final List<Widget> _screens = [
    HomeScreen(),
    const HistoryPage(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // Initialize the current index
  }

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
