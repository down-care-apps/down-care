import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If user cancels the sign-in flow
      if (googleUser == null) {
        throw Exception('Sign in aborted by user');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuth error: ${e.message}');
      rethrow;
    } catch (e) {
      if (e.toString().contains('network_error')) {
        throw Exception('Network error occurred. Please check your connection.');
      } else if (e.toString().contains('sign_in_failed')) {
        // Handle specific error codes
        final errorMessage = e.toString();
        if (errorMessage.contains('10:')) {
          throw Exception('Developer error: Check your Google Sign-In configuration');
        } else if (errorMessage.contains('12501')) {
          throw Exception('Google Sign-In was canceled');
        } else if (errorMessage.contains('12502')) {
          throw Exception('Google Play Services update required');
        }
      }
      print('Google Sign-In error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}