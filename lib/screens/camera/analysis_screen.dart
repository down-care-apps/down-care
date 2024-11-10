import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/scheduler.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _percentage = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {
          _percentage = _animation.value * 100;
        });
      });

    _fetchAnalysisResult();
  }

  Future<void> _fetchAnalysisResult() async {
    // Placeholder for ML model result
    final result = 100.0; // Replace this with actual ML model result later
    _controller.forward(from: 0.0);
    setState(() {
      _percentage = result;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hasil Analisis',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.4,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.file(File(widget.imagePath), fit: BoxFit.cover, width: double.infinity),
                  ),
                  Center(
                    child: CircularProgressIndicator(
                      value: _animation.value,
                      strokeWidth: 8.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              '${_percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.lerp(Colors.green, Colors.red, _percentage / 100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
