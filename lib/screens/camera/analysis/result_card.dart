import 'dart:io';
import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String landmarkUrl;
  final String imagePath;
  final double percentage;
  final String label;

  const ResultCard({
    super.key,
    required this.landmarkUrl,
    required this.imagePath,
    required this.percentage,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Image Container with Gradient Overlay
        Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: screenHeight * 0.4,
            width: screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  landmarkUrl.isNotEmpty
                      ? Image.network(
                          landmarkUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                        ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Result Details Container
        Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Result Title
                Text(
                  'Probabilitas Hasil Analisis',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 15),

                // Detected Label
                Text(
                  label,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 15),

                // Confidence Percentage
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Confidence: ${percentage.toStringAsFixed(2)}%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Disclaimer
                Text(
                  '*Hasil ini berdasarkan model probabilitas dan bukan diagnosis pasti.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
