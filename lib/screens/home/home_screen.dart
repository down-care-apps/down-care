import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileCard(),
              QuickMenu(),
              SectionTitle(title: 'Artikel'),
              ArticleCarousel(),
              SectionTitle(title: 'Ketahui Jenis Down Syndrome!'),
              DownSyndromeMenu(),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Name',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Spacer(),
                      Icon(Icons.notifications_active_outlined,
                          color: Colors.blue),
                      SizedBox(width: 8.0),
                      Icon(Icons.support_agent, color: Colors.blue),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.black,
              thickness: 2.0,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, color: Colors.blue),
                  SizedBox(width: 4.0),
                  Text(
                    'Jl. Semanggi Barat 2B, Malang',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickMenu extends StatelessWidget {
  const QuickMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) {
          IconData icon;
          String label;
          switch (index) {
            case 0:
              icon = Icons.history;
              label = 'History';
              break;
            case 1:
              icon = Icons.alarm;
              label = 'Alarm';
              break;
            case 2:
              icon = Icons.map;
              label = 'Map';
              break;
            case 3:
              icon = Icons.logout;
              label = 'Logout';
              break;
            default:
              icon = Icons.menu;
              label = 'Menu';
          }
          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('This menu isn\'t available yet'),
                ),
              );
            },
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: Icon(
                    icon,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(label,
                    style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'League  Spartan',
                        fontWeight: FontWeight.w600)),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class ArticleCarousel extends StatelessWidget {
  const ArticleCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 8.0),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 200.0,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
              child: Text(
                'Article ${index + 1}',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DownSyndromeMenu extends StatelessWidget {
  const DownSyndromeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              height: 80.0, // Set the height of the menu items
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
        }),
      ),
    );
  }
}
