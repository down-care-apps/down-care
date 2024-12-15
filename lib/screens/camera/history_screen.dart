import 'package:flutter/material.dart';
import 'package:down_care/screens/camera/camera_screen.dart';
import 'package:camera/camera.dart';
import 'package:down_care/widgets/card_scan_history.dart';
import 'package:down_care/screens/camera/history_detail_screen.dart';
import 'package:down_care/utils/transition.dart';
import 'package:down_care/models/scan_history.dart';
import 'package:provider/provider.dart';
import 'package:down_care/providers/scan_history_provider.dart';
import 'package:down_care/widgets/skeleton_scan_history_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    // Fetch scan history when the page is initialized
    final scanHistoryProvider = Provider.of<ScanHistoryProvider>(context, listen: false);
    scanHistoryProvider.fetchScanHistory();
  }

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
      throw Exception('Error opening camera: $e');
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
      body: Consumer<ScanHistoryProvider>(
        builder: (context, scanHistoryProvider, child) {
          // Check loading state
          if (scanHistoryProvider.isLoading) {
            return ListView.builder(
              itemCount: 5, // Display 5 skeleton cards as placeholders
              itemBuilder: (context, index) {
                return const SkeletonScanHistoryCard(); // Show skeleton
              },
            );
          }

          // Check for error state
          if (scanHistoryProvider.errorMessage.isNotEmpty) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Tidak ada riwayat pemindaian tersedia. Silahkan scan gambar terlebih dahulu.',
                ),
              ),
            );
          }

          // If there is scan history data, display it
          if (scanHistoryProvider.scanHistories.isNotEmpty) {
            final scanHistories = scanHistoryProvider.scanHistories;

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: scanHistories.length,
              itemBuilder: (context, index) {
                final scanHistory = scanHistories[index];
                return ScanHistoryCard(
                  scanHistory: scanHistory,
                  onTap: () => _navigateToDetail(scanHistory),
                );
              },
            );
          } else {
            // No data available
            return const Center(
              child: Text('Tidak ada riwayat pemindaian tersedia.'),
            );
          }
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
