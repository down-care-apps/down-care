import 'package:down_care/providers/article_provider.dart';
import 'package:down_care/providers/scan_history_provider.dart';
import 'package:down_care/screens/home/article/article_mosaik.dart';
import 'package:down_care/screens/home/article/article_translokasi.dart';
import 'package:down_care/screens/home/article/article_trisomi21.dart';
import 'package:down_care/screens/home/kids/kids_profile_screen.dart';
import 'package:down_care/screens/home/maps/maps_screen.dart';
import 'package:down_care/screens/home/progress/progress_screen.dart';
import 'package:down_care/screens/home/reminder/reminder_page.dart';
import 'package:down_care/widgets/skeleton_article_home.dart';
import 'package:down_care/widgets/skeleton_profile_home.dart';
import 'package:down_care/widgets/skeleton_scan_history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:down_care/utils/transition.dart';
import 'package:down_care/widgets/card_scan_history.dart';
import 'package:down_care/screens/home/home_widgets/section_title.dart';
import 'package:down_care/screens/home/home_widgets/syndrome_type_card.dart';
import 'package:down_care/screens/home/home_widgets/article_card.dart';
import 'package:down_care/screens/camera/history_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:down_care/providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Use addPostFrameCallback to ensure the fetch methods are called after the build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch user data when the screen is initialized
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchCurrentUser();

      // Fetch scan history data when the screen is initialized
      final scanHistoryProvider = Provider.of<ScanHistoryProvider>(context, listen: false);
      scanHistoryProvider.fetchScanHistory();

      // Fetch articles data when the screen is initialized
      final articlesProvider = Provider.of<ArticlesProvider>(context, listen: false);
      articlesProvider.fetchArticles(limit: 3);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SectionTitle(title: 'Artikel Menarik', seeAll: true),
                  ),
                  const SizedBox(height: 8),
                  _buildArticleList(),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SectionTitle(title: 'Ketahui Jenis Down Syndrome'),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildDownSyndromeMenu(context),
                  ),
                  const SizedBox(height: 24),
                  // Conditionally render scan history section
                  _buildScanHistorySection(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileCard(),
          const SizedBox(height: 8),
          Divider(color: Theme.of(context).colorScheme.secondary),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMenuButton(context, 'assets/icon/trend-up.svg', 'Pertumbuhan', '/progress'),
              _buildMenuButton(context, 'assets/icon/calendar.svg', 'Pengingat', '/reminder'),
              _buildMenuButton(context, 'assets/icon/map.svg', 'Peta', '/maps'),
              _buildMenuButton(context, 'assets/icon/kids.svg', 'Profil Anak', '/kidsProfile'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;

        if (user == null) {
          return const ProfileCardSkeleton();
        }

        final username = user.displayName.isNotEmpty ? user.displayName : 'Unknown User';

        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Hello, ',
                style: GoogleFonts.leagueSpartan(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: '$username 👋',
                style: GoogleFonts.leagueSpartan(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuButton(BuildContext context, dynamic icon, String label, String route) {
    return GestureDetector(
      onTap: () {
        final screen = {
          '/progress': const ProgressScreen(),
          '/reminder': const ReminderPage(),
          '/maps': const MapPage(),
          '/kidsProfile': const KidsProfileScreen(),
        }[route];

        if (screen != null) {
          Navigator.push(context, createRoute(screen));
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              icon,
              width: 38,
              height: 38,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.leagueSpartan(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleList() {
    return Consumer<ArticlesProvider>(
      builder: (context, articlesProvider, child) {
        if (articlesProvider.isLoading && articlesProvider.articles.isEmpty) {
          return SizedBox(
            height: 190,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(left: index == 0 ? 16 : 0),
                  child: const ArticleCardSkeleton(),
                );
              },
            ),
          );
        } else if (articlesProvider.error != null) {
          return Text('Error loading articles: ${articlesProvider.error}');
        } else if (articlesProvider.articles.isEmpty) {
          return const Text('No articles found');
        } else {
          final articles = articlesProvider.articles.take(3).toList(); // Limit to 3 articles

          return SizedBox(
            height: 190,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(left: index == 0 ? 16 : 0),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: ArticleCard(
                      title: articles[index].title, // Use the Article model
                      imageUrl: articles[index].thumbnailURL ?? '', // Use the Article model
                      content: articles[index].content, // Use the Article model
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildDownSyndromeMenu(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ArticleScreen()),
              );
            },
            child: SyndromeTypeCard(name: 'Trisomi 21', imageUrl: 'assets/trisomi21.jpeg'),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ArticleMosaikScreen()),
              );
            },
            child: SyndromeTypeCard(name: 'Mosaik', imageUrl: 'assets/Mosaik.jpg'),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ArticleTranslokasi()),
              );
            },
            child: SyndromeTypeCard(
              name: 'Mosaik',
              imageUrl: 'assets/Translokasi.jpg',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScanHistorySection(BuildContext context) {
    final scanHistoryProvider = Provider.of<ScanHistoryProvider>(context);

    if (scanHistoryProvider.latestScanHistories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: SectionTitle(title: 'Riwayat Pemindaian Terbaru'),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildScanHistoryList(context),
        ),
      ],
    );
  }

  Widget _buildScanHistoryList(BuildContext context) {
    final scanHistoryProvider = Provider.of<ScanHistoryProvider>(context);

    return scanHistoryProvider.isLoading
        ? Column(
            children: List.generate(3, (index) => const SkeletonScanHistoryCard()).toList(),
          )
        : scanHistoryProvider.latestScanHistories.isEmpty
            ? const Center(
                child: Text('Tidak ada riwayat pemindaian'),
              )
            : scanHistoryProvider.errorMessage.isNotEmpty
                ? Center(
                    child: Text(scanHistoryProvider.errorMessage),
                  )
                : Column(
                    children: scanHistoryProvider.latestScanHistories.map((scanHistory) {
                      return Column(
                        children: [
                          ScanHistoryCard(
                            scanHistory: scanHistory,
                            onTap: () {
                              Navigator.push(
                                context,
                                createRoute(HistoryDetailPage(scanHistory: scanHistory)),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    }).toList(),
                  );
  }
}
