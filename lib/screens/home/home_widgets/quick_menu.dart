import 'package:flutter/material.dart';

class QuickMenu extends StatelessWidget {
  final Function(int) onMenuTap;

  const QuickMenu({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) {
          return _buildMenuItem(context, index, screenSize);
        }),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, int index, Size screenSize) {
    final icons = [
      Icons.history,
      Icons.alarm,
      Icons.map,
      Icons.logout,
    ];
    final labels = ['History', 'Reminder', 'Map', 'Logout'];

    return GestureDetector(
      onTap: () => onMenuTap(index), // Call the passed callback
      child: Column(
        children: [
          CircleAvatar(
            radius: screenSize.width * 0.08,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Icon(
              icons[index],
              color: Colors.black,
              size: screenSize.width * 0.08,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            labels[index],
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'League Spartan',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
