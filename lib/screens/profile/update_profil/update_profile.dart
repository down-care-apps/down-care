import 'package:down_care/main.dart';
import 'package:down_care/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:down_care/widgets/input_field.dart';
import 'package:down_care/widgets/custom_button.dart';
import 'package:down_care/widgets/avatar_picker.dart';
import 'package:down_care/providers/user_provider.dart';
import 'package:provider/provider.dart';
// ignore_for_file: use_build_context_synchronously

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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchCurrentUser();
  }

  Future<void> _updateProfile(String email, String name, String phoneNumber) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.updateUser(email, name, phoneNumber);
      final updatedUser = userProvider.user;

      if (updatedUser != null) {
        userProvider.setUser(UserModel(
          id: updatedUser.id,
          displayName: name,
          email: email,
          phoneNumber: phoneNumber,
          photoURL: updatedUser.photoURL,
        ));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully'), backgroundColor: Colors.green),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        throw 'Error: User data is null after update';
      }
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
        elevation: 0,
        title: Text('Perbarui Profil', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;

          // If the user data is null or still loading, show loading indicator
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // Set the controllers with the fetched user data
          usernameController.text = user.displayName;
          emailController.text = user.email;
          phoneController.text = user.phoneNumber;

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // const AvatarPicker(),
                      // const SizedBox(height: 16),
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
                    _updateProfile(emailController.text, usernameController.text, phoneController.text);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
