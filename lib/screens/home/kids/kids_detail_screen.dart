import 'package:down_care/api/childrens_service.dart';
import 'package:flutter/material.dart';
import 'kids_edit_screen.dart';

class KidDetailScreen extends StatelessWidget {
  final String id; // Child ID passed from the previous screen

  KidDetailScreen({required this.id}); // Constructor to accept the ID

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
                Navigator.of(context).pop(); // Menutup modal
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
              onPressed: () {
                // Lakukan penghapusan data di sini
                Navigator.of(context).pop(); // Menutup modal
                // Aksi setelah profil dihapus
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Profil telah dihapus'),
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
      body: FutureBuilder<List<dynamic>>(
        future: ChildrensService().getChildrenById(id), // Fetching data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error message
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found')); // No data message
          }

          // Assuming the data is in the first element of the list
          final childData = snapshot.data![0];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(childData['imageUrl'] ?? 'https://example.com/default_image.jpg'), // Use imageUrl from the fetched data
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
                              Text(
                                'Jenis Kelamin',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4.0),
                              Text(childData['gender'] ?? 'N/A'),
                              SizedBox(height: 8.0),
                              Text(
                                'Umur',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4.0),
                              Text('${childData['age'] ?? 'N/A'} Tahun'),
                              SizedBox(height: 8.0),
                              Text(
                                'Tinggi Badan',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4.0),
                              Text('${childData['height'] ?? 'N/A'} cm'),
                              SizedBox(height: 8.0),
                              Text(
                                'Berat Badan',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4.0),
                              Text('${childData['weight'] ?? 'N/A'} Kg'),
                              SizedBox(height: 8.0),
                              Text(
                                'Tanggal Lahir',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4.0),
                              Text(childData['dateBirthday'].toString() ?? 'N/A'),
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
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => KidEditScreen(id: id,),
                                    ),
                                  );
                                },
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
