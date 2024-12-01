import 'package:camera/camera.dart';
import 'package:down_care/api/user_api.dart';
import 'package:down_care/models/scan_history.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageCameraServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<File> saveImageLocally(XFile imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = join(appDir.path, fileName);

    // Save the file to local storage
    await imageFile.saveTo(filePath);
    return File(filePath);
  }

  Future<String?> uploadToFirebaseStorage(File imageFile) async {
    try {
      final ref = _storage.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = await ref.putFile(imageFile);
  
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload to Firebase Storage: $e');
    }
  }

  Future<String?> uploadImageToServer(String imageURL, result) async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await UserService().getTokenUser();

    final response = await http.post(Uri.parse('https://api-f3eusviapa-uc.a.run.app/camera/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          'userID': user!.uid,
          'imageURL': imageURL,
          'result': result,
        }));

    try {
      switch (response.statusCode) {
        case 201:
          return json.decode(response.body);
        case 404:
          throw Exception('User not found: ${response.body}');
        case 400:
          throw Exception('Bad request: ${response.body}');
        case 401:
          throw Exception('Unauthorized request. Please log in again.');
        case 500:
          throw Exception('Server error: ${response.body}');
        default:
          throw Exception('Failed to save image. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      // Catch and rethrow the error for further handling if needed
      throw Exception('Error save image: $e');
    }
  }

  Future<List<ScanHistory>> getAllScan({int? limit}) async {
    try {
      final userService = UserService();
      final token = await userService.getTokenUser();
      const String apiUrl = 'https://api-f3eusviapa-uc.a.run.app/camera/';

      final uri = Uri.parse(apiUrl).replace(
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
        final List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          throw Exception('No scan history found');
        }

        List<ScanHistory> scanHistories = data.map((item) => ScanHistory.fromJson(item)).toList();

        scanHistories.sort((a, b) {
          final dateA = _parseCustomDate(a.date);
          final dateB = _parseCustomDate(b.date);
          return dateB.compareTo(dateA); // Descending order
        });

        if (limit != null) {
          return scanHistories.take(limit).toList();
        }

        return scanHistories;
      } else {
        throw Exception('Failed to fetch scan history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching scan history: ${e.toString()}');
    }
  }

  DateTime _parseCustomDate(String dateString) {
    try {
      return DateFormat('yyyy-MM-dd').parse(dateString);
    } catch (e) {
      throw FormatException('Invalid date format: $dateString');
    }
  }
}
