import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tentang Aplikasi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tentang Down Care',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Down Care adalah aplikasi yang dirancang untuk membantu pengguna dalam mengelola kesehatan mental mereka. Aplikasi ini menyediakan berbagai fitur seperti pelacakan suasana hati, meditasi, dan tips kesehatan mental.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              const Text(
                'FAQ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('Apa itu Down Care?'),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Down Care adalah aplikasi yang dirancang untuk membantu pengguna dalam mengelola kesehatan mental mereka.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('Bagaimana cara menggunakan aplikasi ini?'),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Anda dapat menggunakan aplikasi ini dengan mendaftar dan mengikuti panduan yang tersedia di dalam aplikasi.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('Apakah data saya aman?'),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Ya, kami memastikan bahwa data Anda aman dan tidak akan dibagikan kepada pihak ketiga tanpa izin Anda.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Kebijakan Privasi',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Kami menghargai privasi Anda dan berkomitmen untuk melindungi data pribadi Anda. Informasi lebih lanjut tentang kebijakan privasi kami dapat ditemukan di situs web kami.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
