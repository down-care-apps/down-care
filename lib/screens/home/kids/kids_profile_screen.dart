import 'package:down_care/api/childrens_service.dart';
import 'package:down_care/screens/home/kids/kids_add_screen.dart';
import 'package:down_care/widgets/card_kids.dart';
import 'package:flutter/material.dart';


class KidsProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create a future to fetch all children
    final futureChildren = ChildrensService().getAllChildrens();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Anak',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2260FF),
      ),
      body: FutureBuilder(
        future: futureChildren, // Use the future here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Center loading indicator
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(
              child: Column(
                children: [
                  Text('Tidak ada data anak'), // Show message if no data
                  // "Tambah" button at the bottom
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
                        backgroundColor: const Color(0xFF2260FF), // Button background color
                        padding: const EdgeInsets.symmetric(horizontal: 54.0, vertical: 16.0), // Adjust button padding
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
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}')
            );
          } else {
            List<Map<String, dynamic>> childrens;
            childrens = (snapshot.data as List<dynamic>).map((item) => item as Map<String, dynamic>).toList();

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: childrens.length,
                    itemBuilder: (context, index) {
                      final child = childrens[index];
                      return KidsCard(
                        id: child['id'].toString(),
                        name: child['name'] ?? 'No Name',
                        profession: 'Professional Doctor', // Adjust if dynamic
                        age: child['age'].toString() + ' tahun' ?? 'N/A', // Assuming age is part of your data
                        imageUrl: child['imageUrl'] ?? 'https://example.com/image.jpg', // Replace with actual image URL field
                      );
                    },
                  ),
                ),
                // "Tambah" button at the bottom
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
                      backgroundColor: const Color(0xFF2260FF), // Button background color
                      padding: const EdgeInsets.symmetric(horizontal: 54.0, vertical: 16.0), // Adjust button padding
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
            );
          }
        },
      ),
    );
  }
}