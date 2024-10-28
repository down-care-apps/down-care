import 'package:flutter/material.dart';
import 'package:down_care/screens/home/home_widgets/profile_card.dart';
import 'package:down_care/screens/home/home_widgets/quick_menu.dart';
import 'package:down_care/screens/home/home_widgets/section_content.dart';
import 'package:down_care/screens/home/home_widgets/article_carousel.dart';
import 'package:down_care/screens/home/home_widgets/down_type.dart';
import 'package:down_care/screens/home/history/history_diagnose.dart';
import 'package:down_care/screens/home/reminder/reminder.dart';
import 'package:down_care/screens/home/maps/maps_screen.dart';

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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                // Handle logout logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('You have logged out.')),
                );
              },
            ),
          ],
        );
      },
    );
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
    return const ProfileCard(
      username: 'John Doe',
      address: 'Jl. Semanggi Barat 2B, Malang',
      avatarUrl: 'https://example.com/path_to_avatar.jpg',
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
