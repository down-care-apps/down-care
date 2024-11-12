import 'package:flutter/material.dart';
import 'package:down_care/screens/camera/camera_screen.dart';
import 'package:camera/camera.dart';
import 'package:down_care/widgets/scan_history_card.dart';
import 'package:down_care/screens/camera/history_detail_screen.dart';
import 'package:down_care/utils/transition.dart';
import 'package:down_care/models/scan_history.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  void _openCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TakePictureScreen(camera: firstCamera),
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  void _navigateToDetail(ScanHistory scanHistory) {
    Navigator.push(
      context,
      createRoute(HistoryDetailPage(scanHistory: scanHistory)),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ScanHistory> scanHistories = [
      ScanHistory(
        name: 'Scan 1',
        date: '2023-01-01',
        result: '70',
        thumbnailUrl: 'https://via.placeholder.com/100',
      ),
      ScanHistory(
        name: 'Scan 2',
        date: '2023-01-02',
        result: '10',
        thumbnailUrl: 'https://via.placeholder.com/100',
      ),
      // Add more ScanHistory objects as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Pemindaian',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality here
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: scanHistories.length,
        itemBuilder: (context, index) {
          final scanHistory = scanHistories[index];
          return ScanHistoryCard(
            scanHistory: scanHistory,
            onTap: () => _navigateToDetail(scanHistory),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCamera,
        tooltip: 'Open Camera',
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
