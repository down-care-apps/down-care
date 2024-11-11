import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SyndromeTypeCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  const SyndromeTypeCard({super.key, required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.2),
            spreadRadius: 0.5,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: imageUrl.startsWith('http') || imageUrl.startsWith('https')
                ? Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    imageUrl,
                    width: double.infinity,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: GoogleFonts.leagueSpartan(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
