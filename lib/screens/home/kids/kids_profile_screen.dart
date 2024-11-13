import 'package:down_care/api/childrens_service.dart';
import 'package:down_care/screens/home/kids/kids_add_screen.dart';
import 'package:down_care/widgets/card_kids.dart';
import 'package:flutter/material.dart';

class KidsProfileScreen extends StatefulWidget {
  @override
  _KidsProfileScreenState createState() => _KidsProfileScreenState();
}

class _KidsProfileScreenState extends State<KidsProfileScreen> {
  late Future<List<dynamic>> futureChildren;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      futureChildren = ChildrensService().getAllChildrens();
    });
  }

  Future<void> _navigateToAddScreen() async {
    // Wait for the result from KidAddScreen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KidAddScreen(),
      ),
    );

    // Refresh the data when returning from KidAddScreen
    if (result == true) {
      _refreshData();
    }
  }

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
      body: FutureBuilder(
        future: futureChildren,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(
              child: Column(
                children: [
                  Text('Tidak ada data anak'),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ElevatedButton(
                      onPressed: _navigateToAddScreen,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2260FF),
                        padding: const EdgeInsets.symmetric(horizontal: 54.0, vertical: 16.0),
                      ),
                      child: const Text(
                        'Tambah',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
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
                        profession: 'Professional Doctor',
                        age: child['age'].toString() + ' tahun' ?? 'N/A',
                        imageUrl: child['imageUrl'] ?? 'https://example.com/image.jpg',
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: _navigateToAddScreen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2260FF),
                      padding: const EdgeInsets.symmetric(horizontal: 54.0, vertical: 16.0),
                    ),
                    child: const Text(
                      'Tambah',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
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