import 'package:down_care/api/childrens_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:down_care/models/scan_history.dart';
import 'package:provider/provider.dart';
import 'package:down_care/providers/scan_history_provider.dart';
// ignore_for_file: use_build_context_synchronously

class HistoryDetailPage extends StatelessWidget {
  final ScanHistory scanHistory;

  const HistoryDetailPage({
    super.key,
    required this.scanHistory,
  });

  Future<String> _fetchChildrenName(String childrenId) async {
    if (childrenId.isEmpty) {
      return 'Foto ini belum disimpan pada anak';
    }
    final children = await ChildrensService().getChildrenById(childrenId);
    return children['name'] ?? 'Unknown';
  }

  Widget _buildChildrenName(String childrenId) {
    return FutureBuilder<String>(
      future: _fetchChildrenName(childrenId),
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          return const Text(
            'Foto ini belum disimpan pada anak',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          );
        }
        return Text(
          snapshot.data!,
          style: GoogleFonts.leagueSpartan(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Parse the result to an integer and handle any parsing errors gracefully
    int resultValue = int.tryParse(scanHistory.result.replaceAll('%', '')) ?? 0;

    // Calculate the color based on the result percentage (0 = green, 100 = red)
    Color resultColor = Color.lerp(Colors.green, Colors.red, resultValue / 100)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          scanHistory.name,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Theme.of(context).colorScheme.primary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _showDeleteConfirmationDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  scanHistory.thumbnailUrl,
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.4,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Tanggal:',
                style: GoogleFonts.leagueSpartan(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Text(
              scanHistory.date,
              style: GoogleFonts.leagueSpartan(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Nama Anak:',
                style: GoogleFonts.leagueSpartan(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),
            _buildChildrenName(scanHistory.childrenId),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Hasil:',
                style: GoogleFonts.leagueSpartan(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Text(
              '${scanHistory.result}%',
              style: GoogleFonts.leagueSpartan(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: resultColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Hapus Scan',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus scan ini? Tindakan ini tidak dapat dibatalkan.',
            style: GoogleFonts.inter(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Batal',
                style: GoogleFonts.inter(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                'Hapus',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              onPressed: () {
                _deleteScan(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteScan(BuildContext context) async {
    final provider = Provider.of<ScanHistoryProvider>(context, listen: false);

    try {
      await provider.deleteScan(scanHistory.id);

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Scan berhasil dihapus',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context)
        ..pop() // Close the dialog
        ..pop(); // Go back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menghapus scan: ${e.toString()}',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
