import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:down_care/widgets/input_field.dart';
import 'package:down_care/widgets/custom_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _changePassword() async {
    // Validate input
    if (newPasswordController.text != confirmNewPasswordController.text) {
      _showErrorDialog('Konfirmasi kata sandi baru tidak cocok');
      return;
    }

    if (newPasswordController.text.length < 6) {
      _showErrorDialog('Kata sandi baru harus minimal 6 karakter');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user
      User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        _showErrorDialog('Pengguna tidak terautentikasi');
        return;
      }

      // Re-authenticate the user
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: currentPasswordController.text,
      );

      await currentUser.reauthenticateWithCredential(credential);

      // Change password
      await currentUser.updatePassword(newPasswordController.text);

      // Show success dialog
      _showSuccessDialog('Kata sandi berhasil diubah');

      // Clear controllers
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmNewPasswordController.clear();

    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      String errorMessage = 'Terjadi kesalahan';
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Kata sandi saat ini salah';
          break;
        case 'weak-password':
          errorMessage = 'Kata sandi baru terlalu lemah';
          break;
        case 'requires-recent-login':
          errorMessage = 'Harap login ulang untuk mengubah kata sandi';
          break;
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      _showErrorDialog('Terjadi kesalahan: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kesalahan'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Berhasil'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
                    text: 'Ubah Kata Sandi',
                    onPressed: _changePassword,
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }
}