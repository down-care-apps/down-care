import 'package:down_care/api/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:down_care/widgets/input_field.dart';
import 'package:down_care/widgets/custom_button.dart';
// ignore_for_file: use_build_context_synchronously

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();

    void deleteAccount() async {
      final password = passwordController.text;

      if (password.isEmpty) {
        // Show an error message if password is empty
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kata sandi tidak boleh kosong')),
        );
        return;
      }

      try {
        // Call the deleteAccount method here

        await AuthService().deleteAccount(password);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Akun berhasil dihapus')),
        );

        // Navigate to the home
        if (context.mounted) {
          Navigator.popUntil(context, ModalRoute.withName('/'));
        }
      } catch (e) {
        // Handle any errors during account deletion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Hapus Akun', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
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
                  const Text(
                    'Peringatan: Menghapus akun Anda akan menghapus semua data Anda secara permanen dan tidak dapat dikembalikan.',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  InputField(
                    labelText: 'Kata Sandi',
                    controller: passwordController,
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
              text: 'Hapus Akun',
              onPressed: deleteAccount,
            ),
          ),
        ],
      ),
    );
  }
}
