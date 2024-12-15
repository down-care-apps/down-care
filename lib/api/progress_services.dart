import 'dart:convert';
import 'package:down_care/api/childrens_service.dart';
import 'package:http/http.dart' as http;
import 'user_api.dart';

class ProgressServices {
  // Singleton pattern
  static final ProgressServices _instance = ProgressServices._internal();

  factory ProgressServices() {
    return _instance;
  }

  ProgressServices._internal();

  final String _baseUrl = 'https://api-f3eusviapa-uc.a.run.app/progress/';

  Future<List<dynamic>> getProgressByChildId(String id) async {
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
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('data')) {
          final List<dynamic> progressData = responseData['data'];

          if (progressData.isNotEmpty && progressData.every((entry) => entry is Map && entry.containsKey('month'))) {
            return progressData;
          }
        }

        throw Exception('Invalid progress data format');
      } else {
        throw Exception('Failed to fetch progress data: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error in getProgressByChildId: $e');
      throw Exception('Error fetching progress data: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>?> createProgress(kid, height, weight, month, note) async {
    try {
      final userService = UserService();
      final token = await userService.getTokenUser();
      final id = kid['id'];
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'childrenId': id,
          'weight': weight,
          'height': height,
          'month': month,
          'note': note,
        }),
      );

      await ChildrensService().updateProfileChildren(id, kid['name'], weight, height, kid['gender'], kid['dateBirthday']);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create childrens: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating childrens: ${e.toString()}');
    }
  }
}
