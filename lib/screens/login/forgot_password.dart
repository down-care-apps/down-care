import 'package:flutter/material.dart';
import 'package:down_care/widgets/input_field.dart';
import 'package:down_care/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore_for_file: use_build_context_synchronously

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  String? emailError;
  bool isLoading = false;

  Future<void> _sendPasswordResetEmail() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        emailError = 'Silakan masukkan email Anda';
      });
      return;
    }

    setState(() {
      isLoading = true;
      emailError = null;
    });

    try {
      final result = await resetPassword(email);
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reset password telah dikirim pada email anda.'),
            backgroundColor: Colors.green,
          ),
        );
        // Optionally navigate back
        Navigator.pop(context);
      } else {
        // Show error message
        setState(() {
          emailError = result['message'] == 'No account exists with this email address' ? 'Email tidak terdaftar' : result['message'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(emailError ?? 'Terjadi kesalahan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<Map<String, dynamic>> resetPassword(String email) async {
    final auth = FirebaseAuth.instance;

    try {
      try {
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: 'temporary_password_123',
        );

        await userCredential.user?.delete();

        return {'success': false, 'message': 'No account exists with this email address'};
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          await auth.sendPasswordResetEmail(email: email);
          return {'success': true, 'message': 'Password reset email sent successfully'};
        }

        switch (e.code) {
          case 'invalid-email':
            return {'success': false, 'message': 'Format email tidak valid'};
          case 'too-many-requests':
            return {'success': false, 'message': 'Terlalu banyak permintaan. Silakan coba lagi nanti'};
          default:
            return {'success': false, 'message': 'Terjadi kesalahan: ${e.message}'};
        }
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan yang tidak terduga: $e'};
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lupa Kata Sandi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenSize.height - kToolbarHeight - MediaQuery.of(context).padding.top,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo_blue.png', height: screenSize.height * 0.17),
                  SizedBox(height: screenSize.height * 0.02),
                  Text(
                    'Reset Kata Sandi Anda',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 26, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  const Text(
                    'Masukkan alamat email Anda di bawah ini untuk menerima tautan reset kata sandi.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  InputField(
                    labelText: 'Email',
                    hintText: 'Masukkan email Anda',
                    isPassword: false,
                    controller: emailController,
                    error: emailError,
                    onChanged: (value) {
                      if (emailError != null) {
                        setState(() {
                          emailError = null;
                        });
                      }
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  CustomButton(
                    text: isLoading ? 'Mengirim...' : 'Kirim Tautan Reset',
                    widthFactor: 1.0,
                    onPressed: _sendPasswordResetEmail,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
