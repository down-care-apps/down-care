import 'package:down_care/utils/transition.dart';
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
  void initState() {
    super.initState();
    // Fetch kids data after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KidsProvider>().fetchKids();
    });
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Tidak ada data anak',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer<KidsProvider>(
        builder: (context, kidsProvider, child) {
          // Handle loading state
          if (kidsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (kidsProvider.error != null) {
            return Center(
              child: Text(
                'Error: ${kidsProvider.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // Handle empty state
          if (kidsProvider.kidsList.isEmpty) {
            return _buildEmptyState();
          }

          // Build list of kids
          return _buildKidsList(kidsProvider);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(createRoute(const KidAddScreen())),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Profil Anak', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.primary),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildKidsList(KidsProvider kidsProvider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: kidsProvider.kidsList.length,
      itemBuilder: (context, index) {
        final kid = kidsProvider.kidsList[index];
        return KidsCard(
          id: kid.id.toString(),
          name: kid.name,
          age: '${kid.age} tahun',
          imageUrl: 'https://example.com/default_image.jpg',
        );
      },
    );
  }
}
