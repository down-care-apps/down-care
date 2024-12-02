import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/kids_provider.dart';

class KidAddScreen extends StatefulWidget {
  const KidAddScreen({super.key});

  @override
  KidAddScreenState createState() => KidAddScreenState();
}

class KidAddScreenState extends State<KidAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String? gender;
  final TextEditingController birthDateController = TextEditingController();

  void _saveKid() {
    if (_formKey.currentState!.validate()) {
      final newKid = {
        'name': nameController.text,
        'weight': weightController.text,
        'height': heightController.text,
        'gender': gender,
        'dateBirthday': birthDateController.text,
      };

      Provider.of<KidsProvider>(context, listen: false).addKid(newKid).then((_) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Profil Anak'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextFormField(
              controller: weightController,
              decoration: const InputDecoration(labelText: 'Berat Badan'),
            ),
            TextFormField(
              controller: heightController,
              decoration: const InputDecoration(labelText: 'Tinggi Badan'),
            ),
            DropdownButtonFormField<String>(
              value: gender,
              items: const [
                DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
                DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
              ],
              onChanged: (value) => setState(() => gender = value),
              decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
            ),
            TextFormField(
              controller: birthDateController,
              decoration: const InputDecoration(labelText: 'Tanggal Lahir'),
            ),
            ElevatedButton(
              onPressed: _saveKid,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
