import 'package:camera/camera.dart';
import 'package:down_care/api/childrens_service.dart';
import 'package:down_care/api/image_camera_services.dart';
import 'package:down_care/screens/camera/history_screen.dart';
import 'package:down_care/widgets/kids_modal.dart';
import 'package:down_care/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'dart:io';

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

      if (scanImage != null && scanImage['confidence'] != null) {
        final double targetPercentage = double.parse(scanImage['confidence']['down_syndrome'].toString());
        final String? landmarkUrl = scanImage['landmarks_url'];

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
        _errorMessage = "Terjadi kesalahan: $e";
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
        await ImageCameraServices().uploadImageToServer(firebaseUrl, resultScan);
        return resultScan;
      } else {
        throw Exception("Gagal mengunggah gambar ke Firebase");
      }
    } catch (e) {
      throw Exception("Kesalahan saat menyimpan gambar: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color secondaryColor = primaryColor.withOpacity(0.7);

    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hasil Analisis',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 2,
      ),
      body: _isLoading
          ? Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 8.0,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Sedang memproses gambar Anda...',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Harap tunggu, proses analisa berlangsung selama beberapa detik',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 80, color: Colors.red),
                      const SizedBox(height: 20),
                      Text(
                        'Terjadi Kesalahan',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.black, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: _landmarkUrl != null
                                  ? Image.network(
                                      _landmarkUrl!,
                                      fit: BoxFit.cover,
                                      height: screenHeight * 0.4,
                                      width: double.infinity,
                                    )
                                  : Image.file(
                                      File(widget.imagePath),
                                      fit: BoxFit.cover,
                                      height: screenHeight * 0.4,
                                      width: double.infinity,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Probabilitas Hasil Analisis',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Kemungkinan Down Syndrome: ${_percentage.toStringAsFixed(2)}%',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  '*Hasil ini berdasarkan model probabilitas dan bukan diagnosis pasti.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomButton(
                          text: 'Simpan',
                          onPressed: () {
                            _showKidsProfileModal(context);
                          },
                          widthFactor: 1.0,
                          color: primaryColor,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  void _showKidsProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              KidsProfileModal(
                fetchChildrens: () async {
                  final childrens = await ChildrensService().getAllChildrens();
                  return childrens.map((item) => item as Map<String, dynamic>).toList();
                },
                onSelectChild: (child) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HistoryPage()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
