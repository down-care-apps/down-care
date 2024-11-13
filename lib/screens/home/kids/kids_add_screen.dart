import 'package:down_care/api/childrens_service.dart';
import 'package:flutter/material.dart';
import '../../../widgets/form_kids.dart';
import 'kids_profile_screen.dart';

class KidAddScreen extends StatefulWidget {
  @override
  _KidAddScreenState createState() => _KidAddScreenState();
}

class _KidAddScreenState extends State<KidAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final ChildrensService childrensService = ChildrensService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String? genderController; // Make sure to initialize this
  final TextEditingController birthDateController = TextEditingController();

  Future<void> _createProfileChildren() async {
      final name = nameController.text;
      final weight = weightController.text;
      final height = heightController.text;
      final gender = genderController;
      final dateBirthday = birthDateController.text;

      // Ensure gender is not null before proceeding
      if (gender == null || name == null || weight == null || height == null || dateBirthday == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silahkan pilih jenis kelamin'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        await childrensService.createProfileChildren(name, weight, height, gender, dateBirthday);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil anak berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => KidsProfileScreen(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding child profile: ${e}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Profil Anak',
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
                formKey: _formKey,
                nameController: nameController,
                weightController: weightController,
                heightController: heightController,
                genderController: genderController,
                onGenderChanged: (value) {
                  setState(() {
                    genderController = value;
                  });
                },
                birthDateController: birthDateController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: _createProfileChildren,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2260FF),
                  padding: const EdgeInsets.symmetric(horizontal: 54.0, vertical: 16.0),
                ),
                child: const Text(
                  'Tambah',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
