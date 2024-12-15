import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'user_api.dart';

class ChildrensService {
  static final ChildrensService _instance = ChildrensService._internal();

  factory ChildrensService() {
    return _instance;
  }

  ChildrensService._internal();

  Future<List<dynamic>> getAllChildrens() async {
    try {
      // Instantiate user service and retrieve user data
      final userService = UserService();
      final user = await userService.getCurrentUserData();

      // Ensure 'uid' is present
      if (user.id.isEmpty) {
        throw Exception('User not found or UID is missing');
      }
      final id = user.id;

      // Retrieve the token
      final token = await userService.getTokenUser();
      if (token.isEmpty) {
        throw Exception('Failed to retrieve user token');
      }

      // Perform the GET request to retrieve children data
      final response = await http.get(
        Uri.parse('https://api-f3eusviapa-uc.a.run.app/childrens/parent/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Check response status
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Return empty list if no children found instead of throwing an exception
        if (data is List<dynamic>) {
          return data;
        } else {
          return []; // Return empty list if data is not a list
        }
      } else if (response.statusCode == 404) {
        // Specifically handle 404 (Not Found) as an empty list scenario
        return [];
      } else {
        throw Exception('Failed to fetch childrens: ${response.body}');
      }
    } catch (e) {
      // Only throw exceptions for actual errors, not for "no children" scenarios
      if (e.toString().contains('No childrens found')) {
        return [];
      }
      throw Exception('Error fetching childrens: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getChildrenById(String id) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Please Login to view childrens');
    }

    try {
      final userService = UserService();
      final token = await userService.getTokenUser();

      final response = await http.get(
        Uri.parse('https://api-f3eusviapa-uc.a.run.app/childrens/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch childrens: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching childrens: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>?> createProfileChildren(name, weight, height, gender, dateBirthday) async {
    try {
      final userService = UserService();
      final token = await userService.getTokenUser();

      final response = await http.post(
        Uri.parse('https://api-f3eusviapa-uc.a.run.app/childrens/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'gender': gender,
          'weight': weight,
          'height': height,
          'dateBirthday': dateBirthday,
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create childrens: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating childrens: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>?> updateProfileChildren(
      String id, String? name, String? weight, String? height, String? gender, String? dateBirthday) async {
    try {
      final userService = UserService();
      final token = await userService.getTokenUser();

      final response = await http.put(
        Uri.parse('https://api-f3eusviapa-uc.a.run.app/childrens/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'height': height,
          'weight': weight,
          'gender': gender,
          'dateBirthday': dateBirthday,
        }),
      );

      switch (response.statusCode) {
        case 200:
          return json.decode(response.body);
        case 404:
          throw Exception('Profile Children not found: ${response.body}');
        case 400:
          throw Exception('Bad request: ${response.body}');
        case 401:
          throw Exception('Unauthorized request. Please log in again.');
        case 500:
          throw Exception('Server error: ${response.body}');
        default:
          throw Exception('Failed to update profile children. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating profile children: $e');
    }
  }

  Future<void> deleteProfileChildren(String id) async {
    try {
      final userService = UserService();
      final token = await userService.getTokenUser();

      final response = await http.delete(
        Uri.parse('https://api-f3eusviapa-uc.a.run.app/childrens/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      switch (response.statusCode) {
        case 200:
          break;
        case 404:
          throw Exception('Profile Children not found: ${response.body}');
        case 400:
          throw Exception('Bad request: ${response.body}');
        case 401:
          throw Exception('Unauthorized request. Please log in again.');
        case 500:
          throw Exception('Server error: ${response.body}');
        default:
          throw Exception('Failed to delete profile children. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting profile children: $e');
    }
  }
}
