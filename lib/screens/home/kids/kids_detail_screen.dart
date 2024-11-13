import 'package:down_care/api/childrens_service.dart';
import 'package:down_care/screens/home/kids/kids_profile_screen.dart';
import 'package:flutter/material.dart';
import 'kids_edit_screen.dart';

class KidDetailScreen extends StatefulWidget {
  final String id;

  KidDetailScreen({required this.id});

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
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await childrensService.deleteProfileChildren(widget.id);
                Navigator.of(context).pop(); // Close dialog

                // Return to profile screen with refresh flag
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
      appBar: AppBar(
        title: const Text(
          'Detail Profil Anak',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2260FF),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureChild,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          final childData = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('https://example.com/default_image.jpg'),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    childData['name'] ?? 'Unnamed Child',
                    style: const TextStyle(color: Color(0xFF2260FF)),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    height: 362,
                    width: 362,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Jenis Kelamin',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4.0),
                              Text(childData['gender'] ?? 'N/A'),
                              const SizedBox(height: 8.0),
                              const Text(
                                'Umur',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4.0),
                              Text('${childData['age'] ?? 'N/A'} Tahun'),
                              const SizedBox(height: 8.0),
                              const Text(
                                'Tinggi Badan',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4.0),
                              Text('${childData['height'] ?? 'N/A'} cm'),
                              const SizedBox(height: 8.0),
                              const Text(
                                'Berat Badan',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4.0),
                              Text('${childData['weight'] ?? 'N/A'} Kg'),
                              const SizedBox(height: 8.0),
                              const Text(
                                'Tanggal Lahir',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4.0),
                              Text(childData['dateBirthday'].toString()),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 8.0,
                          top: 8.0,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: _navigateToEditScreen,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(context);
                                },
                              ),
                            ],
                          ),
                        )
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
}
