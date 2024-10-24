import 'package:flutter/material.dart';

class KidDetailScreen extends StatelessWidget {
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
                const Text('Brahma Wijaya', style: TextStyle(color: Color(0xFF2260FF)),),
                const SizedBox(height: 16.0),
                Container(
                    height: 362,
                    width: 362,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                        bottom:
                            BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                        right:
                            BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                        left:
                            BorderSide(width: 1.0, color: Color(0xFFFF000000)),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: const Padding(
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
                              SizedBox(height: 4.0),
                              Text('2 Tahun'),
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
                              Text('25 Maret 2022'),
                            ]))),
              ],
            ),
          ),
        ));
  }
}
