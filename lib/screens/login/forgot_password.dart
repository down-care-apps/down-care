import 'package:flutter/material.dart';
import 'package:down_care/widgets/input_field.dart';
import 'package:down_care/widgets/custom_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  String? emailError;

  void _sendPasswordResetEmail() {
    setState(() {
      emailError = emailController.text.isEmpty ? 'Silakan masukkan email Anda' : null;
    });

    if (emailError == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email reset kata sandi telah dikirim!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lupa Kata Sandi', style: TextStyle(color: Colors.white, fontSize: 24)),
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
                      setState(() {
                        emailError = value.isEmpty ? 'Silakan masukkan email Anda' : null;
                      });
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  CustomButton(
                    text: 'Kirim Tautan Reset',
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
