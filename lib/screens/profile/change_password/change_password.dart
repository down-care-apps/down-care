import 'package:flutter/material.dart';
import 'package:down_care/widgets/input_field.dart';
import 'package:down_care/widgets/custom_button.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmNewPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ubah Kata Sandi'),
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
                  InputField(
                    labelText: 'Kata Sandi Saat Ini',
                    controller: currentPasswordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),
                  InputField(
                    labelText: 'Kata Sandi Baru',
                    controller: newPasswordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),
                  InputField(
                    labelText: 'Konfirmasi Kata Sandi Baru',
                    controller: confirmNewPasswordController,
                    isPassword: true,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              text: 'Ubah Kata Sandi',
              onPressed: () {
                // Handle change password logic here
              },
            ),
          ),
        ],
      ),
    );
  }
}
