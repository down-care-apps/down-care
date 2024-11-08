import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatelessWidget {
  final double widthFactor;
  final double heightFactor;
  final String? text;
  final VoidCallback onPressed;
  final Color? color;
  final BorderSide? borderSide;
  final String? svgIconPath;
  final Color textColor;
  final IconData? icon;

  const CustomButton({
    super.key,
    this.widthFactor = 0.5,
    this.heightFactor = 0.055,
    this.text,
    required this.onPressed,
    this.color,
    this.borderSide,
    this.svgIconPath,
    this.textColor = Colors.white,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth * widthFactor,
      height: screenHeight * heightFactor,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
            side: borderSide ?? BorderSide.none,
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor),
              const SizedBox(width: 8),
            ],
            if (svgIconPath != null) ...[
              SvgPicture.asset(svgIconPath!, height: 24, width: 24),
              const SizedBox(width: 8),
            ],
            if (text != null)
              Text(
                text!,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontFamily: 'League Spartan',
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
