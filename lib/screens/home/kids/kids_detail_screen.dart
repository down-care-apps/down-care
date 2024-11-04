import 'package:flutter/material.dart';
import 'kids_edit_screen.dart';

class KidDetailScreen extends StatelessWidget {
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
              child: const Text('Hapus', style: TextStyle(color: Colors.white),),
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://example.com/image2.jpg'), // Use imageUrl from parameters
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Brahma Wijaya',
                  style: TextStyle(color: Color(0xFF2260FF)),
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
                        const Padding(
                          padding: EdgeInsets.all(26.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Jenis Kelamin',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.0),
                                Text('Laki-laki'),
                                SizedBox(height: 8.0),
                                Text(
                                  'Umur',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.0),
                                Text('7 Tahun'),
                                SizedBox(height: 8.0),
                                Text(
                                  'Tinggi Badan',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.0),
                                Text('150 cm'),
                                SizedBox(height: 8.0),
                                Text(
                                  'Berat Badan',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.0),
                                Text('35 Kg'),
                                SizedBox(height: 8.0),
                                Text(
                                  'Tanggal Lahir',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.0),
                                Text('25 Maret 2017'),
                              ]),
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
                                      builder: (context) => KidEditScreen(),
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
                    )),
              ],
            ),
          ),
        ));
  }
}
