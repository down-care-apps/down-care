import 'dart:convert';
import 'package:down_care/screens/home/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'user_api.dart';

class ArticlesService {

  // Singleton pattern
  static final ArticlesService _instance = ArticlesService._internal();
  
  factory ArticlesService() {
    return _instance;
  }
  
  ArticlesService._internal();

  Future<List<dynamic>> getAllArticles() async {
    try {
      final userService = UserService();
      final token = await userService.getTokenUser();

      final response = await http.get(
        Uri.parse('https://api-f3eusviapa-uc.a.run.app/articles/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          throw Exception('No articles found');
        }

        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to fetch articles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching articles: ${e.toString()}');
    }
  }

  Future<List<dynamic>> getArticleById(id) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Please Login to view articles');
    }

    try {
      final token = await user.getIdToken();

      final response = await http.get(
        Uri.parse('https://api-f3eusviapa-uc.a.run.app/articles/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          throw Exception('No articles found');
        }

        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to fetch articles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching articles: ${e.toString()}');
    }
  }

}