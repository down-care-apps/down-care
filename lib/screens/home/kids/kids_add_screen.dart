import 'package:down_care/widgets/form_kids.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../models/children_model.dart';
import '../../../providers/kids_provider.dart';
import '../../../widgets/input_field.dart'; // Assuming InputField is in this location
import '../../../widgets/custom_button.dart'; // Assuming CustomButton is in this location

class KidAddScreen extends StatefulWidget {
  const KidAddScreen({super.key});

  @override
  _KidAddScreenState createState() => _KidAddScreenState();
}

class _KidAddScreenState extends State<KidAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  String? gender;

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

      Provider.of<KidsProvider>(context, listen: false).addKid(newKid).then((_) => Navigator.pop(context, true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Profil Anak', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: KidsForm(
            formKey: _formKey,
            nameController: nameController,
            weightController: weightController,
            heightController: heightController,
            birthDateController: birthDateController,
            gender: gender,
            onGenderChanged: (value) {
              setState(() {
                gender = value;
              });
            },
            onSave: _saveKid,
          ),
        ),
      ),
    );
  }
}
