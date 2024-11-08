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
      phoneController.text = userData['phoneNumber'] ?? '';
    });
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
