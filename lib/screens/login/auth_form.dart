import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthForm extends StatefulWidget {
  final bool isSignIn;
  final Function(String email, String password) onSubmit;

  const AuthForm({Key? key, required this.isSignIn, required this.onSubmit})
      : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError, _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/logo_blue.png', height: 120),
          const SizedBox(height: 16),
          _buildWelcomeText(),
          const SizedBox(height: 16),
          _buildInputField(_emailController, 'Email', false, _emailError),
          const SizedBox(height: 16),
          _buildInputField(
              _passwordController, 'Password', true, _passwordError),
          if (widget.isSignIn) _buildForgotPasswordButton(),
          const SizedBox(height: 12),
          _buildActionButton(
            title: widget.isSignIn ? 'Sign In' : 'Sign Up',
            onPressed: _validateForm,
          ),
          const SizedBox(height: 10),
          _buildOrDivider(),
          const SizedBox(height: 10),
          _buildActionButton(
            title: 'Google',
            isGoogleSignIn: true,
            onPressed: () =>
                _showSnackBar('Google Sign-In not yet implemented'),
          ),
          _buildAccountSwitchText(),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          widget.isSignIn ? 'Welcome Back' : 'Sign Up',
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 26,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter'),
        ),
        const SizedBox(height: 8),
        Text(
          widget.isSignIn
              ? 'Please sign in to continue'
              : 'Create Your Account',
          style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'League Spartan'),
        ),
      ],
    );
  }

  Widget _buildInputField(TextEditingController controller, String hintText,
      bool obscureText, String? error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.4), // 80% opacity
              ),
            ),
            obscureText: obscureText,
            onChanged: (value) =>
                setState(() => error == null ? null : error = null),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(error!,
                style: const TextStyle(color: Colors.red, fontSize: 14)),
          ),
      ],
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => _showSnackBar('Forgot Password not yet implemented'),
        child: const Text('Forgot Password?'),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required VoidCallback onPressed,
    bool isGoogleSignIn = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isGoogleSignIn
              ? Colors.white
              : Theme.of(context).colorScheme.primary,
          side: isGoogleSignIn
              ? const BorderSide(color: Colors.black, width: 1.5)
              : null,
        ),
        child: isGoogleSignIn
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icon/google.svg', // Make sure the SVG file is in the assets directory
                    width: 24, // Adjust the width as needed
                    height: 24, // Adjust the height as needed
                  ),
                  const SizedBox(width: 8),
                ],
              )
            : Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 10.0),
            height: 1.0,
            color: Colors.grey,
          ),
        ),
        const Text(
          'atau',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'League Spartan',
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0),
            height: 1.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSwitchText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.isSignIn ? 'Sudah punya akun?' : 'Belum punya akun?',
            style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'League Spartan')),
        TextButton(
          onPressed: () => Navigator.pushReplacementNamed(
              context, widget.isSignIn ? '/signup' : '/signin'),
          child: Text(widget.isSignIn ? 'Sign Up' : 'Sign In',
              style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontFamily: 'League Spartan')),
        ),
      ],
    );
  }

  void _validateForm() {
    _emailError =
        _emailController.text.isEmpty ? 'Please enter your email' : null;
    _passwordError =
        _passwordController.text.isEmpty ? 'Please enter your password' : null;

    if (_emailError == null && _passwordError == null) {
      widget.onSubmit(_emailController.text, _passwordController.text);
    } else {
      setState(() {});
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
