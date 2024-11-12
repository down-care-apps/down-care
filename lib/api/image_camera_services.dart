import 'package:camera/camera.dart';
import 'package:down_care/api/user_api.dart';
import 'package:down_care/models/scan_history.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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
