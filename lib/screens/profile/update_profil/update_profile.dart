import 'package:down_care/main.dart';
import 'package:down_care/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:down_care/widgets/input_field.dart';
import 'package:down_care/widgets/custom_button.dart';
import 'package:down_care/widgets/avatar_picker.dart';
import 'package:down_care/api/user_api.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userData = await UserService().getCurrentUserData();
    setState(() {
      usernameController.text = userData['displayName'] ?? 'Unknown User';
      emailController.text = userData['email'] ?? '';
      phoneController.text = userData['phoneNumber'] ?? '+62';
    });
  }

  Future<void> _updateProfile(String email, String name, String phoneNumber) async {
    email = emailController.text;
    name = usernameController.text;
    phoneNumber = phoneController.text;

    try {
      await UserService().updateUser(email, name, phoneNumber);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully'), backgroundColor: Colors.green),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Perbarui Profil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const AvatarPicker(),
                  const SizedBox(height: 16),
                  InputField(
                    labelText: 'Nama Lengkap',
                    controller: usernameController,
                  ),
                  const SizedBox(height: 16),
                  InputField(
                    labelText: 'Email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  InputField(
                    labelText: 'Nomor Telepon',
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              text: 'Update Profile',
              onPressed: () {
                // Handle the update profile logic here
                _updateProfile(emailController.text, usernameController.text, phoneController.text);
              },
            ),
          ),
        ],
      ),
    );
  }
}
