import 'package:flutter/material.dart';

class KidsForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  String? genderController;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final TextEditingController birthDateController;
  final Function(String?) onGenderChanged;

  KidsForm({
    required this.formKey,
    required this.nameController,
    required this.genderController,
    required this.heightController,
    required this.weightController,
    required this.birthDateController,
    required this.onGenderChanged,
  });
  @override
  _KidsFormState createState() => _KidsFormState();
}
class _KidsFormState extends State<KidsForm>{
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        children: [
          const Text(
            'Nama Lengkap',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.nameController,
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
            'Jenis Kelamin',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Radio<String>(
                value: 'Laki-laki',
                activeColor: const Color(0xFF2260FF),
                groupValue: widget.genderController,
                onChanged: (value) {
                  setState(() {
                    widget.genderController = value;
                    widget.onGenderChanged(value);
                  });
                },
              ),
              const Text('Laki-laki'),
              Radio<String>(
                value: 'Perempuan',
                activeColor: const Color(0xFF2260FF),
                groupValue: widget.genderController,
                onChanged: (value) {
                  setState(() {
                    widget.genderController = value;
                    widget.onGenderChanged(value);
                  });
                },
              ),
              const Text('Perempuan'),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Tinggi Badan (cm)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.heightController,
            keyboardType: TextInputType.number,
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
            'Berat Badan (kg)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.weightController,
            keyboardType: TextInputType.number,
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
            controller: widget.birthDateController,
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
