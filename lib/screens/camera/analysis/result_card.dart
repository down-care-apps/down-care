import 'dart:io';
import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String landmarkUrl;
  final String imagePath;
  final double percentage;

  const ResultCard({
    super.key,
    required this.landmarkUrl,
    required this.imagePath,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: landmarkUrl.isNotEmpty
                ? Image.network(
                    landmarkUrl,
                    fit: BoxFit.cover,
                    height: screenHeight * 0.4,
                    width: double.infinity,
                  )
                : Image.file(
                    File(imagePath),
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
                'Kemungkinan Down Syndrome: ${percentage.toStringAsFixed(2)}%',
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
    );
  }
}
