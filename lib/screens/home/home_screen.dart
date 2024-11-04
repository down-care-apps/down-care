import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:down_care/widgets/scan_history_card.dart';
import 'package:down_care/screens/home/home_widgets/section_title.dart';
import 'package:down_care/screens/home/home_widgets/syndrome_type_card.dart';
import 'package:down_care/screens/home/home_widgets/article_card.dart';

class Article {
  final String title;
  final String imageUrl;

  Article({required this.title, required this.imageUrl});
}

class HomeScreen extends StatelessWidget {
  final List<Article> articles = [
    Article(title: 'Article 1', imageUrl: 'https://via.placeholder.com/250'),
    Article(title: 'Article 2', imageUrl: 'https://via.placeholder.com/250'),
    Article(title: 'Article 3', imageUrl: 'https://via.placeholder.com/250'),
    // Add more articles as needed
  ];
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 24),
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
                    child: _buildDownSyndromeMenu(),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SectionTitle(title: 'Riwayat Pemindaian'),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildScanHistoryList(),
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
              Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, color: Colors.white, size: 24),
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
                          children: const [
                            TextSpan(text: 'Muhammad Iqbal', style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
                title: articles[index].title,
                imageUrl: articles[index].imageUrl,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDownSyndromeMenu() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: SyndromeTypeCard(name: 'Trisomi 21', imageUrl: 'https://via.placeholder.com/250')),
        SizedBox(width: 8),
        Expanded(child: SyndromeTypeCard(name: 'Mosaik', imageUrl: 'https://via.placeholder.com/250')),
        SizedBox(width: 8),
        Expanded(child: SyndromeTypeCard(name: 'Translokasi', imageUrl: 'https://via.placeholder.com/250')),
      ],
    );
  }

  Widget _buildScanHistoryList() {
    return const Column(
      children: [
        ScanHistoryCard(name: 'Scan_1', date: '1 September 2024', result: '70%', thumbnailUrl: 'https://via.placeholder.com/250'),
        SizedBox(height: 8),
        ScanHistoryCard(name: 'Scan_2', date: '1 September 2024', result: '70%', thumbnailUrl: 'https://via.placeholder.com/250'),
        SizedBox(height: 8),
        ScanHistoryCard(name: 'Scan_3', date: '1 September 2024', result: '70%', thumbnailUrl: 'https://via.placeholder.com/250'),
      ],
    );
  }
}
