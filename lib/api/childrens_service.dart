import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'user_api.dart';

class ChildrensService{
  static final ChildrensService _instance = ChildrensService._internal();

  factory ChildrensService(){
    return _instance;
  }

  ChildrensService._internal();

  Future<List<dynamic>> getAllChildrens() async {
  try {
    // Instantiate user service and retrieve user data
    final userService = UserService();
    final user = await userService.getCurrentUserData();
    
    // Ensure 'uid' is present
    if (user == null || user['uid'] == null) {
      throw Exception('User not found or UID is missing');
    }
    final id = user['uid']; 
    print("parent id: $id");

    // Retrieve the token
    final token = await userService.getTokenUser();
    if (token == null) {
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
      
      // Ensure data is in list format
      if (data is List<dynamic> && data.isNotEmpty) {
        return data;
      } else {
        throw Exception('No childrens found');
      }
    } else {
      throw Exception('Failed to fetch childrens: ${response}');
    }
  } catch (e) {
    print('Server response error: $e');
    throw Exception('Error fetching childrens: ${e.toString()}');
  }
}


  Future<List<dynamic>> getChildrenById(String id) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Please Login to view childrens');
    }

    try {
      final token = await user.getIdToken();

      final response = await http.get(
        Uri.parse('https://api-f3eusviapa-uc.a.run.app/childrens/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          throw Exception('No childrens found');
        }

        return [data];
      } else {
        throw Exception('Failed to fetch childrens: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching childrens: ${e.toString()}');
    }
  }
}