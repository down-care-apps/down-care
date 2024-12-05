import 'package:down_care/models/children_model.dart';
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
      final newKid = ChildrenModel(
        id: UniqueKey().toString(),
        name: nameController.text,
        weight: weightController.text,
        height: heightController.text,
        gender: gender ?? '',
        dateBirthday: birthDateController.text,
        age: '',
      );

      Provider.of<KidsProvider>(context, listen: false).addKid(newKid).then((_) {
        Navigator.pop(context, true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Profil Anak',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  controller: nameController,
                  label: 'Nama Anak',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama anak tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: weightController,
                  label: 'Berat Badan (kg)',
                  icon: Icons.monitor_weight,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Berat badan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: heightController,
                  label: 'Tinggi Badan (cm)',
                  icon: Icons.height,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tinggi badan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildGenderDropdown(),
                const SizedBox(height: 16),
                _buildDatePickerField(),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveKid,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Simpan Profil',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: gender,
      decoration: InputDecoration(
        labelText: 'Jenis Kelamin',
        prefixIcon: Icon(Icons.person_outline, color: Colors.blue[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
        ),
      ),
      dropdownColor: Colors.white, // Background color of dropdown
      style: TextStyle(
        color: Colors.black87,
        fontSize: 16,
      ),
      items: [
        DropdownMenuItem(
          value: 'Laki-laki',
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.blue[50],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.male,
                  color: Colors.blue[600],
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  'Laki-laki',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        DropdownMenuItem(
          value: 'Perempuan',
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.pink[50],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.female,
                  color: Colors.pink[600],
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  'Perempuan',
                  style: TextStyle(
                    color: Colors.pink[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      onChanged: (value) => setState(() => gender = value),
      validator: (value) {
        if (value == null) {
          return 'Pilih jenis kelamin';
        }
        return null;
      },
      isExpanded: true, // Makes dropdown take full width
      iconSize: 30, // Increases dropdown icon size
      icon: Icon(
        Icons.arrow_drop_down_circle,
        color: Colors.blue[600],
      ),
    );
  }

  Widget _buildDatePickerField() {
    return TextFormField(
      controller: birthDateController,
      decoration: InputDecoration(
        labelText: 'Tanggal Lahir',
        prefixIcon: Icon(Icons.calendar_today, color: Colors.blue[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
        ),
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() {
            birthDateController.text = "${picked.day}/${picked.month}/${picked.year}";
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Tanggal lahir tidak boleh kosong';
        }
        return null;
      },
    );
  }
}
