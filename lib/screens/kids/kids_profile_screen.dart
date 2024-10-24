import 'package:flutter/material.dart';
import 'package:down_care/widgets/card_kids.dart';
import './kids_add_screen.dart';

class KidsProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Anak',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2260FF),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  KidsCard(
                    name: 'Anavel Michael',
                    profession: 'Professional Doctor',
                    age: '9 Bulan',
                    imageUrl:
                        'https://example.com/image.jpg', // Replace with the actual image URL
                  ),
                  // Add more KidsCard widgets as needed
                  KidsCard(
                    name: 'Clorine Midae',
                    profession: 'Professional Doctor',
                    age: '2 Tahun',
                    imageUrl:
                        'https://example.com/image2.jpg', // Replace with another image URL
                  ),
                  KidsCard(
                    name: 'Alita Brentford',
                    profession: 'Professional Doctor',
                    age: '4 Tahun',
                    imageUrl:
                        'https://example.com/image2.jpg', // Replace with another image URL
                  ),
                ],
              ),
            ),
            // Button "Tambah" at the bottom
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KidAddScreen(),
                        ),
                      );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2260FF), // Button background color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 54.0,
                      vertical: 16.0), // Adjust button padding
                ),
                child: const Text(
                  'Tambah',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Button text color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
