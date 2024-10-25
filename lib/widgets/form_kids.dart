import 'package:flutter/material.dart';

class KidsForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  KidsForm({required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        children: [
          const Text(
            'Nama Lengkap',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color(0xFFECF1FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukan nama';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Umur',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color(0xFFECF1FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukan Umur';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Jenis Kelamin',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color(0xFFECF1FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukan jenis kelamin';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Tinggi Badan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color(0xFFECF1FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukan Tinggi Badan';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Berat Badan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color(0xFFECF1FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukan Berat Badan';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Tanggal Lahir',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color(0xFFECF1FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukan Tanggal Lahir';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
