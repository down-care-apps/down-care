import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential; // Return the UserCredential for further use if needed
  }

  Future<bool> isEmailRegistered(String email) async {
    try {
      // Attempt to create a user with the given email and a dummy password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: 'dummyPassword', // Use a temporary password
      );
      // If the user is created successfully, delete it
      await FirebaseAuth.instance.currentUser?.delete();
      return false; // Email is not registered
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return true; // Email is already registered
      }
      return false; // Other errors (e.g., invalid email format)
    }
  }

  Future<void> signUpWithEmailPassword(String email, String password, String name) async {
    final url = Uri.parse('https://api-f3eusviapa-uc.a.run.app/start/register');
    final headers = {'Content-Type': 'application/json'};

    final body = json.encode({
      'name': name,
      'email': email,
      'password': password,
      // You can add age or other fields as needed
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        Logger('AuthService').info('User registered: ${data['uid']}');
        // Handle navigation or further actions if needed
      } else {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<void> callLoginApi(String email, String password, String idToken) async {
    const url = 'https://api-f3eusviapa-uc.a.run.app/start/login';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'idToken': idToken,
        }),
      );

      if (response.statusCode == 200) {
        Logger('AuthService').info('Response data: ${response.body}');
      } else {
        throw Exception('Failed to call login API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error calling login API: $e');
    }
  }

  Future<void> deleteAccount(String password) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("No user is currently signed in");
    }

    try {
      // Re-authenticate the user using their password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      // Sign in again to verify the user's password
      await user.reauthenticateWithCredential(credential);
      // If reauthentication is successful, proceed with deletion
      await user.delete();

      // final token = await user.getIdToken();
      // final response = await http.delete(
      //   Uri.parse('https://api-f3eusviapa-uc.a.run.app/start/delete'),
      //   headers: {
      //     'Authorization': 'Bearer $token',
      //     'Content-Type': 'application/json',
      //   },
      // );
      // print(response.body);
      // if (response.statusCode == 200) {
      //   print('asu');
      //   Logger('AuthService').info('Account deleted successfully');
      // } else {
      //   throw Exception('Failed to delete account: ${response.statusCode}');
      // }
    } catch (e) {
      throw Exception('Error deleting account: ${e.toString()}');
    }
  }
}
