import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:down_care/models/user_model.dart';

class UserService {
  // Singleton pattern
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  Future<UserModel> getCurrentUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }

    try {
      // Get the ID token
      final token = await user.getIdToken();
      if (token == null) {
        throw Exception('Failed to get ID token');
      }

      // Make API request
      final response = await http.get(
        Uri.parse('https://api-f3eusviapa-uc.a.run.app/users/${user.uid}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('User not found');
      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user data: ${e.toString()}');
    }
  }

  Future<String> getTokenUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }

    try {
      final token = await user.getIdToken();
      if (token == null) {
        throw Exception('Failed to get ID token');
      }
      return token;
    } catch (e) {
      throw Exception('Error fetching user data: ${e.toString()}');
    }
  }

  String formatPhoneNumber(String phoneNumber) {
    // Remove any leading and trailing spaces
    phoneNumber = phoneNumber.trim();

    // If the phone number doesn't start with '+', add the default country code '+62'
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+62' + phoneNumber;
    }

    // Validate the final phone number format
    if (phoneNumber.startsWith('+') && phoneNumber.length >= 10 && phoneNumber.length <= 15) {
      return phoneNumber;
    } else {
      throw Exception("Nomor telepon harus berformat awal + (e.g., +628123456789).");
    }
  }

  Future<void> updateUser(String? email, String? name, String? phoneNumber) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No authenticated user found');
    }

    try {
      final String id = user.uid;
      final String? token = await user.getIdToken();
      final String? formattedPhoneNumber = phoneNumber != null ? formatPhoneNumber(phoneNumber) : null;

      // Define the API URL
      final Uri url = Uri.parse('https://api-f3eusviapa-uc.a.run.app/users/$id');

      // Make the HTTP PUT request
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'displayName': name,
          'email': email,
          'phoneNumber': formattedPhoneNumber,
        }),
      );

      // Check the status code and handle responses
      switch (response.statusCode) {
        case 200:
          print('User updated successfully');
          break;
        case 404:
          throw Exception('User not found: ${response.body}');
        case 400:
          throw Exception('Bad request: ${response.body}');
        case 401:
          throw Exception('Unauthorized request. Please log in again.');
        case 500:
          throw Exception('Server error: ${response.body}');
        default:
          throw Exception('Failed to update user. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      // Catch and rethrow the error for further handling if needed
      throw Exception('Error updating user: $e');
    }
  }
}
