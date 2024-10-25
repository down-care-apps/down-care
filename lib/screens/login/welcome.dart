import 'package:flutter/material.dart';
import 'package:down_care/widgets/custom_button.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  static const primaryTextStyle = TextStyle(
    fontFamily: 'Inter',
    height: 1.2,
    letterSpacing: -1.3,
  );

  static const subtitleTextStyle = TextStyle(
    color: Color(0xFF070707),
    fontSize: 14,
    fontFamily: 'League Spartan',
    fontWeight: FontWeight.w300,
    height: 1.5,
  );

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo_blue.png',
                height: screenSize.height * 0.2,
                width: screenSize.width * 0.5,
              ),
              SizedBox(height: screenSize.height * 0.03),
              Text.rich(
                TextSpan(
                  style: primaryTextStyle.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 32,
                  ),
                  children: const [
                    TextSpan(text: 'Down', style: TextStyle(fontWeight: FontWeight.w900)),
                    TextSpan(text: 'Care', style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              SizedBox(height: screenSize.height * 0.1),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                child: const Text(
                  'memberikan dampak positif dalam\nmeningkatkan kemandirian dan rasa aman bagi\nanak-anak down syndrome dan keluarga',
                  textAlign: TextAlign.center,
                  style: subtitleTextStyle,
                ),
              ),
              SizedBox(height: screenSize.height * 0.04),
              CustomButton(text: 'Sign In', onPressed: () => Navigator.pushNamed(context, '/signin')),
              SizedBox(height: screenSize.height * 0.02),
              CustomButton(text: 'Sign Up', onPressed: () => Navigator.pushNamed(context, '/signup')),
            ],
          ),
        ),
      ),
    );
  }
}
