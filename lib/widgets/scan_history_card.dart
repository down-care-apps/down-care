import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScanHistoryCard extends StatelessWidget {
  final String name;
  final String date;
  final String result;
  final String thumbnailUrl;

  const ScanHistoryCard({
    super.key,
    required this.name,
    required this.date,
    required this.result,
    required this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white, // Light blue background color
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary, // Border color
          width: 1, // Border width
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: thumbnailUrl.startsWith('assets/')
                ? Image.asset(
                    thumbnailUrl, // Menggunakan gambar dari assets
                    width: 100,
                    height: 75,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    thumbnailUrl, // Jika bukan asset, gunakan Image.network
                    width: 100,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  date,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hasil: $result',
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }
}
