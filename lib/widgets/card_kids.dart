import 'package:flutter/material.dart';

class KidsCard extends StatelessWidget {
  final String name;
  final String profession;
  final String age;
  final String imageUrl;

  KidsCard({
    required this.name,
    required this.profession,
    required this.age,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.blue, // Blue color for the bottom border
            width: 2.0, // Border thickness
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image/Avatar on the left
            CircleAvatar(
              radius: 30,
              backgroundImage:
                  NetworkImage(imageUrl), // Use imageUrl from parameters
            ),
            const SizedBox(width: 16.0), // Space between avatar and text
            // Information Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row for the icon and title
                  Row(
                    children: [
                      const Icon(Icons.verified,
                          color: Colors.blue), // Your custom icon
                      const SizedBox(width: 5.0),
                      Text(
                        profession,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  // Name and age
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    age,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Info Button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(38.0),
                      ),
                    ),
                    child: const Text(
                      'Info',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            // Calendar Icon on the right
            const Icon(Icons.calendar_today, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}