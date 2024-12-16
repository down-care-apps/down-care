import 'package:down_care/screens/login/welcome.dart';
import 'package:down_care/utils/transition.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:down_care/providers/scan_history_provider.dart';

Future<void> logoutUser(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut(); // Firebase sign out

    // Clear scan history
    if (context.mounted) {
      Provider.of<ScanHistoryProvider>(context, listen: false).clearState();
    }

    // Navigate to the Welcome screen and clear the navigation stack
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        createRoute(const Welcome()),
        (Route<dynamic> route) => false,
      );
    }
  } catch (error) {
    // print('Error logging out: $error');
    // Show an error message to the user
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $error')),
      );
    }
  }
}
