import 'package:down_care/widgets/form_kids.dart';
import 'package:flutter/material.dart';
import 'package:down_care/api/childrens_service.dart';
// ignore_for_file: use_build_context_synchronously

class KidEditScreen extends StatefulWidget {
  final String id;

  const KidEditScreen({super.key, required this.id});

  @override
  _KidEditScreenState createState() => _KidEditScreenState();
}

class _KidEditScreenState extends State<KidEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final ChildrensService childrensService = ChildrensService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String? gender;
  final TextEditingController birthDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchChildrenData(widget.id);
  }

  Future<void> _fetchChildrenData(String id) async {
    final childrenData = await childrensService.getChildrenById(id);
    setState(() {
      nameController.text = childrenData['name'] ?? 'Unknown Name';
      weightController.text = (childrenData['weight'] ?? 0).toString();
      heightController.text = (childrenData['height'] ?? 0).toString();
      gender = childrenData['gender'] ?? 'Laki-laki';
      birthDateController.text = childrenData['dateBirthday'] ?? '01-01-2021';
    });
  }

  Future<void> _updateProfileChildren() async {
    final id = widget.id;
    final name = nameController.text;
    final weight = weightController.text;
    final height = heightController.text;
    final gender = this.gender;
    final dateBirthday = birthDateController.text;

    try {
      await childrensService.updateProfileChildren(id, name, weight, height, gender, dateBirthday);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil anak berhasil diperbarui'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile children: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profil Anak', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
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
          onSave: _updateProfileChildren,
        ),
      ),
    );
  }
}
