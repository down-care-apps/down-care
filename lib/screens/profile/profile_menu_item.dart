import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData? icon;
  final String text;
  final VoidCallback onTap;
  final Color textColor;
  final String? svgPath;

  const ProfileMenuItem({
    super.key,
    this.icon,
    required this.text,
    required this.onTap,
    this.textColor = Colors.black,
    this.svgPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: ListTile(
        leading: svgPath != null
            ? CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: SvgPicture.asset(
                  svgPath!,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Icon(icon, color: Theme.of(context).primaryColor),
              ),
        title: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).primaryColor),
        onTap: onTap,
      ),
    );
  }
}
