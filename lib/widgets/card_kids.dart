import 'package:flutter/material.dart';
import '../screens/home/kids/kids_detail_screen.dart';

class KidsCard extends StatelessWidget {
  final String name;
  final String age;
  final String imageUrl;
  final String id;

  const KidsCard({
    super.key,
    required this.id,
    required this.name,
    required this.age,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetails(context),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 16.0),
              _buildKidInfo(context),
              const SizedBox(width: 8.0),
              _buildCalendarIcon(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 30,
      backgroundImage: NetworkImage(imageUrl),
      backgroundColor: Colors.blue.shade50,
    );
  }

  Widget _buildKidInfo(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            age,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarIcon(BuildContext context) {
    return Icon(
      Icons.arrow_forward_ios_rounded,
      color: Colors.black.withOpacity(0.5),
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KidDetailScreen(id: id),
      ),
    );
  }
}
