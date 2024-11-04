import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';


Future<void> signInWithBackend(String googleToken) async {
  final url = Uri.parse('https://api-f3eusviapa-uc.a.run.app/start/google'); // Ganti dengan URL backend

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': googleToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String firebaseToken = data['firebaseToken'];

      // Gunakan custom token dari Firebase untuk login
      await FirebaseAuth.instance.signInWithCustomToken(firebaseToken);
      print("User signed in successfully!");
    } else {
      print("Sign-in failed: ${response.body}");
    }
  } catch (error) {
    print("Error signing in with backend: $error");
  }
}


final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: "1073969707112-9ab195guuaid8dvqi4vmg6tcunvc9ipj.apps.googleusercontent.com",
  scopes: [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ],
);

Future<void> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      print("User cancelled sign in");
      return;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final String googleToken = googleAuth.idToken!;

    // Kirim token Google ke backend untuk mendapatkan token Firebase
    await signInWithBackend(googleToken);
  } catch (error) {
    print("Google Sign-In error: $error");
  }
}
