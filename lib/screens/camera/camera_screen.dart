import 'dart:io';

import 'package:down_care/api/image_camera_services.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Import the camera package
import 'package:image_picker/image_picker.dart'; // Import ImagePicker for uploading images
import 'analysis_screen.dart'; // Import the analysis screen
import 'dart:async'; // For Timer
import 'package:flutter_svg/flutter_svg.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({super.key, required this.camera});

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  final ImagePicker _picker = ImagePicker();
  Offset? _tapPosition;
  bool _showFocusIndicator = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Get a list of available cameras
    final cameras = await availableCameras();

    // Find the rear camera
    final rearCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      rearCamera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCamera() async {
    final cameras = await availableCameras();
    final newCamera = cameras.firstWhere(
      (camera) => camera != _controller.description,
      orElse: () => cameras.first,
    );

    setState(() {
      _controller = CameraController(newCamera, ResolutionPreset.medium);
      _initializeControllerFuture = _controller.initialize();
    });
  }

  void _uploadImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(imagePath: pickedFile.path, image: pickedFile,)
        ),
      );
    }
  }

  void _takePicture() async {
    try {
      await _initializeControllerFuture;
      final XFile image = await _controller.takePicture();

      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(imagePath: image.path, image: image,),
        ),
      );
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  void _onTapToFocus(TapDownDetails details, BuildContext context) {
    if (_controller.value.isInitialized) {
      final RenderBox box = context.findRenderObject() as RenderBox;
      final Offset offset = box.globalToLocal(details.globalPosition);
      final double dx = offset.dx / box.size.width;
      final double dy = offset.dy / box.size.height;

      _controller.setFocusPoint(Offset(dx, dy)).catchError((e) {
        print('Error setting focus point: $e');
      });

      setState(() {
        _tapPosition = offset;
        _showFocusIndicator = true;
      });

      // Hide the indicator after a short delay
      Timer(const Duration(seconds: 1), () {
        setState(() {
          _showFocusIndicator = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ambil Gambar',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: _initializeControllerFuture == null
          ? Container(
              color: Colors.black,
            )
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      GestureDetector(
                        onTapDown: (details) => _onTapToFocus(details, context),
                        child: CameraPreview(_controller),
                      ),
                      if (_showFocusIndicator && _tapPosition != null)
                        Positioned(
                          left: _tapPosition!.dx - 25,
                          top: _tapPosition!.dy - 25,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(), // This space is taken by CameraPreview
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: Colors.black,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: _flipCamera,
                                    icon: const Icon(Icons.flip_camera_android, color: Colors.white, size: 36),
                                    tooltip: 'Flip Camera',
                                  ),
                                  IconButton(
                                    onPressed: _takePicture,
                                    icon: const Icon(Icons.circle, color: Colors.white, size: 72),
                                    tooltip: 'Shutter',
                                  ),
                                  IconButton(
                                    onPressed: _uploadImage,
                                    icon: SvgPicture.asset(
                                      'assets/icon/gallery-export.svg',
                                      width: 36,
                                      height: 36,
                                      color: Colors.white, // Optional: apply a color tint if needed
                                    ),
                                    tooltip: 'Upload Image',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  // Otherwise, display a black screen while waiting for initialization.
                  return Container(
                    color: Colors.black,
                  );
                }
              },
            ),
    );
  }
}
