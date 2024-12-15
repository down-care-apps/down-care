import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/custom_button.dart';

class KidsForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController weightController;
  final TextEditingController heightController;
  final TextEditingController birthDateController;
  final String? gender;
  final Function(String?) onGenderChanged;
  final Function() onSave;

  const KidsForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.weightController,
    required this.heightController,
    required this.birthDateController,
    required this.gender,
    required this.onGenderChanged,
    required this.onSave,
  });

  @override
  _KidsFormState createState() => _KidsFormState();
}

class _KidsFormState extends State<KidsForm> {
  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[600]!,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        widget.birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Form(
            key: widget.formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InputField(
                    labelText: 'Nama Anak',
                    hintText: 'Masukkan nama anak',
                    controller: widget.nameController,
                    validator: (value) => value == null || value.isEmpty ? 'Silahkan masukkan nama' : null,
                  ),
                  const SizedBox(height: 16.0),
                  InputField(
                    labelText: 'Berat Badan (kg)',
                    hintText: 'Masukkan berat badan',
                    controller: widget.weightController,
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty ? 'Silahkan masukkan berat badan' : null,
                  ),
                  const SizedBox(height: 16.0),
                  InputField(
                    labelText: 'Tinggi Badan (cm)',
                    hintText: 'Masukkan tinggi badan',
                    controller: widget.heightController,
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty ? 'Silahkan masukkan tinggi badan' : null,
                  ),
                  const SizedBox(height: 16.0),
                  _buildGenderDropdown(),
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: _selectDate,
                    child: AbsorbPointer(
                      child: InputField(
                        labelText: 'Tanggal Lahir',
                        hintText: 'Pilih tanggal lahir',
                        controller: widget.birthDateController,
                        validator: (value) => value == null || value.isEmpty ? 'Silahkan pilih tanggal lahir' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomButton(
            text: 'Simpan',
            onPressed: widget.onSave,
            textColor: Colors.white,
            widthFactor: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Jenis Kelamin',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          value: widget.gender,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(12),
            hintText: 'Pilih Jenis Kelamin',
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.4),
            ),
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 14,
              height: 1.5,
            ),
            errorMaxLines: 2,
          ),
          items: const [
            DropdownMenuItem(
              value: 'Laki-laki',
              child: Text('Laki-laki'),
            ),
            DropdownMenuItem(
              value: 'Perempuan',
              child: Text('Perempuan'),
            ),
          ],
          onChanged: widget.onGenderChanged,
          validator: (value) => value == null ? 'Silahkan pilih jenis kelamin' : null,
        ),
      ],
    );
  }
}
