import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  File? _image;
  CameraLensDirection _cameraLensDirection = CameraLensDirection.back;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == _cameraLensDirection,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
      );

      _initializeControllerFuture = _cameraController!.initialize();
      setState(() {});
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _flipCamera() async {
    setState(() {
      _cameraLensDirection = _cameraLensDirection == CameraLensDirection.back
          ? CameraLensDirection.front
          : CameraLensDirection.back;
    });
    await _initializeCamera();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final path = join(
        (await getApplicationDocumentsDirectory()).path,
        '${DateTime.now()}.png',
      );
      await _cameraController!.takePicture().then((XFile file) {
        file.saveTo(path);
      });
      setState(() {
        _image = File(path);
      });
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initializeControllerFuture == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      SizedBox.expand(
                        child: CameraPreview(_cameraController!),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.flip_camera_ios,
                                    color: Colors.white),
                                onPressed: _flipCamera,
                              ),
                              IconButton(
                                icon: const Icon(Icons.camera,
                                    color: Colors.white),
                                onPressed: _takePicture,
                              ),
                              IconButton(
                                icon: const Icon(Icons.image,
                                    color: Colors.white),
                                onPressed: _uploadImage,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_image != null)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(_image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Center(child: Text("Error initializing camera"));
                }
              },
            ),
    );
  }
}
