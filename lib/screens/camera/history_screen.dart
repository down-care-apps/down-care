import 'package:flutter/material.dart';
import 'package:down_care/screens/camera/camera_screen.dart'; // Import CameraScreen to navigate to it
import 'package:camera/camera.dart'; // Import the camera package
import 'package:down_care/widgets/scan_history_card.dart'; // Import ScanHistoryCard

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  void _openCamera() async {
    try {
      // Get a list of available cameras
      final cameras = await availableCameras();

      // Select the first camera
      final firstCamera = cameras.first;

      // Navigate to TakePictureScreen, passing the first camera
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

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: const [
          ScanHistoryCard(
            name: 'Scan 1',
            date: '2023-01-01',
            result: 'Positive',
            thumbnailUrl: 'https://via.placeholder.com/100',
          ),
          ScanHistoryCard(
            name: 'Scan 2',
            date: '2023-01-02',
            result: 'Negative',
            thumbnailUrl: 'https://via.placeholder.com/100',
          ),
          // Add more ScanHistoryCard widgets here
        ],
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
