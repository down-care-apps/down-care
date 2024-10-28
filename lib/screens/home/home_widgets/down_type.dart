import 'package:flutter/material.dart';

class DownSyndromeMenu extends StatelessWidget {
  const DownSyndromeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (index) {
          return _buildDownSyndromeCard(context, index, screenSize);
        }),
      ),
    );
  }

  Widget _buildDownSyndromeCard(BuildContext context, int index, Size screenSize) {
    return Expanded(
      child: Container(
        height: screenSize.height * 0.1,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tipe ${index + 1}',
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}