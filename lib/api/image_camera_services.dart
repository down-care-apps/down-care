import 'package:camera/camera.dart';
import 'package:down_care/api/user_api.dart';
import 'package:down_care/models/scan_history.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
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

      // Mengunggah file ke Firebase Storage
      final uploadTask = await ref.putFile(imageFile);

      // Mengatur akses file menjadi publik
      await ref.updateMetadata(SettableMetadata(
        cacheControl: 'public, max-age=31536000',
      ));

      // Mendapatkan URL unduhan publik
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload to Firebase Storage: $e');
    }
  }

  Future<Map<String, dynamic>> uploadImageToMachineLearning(String imageURL) async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await UserService().getTokenUser();

    try {
      final response = await http.post(
        Uri.parse('https://flask-cloud-run-1073969707112.us-central1.run.app/api/analyze'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $idToken',
        },
        body: {
          'image_url': imageURL,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        return {
          "confidence": responseData['confidence'],
          "label": responseData['label'],
          "landmarks_url": responseData['landmarks_url'],
          "message": responseData['message'],
        };
      } else {
        print(imageURL);
        throw Exception("Failed to analyze image. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("An error occurred while analyzing the image.");
    }
  }

  Future<Map<String, dynamic>> uploadImageToServer(String imageURL, result_scan, childrenId) async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await UserService().getTokenUser();
    childrenId = childrenId ?? 'Unkkown ';

    try {
      final response = await http.post(
        Uri.parse('https://api-f3eusviapa-uc.a.run.app/camera/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          'userID': user!.uid,
          'childrenId': childrenId,
          'imageURL': imageURL,
          'result': result_scan['confidence']['down_syndrome'],
          'imageScan': result_scan['landmarks_url'],
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to upload image to server: ${response.body}');
      }
    } catch (e) {
      print("Error uploading to server: $e");
      throw Exception("Failed to upload image and results to server: $e");
    }
  }

  Future<List<ScanHistory>> getAllScan() async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await UserService().getTokenUser();

    final response = await http.get(
      Uri.parse('https://api-f3eusviapa-uc.a.run.app/camera/'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
    );

    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Ensure data is in list format and map to ScanHistory objects
        if (data is List) {
          return data.map((item) => ScanHistory.fromJson(item)).toList();
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to fetch scan result: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching scan: $e');
    }
  }
}
