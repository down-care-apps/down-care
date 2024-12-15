import 'package:down_care/utils/transition.dart';
import 'package:flutter/material.dart';
import 'package:down_care/widgets/custom_button.dart';
import 'package:down_care/screens/login/sign_up_screen.dart';
import 'package:down_care/screens/login/sign_in_screen.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
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
                      SizedBox(height: screenSize.height * 0.03),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                        child: const Text(
                          'memberikan dampak positif dalam\nmeningkatkan kemandirian dan rasa aman\nbagi anak-anak down syndrome dan keluarga',
                          textAlign: TextAlign.center,
                          style: subtitleTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                CustomButton(
                  text: 'Masuk',
                  widthFactor: 1.0,
                  onPressed: () => Navigator.of(context).push(createRoute(const SignInScreen())),
                ),
                SizedBox(height: screenSize.height * 0.01),
                CustomButton(
                  text: 'Daftar',
                  widthFactor: 1.0,
                  onPressed: () => Navigator.of(context).push(createRoute(const SignUpScreen())),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
