import 'package:down_care/api/childrens_service.dart';
import 'package:down_care/screens/home/kids/kids_profile_screen.dart';
import 'package:flutter/material.dart';
import '../../../widgets/form_kids.dart';
import 'kids_detail_screen.dart';

class KidEditScreen extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();
  final String id;

  KidEditScreen({required this.id});

  @override
  _KidEditScreenState createState() => _KidEditScreenState();
}

class _KidEditScreenState extends State<KidEditScreen> {
  final ChildrensService childrensService = ChildrensService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String? genderController;
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
      genderController = childrenData['gender'] ?? 'Laki-laki';
      birthDateController.text = childrenData['dateBirthday'] ?? '01-01-2021';
    });
  }

  Future<void> _updateProfileChildren(String id) async {
    final id = widget.id;
    final name = nameController.text;
    final weight = weightController.text;
    final height = heightController.text;
    final gender = genderController;
    final dateBirthday = birthDateController.text;

    try {
      final childrenData = await childrensService.updateProfileChildren(id, name, weight, height, gender, dateBirthday);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil anak berhasil diperbarui'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => KidDetailScreen(id:id)));
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
        title: const Text(
          'Edit Profil Anak',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2260FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Expanded(
              child: KidsForm(
                  formKey: widget._formKey,
                  nameController: nameController,
                  weightController: weightController,
                  heightController: heightController,
                  genderController: genderController,
                  onGenderChanged: (value) {
                    setState(() {
                      genderController = value;
                    });
                  },
                  birthDateController: birthDateController),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () {
                  _updateProfileChildren(widget.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2260FF), // Button background color
                  padding: const EdgeInsets.symmetric(horizontal: 54.0, vertical: 16.0), // Adjust button padding
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Button text color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
