import 'package:down_care/api/childrens_service.dart';
import 'package:down_care/screens/home/kids/kids_profile_screen.dart';
import 'package:flutter/material.dart';
import 'kids_edit_screen.dart';

class KidDetailScreen extends StatefulWidget {
  final String id;

  const KidDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  _KidDetailScreenState createState() => _KidDetailScreenState();
}

class _KidDetailScreenState extends State<KidDetailScreen> {
  final ChildrensService childrensService = ChildrensService();
  late Future<Map<String, dynamic>> futureChild;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      futureChild = childrensService.getChildrenById(widget.id);
    });
  }

  Future<void> _navigateToEditScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KidEditScreen(id: widget.id),
      ),
    );

    if (result == true) {
      _refreshData();
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Profil Anak'),
          content: const Text('Apakah kamu yakin ingin menghapus profil ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await childrensService.deleteProfileChildren(widget.id);
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => KidsProfileScreen()),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profil Anak telah dihapus'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Detail Profil Anak', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.grey.shade700),
            onPressed: _navigateToEditScreen,
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red.shade400),
            onPressed: () => _showDeleteConfirmationDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureChild,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue.shade300,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red.shade400),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          final childData = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Avatar with Soft Shadow
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue.shade50,
                    backgroundImage: NetworkImage(
                      childData['profileImage'] ?? 'https://example.com/default_image.jpg',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name with Modern Typography
                  Text(
                    childData['name'] ?? 'Unnamed Child',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Details Card with Glassmorphic Effect
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade100, width: 1),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow('Jenis Kelamin', childData['gender'] ?? 'N/A'),
                        _buildDivider(),
                        _buildDetailRow('Umur', '${childData['age'] ?? 'N/A'} Tahun'),
                        _buildDivider(),
                        _buildDetailRow('Tinggi Badan', '${childData['height'] ?? 'N/A'} cm'),
                        _buildDivider(),
                        _buildDetailRow('Berat Badan', '${childData['weight'] ?? 'N/A'} Kg'),
                        _buildDivider(),
                        _buildDetailRow('Tanggal Lahir', childData['dateBirthday'].toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

// Minimalist Detail Row with Modern Styling
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade900,
            ),
          ),
        ],
      ),
    );
  }

// Subtle Divider with Soft Color
  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey.shade200,
      indent: 20,
      endIndent: 20,
    );
  }
}
