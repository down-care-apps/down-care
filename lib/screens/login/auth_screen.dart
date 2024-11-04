import 'package:flutter/material.dart';
import 'package:down_care/widgets/input_field.dart';
import 'package:down_care/widgets/custom_button.dart';
import 'package:down_care/screens/login/forgot_password.dart';

class AuthScreen extends StatefulWidget {
  final bool isSignIn;

  const AuthScreen({super.key, required this.isSignIn});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  void _validateFields() {
    setState(() {
      emailError = emailController.text.isEmpty ? 'Silakan masukkan email Anda' : null;
      passwordError = passwordController.text.isEmpty ? 'Silakan masukkan kata sandi Anda' : null;
    });

    if (emailError == null && passwordError == null) {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  void _navigateWithoutTransition(BuildContext context, String routeName) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) {
          return routeName == '/signin' ? AuthScreen(isSignIn: true) : AuthScreen(isSignIn: false);
        },
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Widget _buildInputField(String labelText, String hintText, bool isPassword, TextEditingController controller, String? error) {
    return InputField(
      labelText: labelText,
      hintText: hintText,
      isPassword: isPassword,
      controller: controller,
      error: error,
      maxLines: isPassword ? 1 : null, // Ensure maxLines is 1 for password fields
      onChanged: (value) {
        setState(() {
          error = value.isEmpty ? 'Silakan masukkan ${labelText.toLowerCase()}' : null;
        });
      },
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Colors.grey)),
        SizedBox(width: 10),
        Text('atau', style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400)),
        SizedBox(width: 10),
        Expanded(child: Divider(color: Colors.grey)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final title = widget.isSignIn ? 'Masuk' : 'Daftar';
    final welcomeText = widget.isSignIn ? 'Selamat datang kembali!' : 'Daftar';
    final instructionText = widget.isSignIn ? 'Silakan masuk ke akun Anda' : 'Buat Akun Anda';

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 24)),
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
                  SizedBox(height: screenSize.height * 0.01),
                  Text(welcomeText, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 26, fontWeight: FontWeight.w600)),
                  SizedBox(height: screenSize.height * 0.01),
                  Text(instructionText, style: const TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(height: screenSize.height * 0.01),
                  _buildInputField('Email', 'Email', false, emailController, emailError),
                  SizedBox(height: screenSize.height * 0.01),
                  _buildInputField('Password', 'Kata Sandi', true, passwordController, passwordError),
                  if (!widget.isSignIn) ...[
                    SizedBox(height: screenSize.height * 0.02), // Additional height for sign-up
                  ],
                  if (widget.isSignIn) ...[
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                          );
                        },
                        child: const Text('Lupa Kata Sandi?'),
                      ),
                    ),
                  ],
                  SizedBox(height: screenSize.height * 0.01),
                  CustomButton(
                    text: title,
                    widthFactor: 1.0,
                    onPressed: _validateFields,
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  _buildDivider(),
                  SizedBox(height: screenSize.height * 0.01),
                  CustomButton(
                    widthFactor: 1.0,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pendaftaran Google belum tersedia')),
                      );
                    },
                    color: Colors.white,
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                    svgIconPath: 'assets/icon/google.svg',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.isSignIn ? 'Belum punya akun?' : 'Sudah punya akun?', style: const TextStyle(color: Colors.black, fontSize: 16)),
                      TextButton(
                        onPressed: () => _navigateWithoutTransition(context, widget.isSignIn ? '/signup' : '/signin'),
                        child: Text(widget.isSignIn ? 'Daftar' : 'Masuk', style: const TextStyle(color: Colors.blue, fontSize: 16)),
                      ),
                    ],
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
