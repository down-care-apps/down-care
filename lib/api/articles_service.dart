import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_api.dart';
import 'package:intl/intl.dart';

class ArticlesService {
  // Singleton pattern
  static final ArticlesService _instance = ArticlesService._internal();

  factory ArticlesService() {
    return _instance;
  }

  ArticlesService._internal();

  final String _baseUrl = 'https://api-f3eusviapa-uc.a.run.app/articles/';

  Future<List<Map<String, dynamic>>> getArticles({int? limit}) async {
    try {
      final userService = UserService();
      final token = await userService.getTokenUser();

      // Add query parameters for limiting results if required
      final uri = Uri.parse(_baseUrl).replace(
        queryParameters: limit != null ? {'limit': '$limit'} : null,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(json.decode(response.body));

        if (data.isEmpty) {
          throw Exception('No articles found');
        }

        // Parse and sort articles by date and time
        data.sort((a, b) {
          final dateA = _parseCustomDate(a['date']); // Use custom date parsing
          final dateB = _parseCustomDate(b['date']);
          return dateB.compareTo(dateA); // Sort in descending order
        });

        // Return limited results if limit is specified
        if (limit != null) {
          return data.take(limit).toList();
        }

        return data;
      } else {
        throw Exception('Failed to fetch articles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching articles: ${e.toString()}');
    }
  }

// Custom function to parse 'dd-MM-yyyy HH:mm:ss' date format
  DateTime _parseCustomDate(String dateString) {
    try {
      return DateFormat('dd-MM-yyyy HH:mm:ss').parse(dateString);
    } catch (e) {
      throw FormatException('Invalid date format: $dateString');
    }
  }

  Future<Map<String, dynamic>> getArticleById(String id) async {
    try {
      final userService = UserService();
      final token = await userService.getTokenUser();

      final response = await http.get(
        Uri.parse('$_baseUrl$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to fetch article: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching article: ${e.toString()}');
    }
  }
}
