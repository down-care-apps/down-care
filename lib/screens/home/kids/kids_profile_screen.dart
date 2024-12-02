import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:down_care/providers/kids_provider.dart';
import 'package:down_care/screens/home/kids/kids_add_screen.dart';
import 'package:down_care/widgets/card_kids.dart';

class KidsProfileScreen extends StatefulWidget {
  const KidsProfileScreen({super.key});

  @override
  _KidsProfileScreenState createState() => _KidsProfileScreenState();
}

class _KidsProfileScreenState extends State<KidsProfileScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Always refetch the data when the screen is loaded
    context.read<KidsProvider>().fetchKids();
  }

  Future<void> _navigateToAddScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KidAddScreen()),
    );
    if (result == true) {
      context.read<KidsProvider>().fetchKids(); // Fetch the updated data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Anak', style: TextStyle(color: Colors.white, fontSize: 24)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<KidsProvider>(
        builder: (context, kidsProvider, child) {
          // Fetch data if it's not already fetched
          if (kidsProvider.kidsList.isEmpty && !kidsProvider.isLoading && kidsProvider.error == null) {
            kidsProvider.fetchKids();
          }

          if (kidsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (kidsProvider.error != null) {
            return Center(
              child: Text(
                'Error: ${kidsProvider.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (kidsProvider.kidsList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Tidak ada data anak'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _navigateToAddScreen(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2260FF),
                      padding: const EdgeInsets.symmetric(horizontal: 54.0, vertical: 16.0),
                    ),
                    child: const Text('Tambah', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: kidsProvider.kidsList.length,
                  itemBuilder: (context, index) {
                    final kid = kidsProvider.kidsList[index];
                    return KidsCard(
                      id: kid['id'].toString(),
                      name: kid['name'] ?? 'No Name',
                      age: '${kid['age'] ?? 'N/A'} tahun',
                      imageUrl: kid['imageUrl'] ?? 'https://example.com/default_image.jpg',
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  onPressed: () => _navigateToAddScreen(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2260FF),
                    padding: const EdgeInsets.symmetric(horizontal: 54.0, vertical: 16.0),
                  ),
                  child: const Text('Tambah', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
