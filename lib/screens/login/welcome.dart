import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLogo(screenHeight, screenWidth),
              SizedBox(height: screenHeight * 0.03),
              _buildAppTitle(context),
              SizedBox(height: screenHeight * 0.1),
              _buildDescription(screenWidth),
              SizedBox(height: screenHeight * 0.04),
              _buildActionButtons(context, screenWidth, screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for building the app logo
  Widget _buildLogo(double screenHeight, double screenWidth) {
    return Image.asset(
      'assets/logo_blue.png',
      height: screenHeight * 0.2,
      width: screenWidth * 0.5,
    );
  }

  // Widget for building the app title with custom text styles
  Widget _buildAppTitle(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 32,
          fontFamily: 'Inter',
          height: 1.2,
          letterSpacing: -1.3,
        ),
        children: const [
          TextSpan(
            text: 'Down',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          TextSpan(
            text: 'Care',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Widget for building the description text
  Widget _buildDescription(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      child: const Text(
        'memberikan dampak positif dalam\nmeningkatkan kemandirian dan rasa aman bagi\nanak-anak down syndrome dan keluarga',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF070707),
          fontSize: 14,
          fontFamily: 'League Spartan',
          fontWeight: FontWeight.w300,
          height: 1.5,
        ),
      ),
    );
  }

  // Widget for building the action buttons (Sign In / Sign Up)
  Widget _buildActionButtons(
      BuildContext context, double screenWidth, double screenHeight) {
    return Column(
      children: [
        _buildActionButton(
          context,
          label: 'Sign In',
          onPressed: () => _navigateToSignIn(context),
          screenWidth: screenWidth,
          screenHeight: screenHeight,
        ),
        SizedBox(height: screenHeight * 0.025),
        _buildActionButton(
          context,
          label: 'Sign Up',
          onPressed: () => _navigateToSignUp(context),
          screenWidth: screenWidth,
          screenHeight: screenHeight,
        ),
      ],
    );
  }

  // Reusable widget for action buttons
  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
    required double screenWidth,
    required double screenHeight,
  }) {
    return SizedBox(
      width: screenWidth * 0.5,
      height: screenHeight * 0.055,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'League Spartan',
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  // Navigation method for Sign In
  void _navigateToSignIn(BuildContext context) {
    Navigator.pushNamed(context, '/signin'); // Update route name
  }

  // Navigation method for Sign Up
  void _navigateToSignUp(BuildContext context) {
    Navigator.pushNamed(context, '/signup'); // Update route name
  }
}
