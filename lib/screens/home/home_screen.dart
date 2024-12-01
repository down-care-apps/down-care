import 'package:down_care/api/articles_service.dart';
import 'package:down_care/api/image_camera_services.dart';
import 'package:down_care/api/user_api.dart';
import 'package:down_care/screens/home/article/article_mosaik.dart';
import 'package:down_care/screens/home/article/article_translokasi.dart';
import 'package:down_care/screens/home/article/article_trisomi21.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:down_care/utils/transition.dart';
import 'package:down_care/widgets/scan_history_card.dart';
import 'package:down_care/screens/home/home_widgets/section_title.dart';
import 'package:down_care/screens/home/home_widgets/syndrome_type_card.dart';
import 'package:down_care/screens/home/home_widgets/article_card.dart';
import 'package:down_care/screens/camera/history_detail_screen.dart';

class Article {
  final String title;
  final String imageUrl;

  Article({required this.title, required this.imageUrl});
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              )
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProfileCard(),
              SvgPicture.asset('assets/icon/notification.svg', width: 28, height: 28),
            ],
          ),
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
    return FutureBuilder<Map<String, dynamic>>(
      future: UserService().getCurrentUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error loading user data');
        } else {
          final user = snapshot.data!;
          final username = user['displayName'] as String? ?? 'Unknown User';
          final avatarUrl = user['photoURL'] as String? ?? '';

          return Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: Colors.grey[300],
                backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                child: avatarUrl.isEmpty ? const Icon(Icons.person, color: Colors.white, size: 24) : null,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.leagueSpartan(fontSize: 20, color: Colors.black),
                      children: const [
                        TextSpan(text: 'Hello,', style: TextStyle(fontWeight: FontWeight.w300)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.leagueSpartan(fontSize: 20, color: Colors.black),
                      children: [
                        TextSpan(text: username, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildMenuButton(BuildContext context, dynamic icon, String label, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
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
    return FutureBuilder(
      future: ArticlesService().getArticles(limit: 3),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error loading articles ${snapshot.error}');
        } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return const Text('No articles found');
        } else {
          final articles = snapshot.data as List<Map<String, dynamic>>;

          return SizedBox(
            height: 190,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: articles.length < 3 ? articles.length : 3,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(left: index == 0 ? 16 : 0),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: ArticleCard(
                      title: articles[index]['title'] ?? 'No Title', // Ensure title is not null
                      imageUrl: articles[index]['thumbnailUrl'] ?? 'https://picsum.photos/200/300?grayscale', // Ensure thumbnailUrl is not null
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
                MaterialPageRoute(builder: (context) => const ArticleScreen()),
              );
            },
            child: const SyndromeTypeCard(name: 'Trisomi 21', imageUrl: 'assets/trisomi21.jpeg'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ArticleMosaikScreen()),
              );
            },
            child: const SyndromeTypeCard(name: 'Mosaik', imageUrl: 'assets/Mosaik.jpg'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ArticleTranslokasi()),
              );
            },
            child: const SyndromeTypeCard(
              name: 'Mosaik',
              imageUrl: 'assets/Translokasi.jpg',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScanHistoryList(BuildContext context) {
    final futureScan = ImageCameraServices().getAllScan(limit: 3);

    return FutureBuilder(
      future: futureScan,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading spinner while waiting for data
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Display an error message if something goes wrong
          return const Center(
            child: Text(
              'Tidak ada riwayat pemindaian tersedia. Silahkan scan gambar terlebih dahulu.',
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          // If data is successfully fetched and not empty
          final scanHistories = snapshot.data!;

          return Column(
            children: scanHistories.map((scanHistory) {
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
        } else {
          // Display a message if the data is empty
          return const Center(
            child: Text('Tidak ada riwayat pemindaian tersedia.'),
          );
        }
      },
    );
  }
}
