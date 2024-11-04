// lib/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential; // Return the UserCredential for further use if needed
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
        print('User registered: ${data['uid']}');
        // Handle navigation or further actions if needed
      } else {
        print('Failed to register user: ${response.body}');
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (error) {
      print('Error registering user: $error');
      throw Exception('Error: $error');
    }
  }

  Future<void> callLoginApi(String email, String password, String idToken) async {
    final url = 'https://api-f3eusviapa-uc.a.run.app/start/login';

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
        print('Response data: ${response.body}');
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Failed to call API: $e');
    }
  }
}

