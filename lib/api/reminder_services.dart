import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_api.dart';

class ReminderServices {
  final String _baseUrl = 'https://api-f3eusviapa-uc.a.run.app/reminders/';

  Future<Map<String, dynamic>> createReminder(reminder) async {
    final user = UserService();

    try {
      final token = await user.getTokenUser();

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(reminder),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create reminder: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating reminder: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getAllReminders() async {
    try {
      final userService = UserService();
      final token = await userService.getTokenUser();

      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(json.decode(response.body));

        if (data.isEmpty) {
          throw Exception('No reminders found');
        }

        return data;
      } else {
        throw Exception('Failed to fetch reminders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching reminders: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getReminderById(String id) async {
    final user = UserService();

    try {
      final token = await user.getTokenUser();

      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch reminders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching reminders: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>?> updateReminder(reminder) async {
    try {
      final userService = UserService();
      final token = await userService.getTokenUser();
      final id = reminder.id;

      final response = await http.put(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          reminder
        }),
      );

      switch (response.statusCode) {
        case 200:
          return json.decode(response.body);
        case 404:
          throw Exception('Reminder not found: ${response.body}');
        case 400:
          throw Exception('Bad request: ${response.body}');
        case 401:
          throw Exception('Unauthorized request. Please log in again.');
        case 500:
          throw Exception('Server error: ${response.body}');
        default:
          throw Exception('Failed to update reminder. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating reminder: $e');
    }
  }

  Future<void> deleteReminder(String id) async {
    final user = UserService();

    try {
      final token = await user.getTokenUser();

      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Handle both 200 and 204 as success
      if (response.statusCode == 200 || response.statusCode == 204) {
        // print('Reminder deleted');
        return;
      } else {
        throw Exception('Failed to delete reminder: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting reminder: ${e.toString()}');
    }
  }
}
