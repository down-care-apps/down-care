import 'package:down_care/api/user_api.dart';
import 'package:flutter/material.dart';
import 'package:down_care/screens/home/home_widgets/profile_card.dart';
import 'package:down_care/screens/home/home_widgets/quick_menu.dart';
import 'package:down_care/screens/home/home_widgets/section_content.dart';
import 'package:down_care/screens/home/home_widgets/article_carousel.dart';
import 'package:down_care/screens/home/home_widgets/down_type.dart';
import 'package:down_care/screens/home/history/history_diagnose.dart';
import 'package:down_care/screens/home/reminder/reminder_page.dart';
import 'package:down_care/screens/home/maps/maps_screen.dart';
import 'package:down_care/api/logoutApi.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await logoutUser(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileCard(),
              _buildQuickMenu(context),
              _buildArticleSection(),
              _buildDownSyndromeSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return FutureBuilder<Map<String, dynamic>>(
      future: UserService().getCurrentUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error loading user data');
        } else {
          final user = snapshot.data!;
          print(user);

          final username = user['displayName'] as String? ?? 'Unknown User';
          final avatarUrl = user['photoURL'] as String? ?? '';

          return ProfileCard(
            username: username,
            address: 'Jl. Semanggi Barat 2B, Malang',
            avatarUrl: avatarUrl,
          );
        }
      },
    );
  }

  Widget _buildQuickMenu(BuildContext context) {
    return QuickMenu(
      onMenuTap: (index) {
        if (index == 3) {
          _showLogoutDialog(context);
        } else {
          _navigateTo(context, _getPage(index));
        }
      },
    );
  }

  Widget _buildArticleSection() {
    return SectionWithContent(
      title: 'Artikel',
      child: ArticleCarousel(articles: _fetchArticles()),
    );
  }

  Widget _buildDownSyndromeSection() {
    return const SectionWithContent(
      title: 'Ketahui Jenis Down Syndrome!',
      child: DownSyndromeMenu(),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HistoryPage();
      case 1:
        return const ReminderPage();
      case 2:
        return const MapPage();
      default:
        return const HomeScreen(); // Fallback
    }
  }

  List<Article> _fetchArticles() {
    // Replace with actual data fetching logic
    return [
      Article(title: 'Understanding Down Syndrome', thumbnailUrl: 'https://example.com/article1.jpg'),
      Article(title: 'Supporting Children with Down Syndrome', thumbnailUrl: 'https://example.com/article2.jpg'),
      Article(title: 'Advancements in Down Syndrome Research', thumbnailUrl: 'https://example.com/article3.jpg'),
    ];
  }
}
