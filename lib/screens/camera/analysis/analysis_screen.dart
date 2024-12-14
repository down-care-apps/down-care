import 'dart:io';
import 'package:camera/camera.dart';
import 'package:down_care/providers/scan_history_provider.dart';
import 'package:down_care/screens/camera/analysis/error_message.dart';
import 'package:down_care/screens/camera/analysis/loading_indicator.dart';
import 'package:down_care/screens/camera/analysis/result_card.dart';
import 'package:down_care/widgets/bottom_navbar.dart';
import 'package:down_care/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:down_care/providers/kids_provider.dart';
import 'package:down_care/widgets/kids_modal.dart';
import 'package:down_care/api/image_camera_services.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final XFile image;

  const DisplayPictureScreen({super.key, required this.imagePath, required this.image});

  @override
  DisplayPictureScreenState createState() => DisplayPictureScreenState();
}

class DisplayPictureScreenState extends State<DisplayPictureScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _percentage = 0.0;
  String? _landmarkUrl;
  bool _isLoading = true;
  String? _errorMessage;
  String? _firebaseUrl;
  Map<String, dynamic>? _resultScan;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fetchAnalysisResult();
  }

  Future<void> _fetchAnalysisResult() async {
    try {
      final Map<String, dynamic>? scanImage = await _savedImage();
      print('Scan Image Response: $scanImage');
      if (scanImage != null && scanImage['resultScan']['confidence'] != null) {
        _firebaseUrl = scanImage['firebaseUrl'];
        _resultScan = scanImage['resultScan'];

        // Extract label and confidence dynamically
        final String detectedLabel = scanImage['resultScan']['label'].toLowerCase().replaceAll(' ', '_'); // Normalize label for key lookup
        final double targetPercentage = double.parse(scanImage['resultScan']['confidence'][detectedLabel].toString());
        final String? landmarkUrl = scanImage['resultScan']['landmarks_url'];

        setState(() {
          _landmarkUrl = landmarkUrl;
          _animation = Tween<double>(begin: 0, end: targetPercentage).animate(_controller)
            ..addListener(() {
              setState(() {
                _percentage = _animation.value * 100;
              });
            });
        });

        _controller.forward(from: 0.0);
      } else {
        throw Exception("Respon dari layanan analisis tidak valid");
      }
    } catch (e) {
      setState(() {
        _errorMessage = "$e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>?> _savedImage() async {
    try {
      final File savedFile = await ImageCameraServices().saveImageLocally(widget.image);
      final String? firebaseUrl = await ImageCameraServices().uploadToFirebaseStorage(savedFile);

      if (firebaseUrl != null) {
        final Map<String, dynamic> resultScan = await ImageCameraServices().uploadImageToMachineLearning(firebaseUrl);
        return {'resultScan': resultScan, 'firebaseUrl': firebaseUrl};
      } else {
        throw Exception("Gagal mengunggah gambar ke Firebase");
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Analisis', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.of(context).pop()),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'Sedang memproses gambar Anda...')
          : _errorMessage != null
              ? ErrorMessage(error: _errorMessage!)
              : Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: ResultCard(
                        label: _resultScan!['label'],
                        landmarkUrl: _landmarkUrl ?? '',
                        imagePath: widget.imagePath,
                        percentage: _percentage,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomButton(
                          text: 'Simpan',
                          onPressed: () => _showKidsProfileModal(context, _firebaseUrl!, _resultScan!),
                          widthFactor: 1.0,
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  void _showKidsProfileModal(BuildContext context, String firebaseUrl, Map<String, dynamic> resultScan) async {
    final kidsProvider = Provider.of<KidsProvider>(context, listen: false);
    final scanHistoryProvider = Provider.of<ScanHistoryProvider>(context, listen: false);

    // Fetch kids data if not already loaded
    if (kidsProvider.kidsList.isEmpty && !kidsProvider.isLoading) {
      await kidsProvider.fetchKids();
    }

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Consumer<KidsProvider>(
          builder: (context, kidsProvider, child) {
            if (kidsProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (kidsProvider.error != null) {
              return Center(
                child: Text(
                  'Error: ${kidsProvider.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final childrens = kidsProvider.kidsList;
            if (childrens.isEmpty) {
              return const Center(
                child: Text(
                  'Tidak ada data anak',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return KidsProfileModal(
              onSelectChild: (child) async {
                await ImageCameraServices().uploadImageToServer(firebaseUrl, resultScan, child['id']);

                // Refresh scan history after saving the analysis data
                await scanHistoryProvider.refreshScanHistory();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottomNavBar(initialIndex: 1),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
