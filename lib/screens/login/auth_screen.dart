import 'package:down_care/api/auth_service.dart';
import 'package:down_care/api/googleSignIn.dart';
import 'package:down_care/main.dart';
import 'package:down_care/screens/login/forgot_password.dart';
import 'package:down_care/screens/login/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:down_care/widgets/input_field.dart';
import 'package:down_care/widgets/custom_button.dart';

class AuthScreen extends StatefulWidget {
  final bool isSignIn;

  const AuthScreen({super.key, required this.isSignIn});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  String? emailError;
  String? passwordError;
  bool isLoading = false;
  String? errorMessage;
  bool isSignIn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthentication();
    });
  }

// Cek User Authentication
  Future<void> _checkAuthentication() async {
    // Ensure the context is still valid
    if (!mounted) return;

    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user != null) {
      // Ensure navigation is only triggered if the context is valid and not already navigating
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    }
  }

  //Get name from email
  String _extractNameFromEmail(String email) {
    // Split the email by '@' and take the first part
    String namePart = email.split('@')[0];

    // Replace '.' with space and capitalize the first letters
    List<String> nameParts = namePart.split('.');
    String name = nameParts.map((part) => part[0].toUpperCase() + part.substring(1)).join(' ');

    return name;
  }

  //Sign Up with email and password
  Future<void> signUpWithEmailPassword() async {
    final name = _extractNameFromEmail(emailController.text);
    try {
      // Check if the email is already registered
      final isEmailRegistered = await _authService.isEmailRegistered(emailController.text);

      if (isEmailRegistered) {
        emailError = 'Email sudah terdaftar, silahkan gunakan email lain';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email sudah terdaftar, silahkan gunakan email lain'), backgroundColor: Colors.red),
        );
        return; // Exit the method if the email is already registered
      }

      // Proceed with sign-up if email is not registered
      await _authService.signUpWithEmailPassword(emailController.text, passwordController.text, name);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi berhasil, silahkan login')),
      );

      // Handle navigation or further actions if needed
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  // Sign In with email and password
  Future<void> signInWithEmailPassword() async {
    // Reset previous errors
    setState(() {
      emailError = null;
      passwordError = null;
      errorMessage = null;
    });

    // Validate inputs
    if (emailController.text.isEmpty) {
      setState(() => emailError = 'Silakan masukkan email Anda');
      return;
    }
    if (passwordController.text.isEmpty) {
      setState(() => passwordError = 'Silakan masukkan kata sandi Anda');
      return;
    }

    setState(() => isLoading = true);

    try {
      UserCredential userCredential = await _authService.signInWithEmailPassword(
        emailController.text,
        passwordController.text,
      );

      String? idToken = await userCredential.user?.getIdToken();
      if (idToken != null) {
        await _authService.callLoginApi(emailController.text, passwordController.text, idToken);
      }

      setState(() => isSignIn = true);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'invalid-credential':
            emailError = 'Email atau kata sandi salah';
            passwordError = 'Email atau kata sandi salah';
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Email atau kata sandi salah'),
                backgroundColor: Colors.red,
              ),
            );
            break;
          case 'invalid-email':
            emailError = 'Format email tidak valid';
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Format email tidak valid'),
                backgroundColor: Colors.red,
              ),
            );
            break;
          case 'too-many-requests':
            errorMessage = 'Terlalu banyak percobaan login. Silakan coba lagi nanti';
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Terlalu banyak percobaan login. Silakan coba lagi nanti'),
                backgroundColor: Colors.red,
              ),
            );
            break;
          default:
            errorMessage = 'Terjadi kesalahan. Silakan coba lagi';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Terjadi kesalahan: ${e.message}'),
                backgroundColor: Colors.red,
              ),
            );
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan yang tidak terduga';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan yang tidak terduga: $e'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final user = await _googleSignInService.signInWithGoogle();

      if (user != null && mounted) {
        // Navigate to main screen and remove all previous routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal masuk dengan Google'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal masuk dengan Google, $e'),
          backgroundColor: Colors.red,
        ),
      );
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

  Widget _buildInputField(String hintText, bool isPassword, TextEditingController controller, String? error) {
    return InputField(
      hintText: hintText,
      isPassword: isPassword,
      controller: controller,
      error: error,
      maxLines: isPassword ? 1 : null, // Ensure maxLines is 1 for password fields
      onChanged: (value) {
        setState(() {
          error = value.isEmpty ? 'Please enter your ${hintText.toLowerCase()}' : null;
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
                  _buildInputField('Email', false, emailController, emailError),
                  SizedBox(height: screenSize.height * 0.01),
                  _buildInputField('Kata Sandi', true, passwordController, passwordError),
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
                    onPressed: () async {
                      if (widget.isSignIn) {
                        await signInWithEmailPassword();
                      } else {
                        await signUpWithEmailPassword();
                      }
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  _buildDivider(),
                  SizedBox(height: screenSize.height * 0.01),
                  CustomButton(
                    widthFactor: 1.0,
                    onPressed: _signInWithGoogle,
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
