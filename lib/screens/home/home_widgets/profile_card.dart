import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String username;
  final String address;
  final String avatarUrl;

  const ProfileCard({
    super.key,
    required this.username,
    required this.address,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(colorScheme),
            const Divider(color: Colors.black, thickness: 2.0),
            _buildLocationRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ColorScheme colorScheme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: colorScheme.secondary,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                username, // Use the passed username
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildActionIcons(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionIcons() {
    return const Row(
      children: [
        Icon(Icons.notifications_active_outlined, color: Colors.blue),
        SizedBox(width: 8.0),
        Icon(Icons.support_agent, color: Colors.blue), // Customer service icon
      ],
    );
  }

  Widget _buildLocationRow() {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.blue),
        const SizedBox(width: 4.0),
        Text(
          address,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}
