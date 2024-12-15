import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Tentang Down Care',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // About Section
            _buildSectionHeader('Tentang Aplikasi'),
            const SizedBox(height: 12),
            _buildDescriptionText(
              'Down Care adalah aplikasi inovatif yang dirancang untuk membantu orangtua dan tenaga medis dalam deteksi dini karakteristik Down syndrome pada anak usia di bawah 6 tahun.',
            ),
            const SizedBox(height: 32),

            // Features Section
            _buildSectionHeader('Fitur Utama'),
            const SizedBox(height: 16),
            _buildFeatureGrid(),
            const SizedBox(height: 32),

            // FAQ Section
            _buildSectionHeader('Pertanyaan Yang Sering Diajukan'),
            const SizedBox(height: 12),
            _buildFAQSection(),
            const SizedBox(height: 32),

            // Privacy Policy Section
            _buildSectionHeader('Kebijakan Privasi'),
            const SizedBox(height: 12),
            _buildDescriptionText(
              'Kami menjamin kerahasiaan data pribadi Anda. Semua informasi yang dikumpulkan hanya digunakan untuk tujuan skrining dan dukungan medis.',
            ),
          ],
        ),
      ),
    );
  }

  // FAQ Section with Custom ExpansionTile
  Widget _buildFAQSection() {
    return Column(
      children: [
        _buildCustomExpansionTile(
          title: 'Apa itu Down Care?',
          content:
              'Down Care adalah aplikasi pendukung deteksi dini Down syndrome yang membantu orangtua dan tenaga medis mengenali karakteristik dan tanda-tanda Down syndrome pada anak usia di bawah 6 tahun.',
        ),
        _buildCustomExpansionTile(
          title: 'Bagaimana cara kerja aplikasi ini?',
          content:
              'Aplikasi menggunakan teknologi pengenalan wajah dan ekstraksi fitur geometri serta Local Binary Patterns (LBP) untuk membantu mendeteksi karakteristik fisik yang terkait dengan Down syndrome melalui analisis citra wajah.',
        ),
        _buildCustomExpansionTile(
          title: 'Apakah aplikasi ini dapat mendiagnosis Down syndrome?',
          content:
              'Tidak. Aplikasi ini hanya merupakan alat skrining awal. Untuk diagnosis definitif, diperlukan pemeriksaan medis komprehensif oleh dokter spesialis.',
        ),
        _buildCustomExpansionTile(
          title: 'Apakah data saya aman?',
          content:
              'Ya, kami menjamin kerahasiaan dan keamanan data pribadi Anda. Informasi hanya digunakan untuk tujuan skrining dan tidak akan dibagikan tanpa izin.',
        ),
      ],
    );
  }

  // Feature Grid Widget
  Widget _buildFeatureGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      children: [
        _buildFeatureItem(
          icon: Icons.camera_alt,
          title: 'Skrining',
          description: 'Deteksi awal Down Syndrome melalui analisis wajah',
        ),
        _buildFeatureItem(
          icon: Icons.person_add,
          title: 'Profil Anak',
          description: 'Tambah dan kelola informasi lengkap profil anak',
        ),
        _buildFeatureItem(
          icon: Icons.history,
          title: 'Riwayat Pemindaian',
          description: 'Dokumentasikan hasil pemeriksaan sebelumnya',
        ),
        _buildFeatureItem(
          icon: Icons.article,
          title: 'Artikel',
          description: 'Artikel dan berita terkait dengan Down Syndrome',
        ),
      ],
    );
  }

  // Custom Expansion Tile
  Widget _buildCustomExpansionTile({
    required String title,
    required String content,
  }) {
    return Builder(
      builder: (context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Theme(
          data: ThemeData(
            dividerColor: Colors.transparent,
            expansionTileTheme: const ExpansionTileThemeData(
              backgroundColor: Colors.transparent,
              collapsedBackgroundColor: Colors.transparent,
            ),
          ),
          child: ExpansionTile(
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            childrenPadding: const EdgeInsets.all(16),
            children: [
              Text(
                content,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Section Header
  Widget _buildSectionHeader(String title) {
    return Builder(
      builder: (context) => Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Description Text
  Widget _buildDescriptionText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
        height: 1.5,
      ),
    );
  }

  // Feature Item
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Builder(
      builder: (context) => Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
