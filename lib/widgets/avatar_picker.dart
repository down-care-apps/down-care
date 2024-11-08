import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:down_care/api/user_api.dart';

class AvatarPicker extends StatefulWidget {
  const AvatarPicker({super.key});

  @override
  _AvatarPickerState createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
    Navigator.of(context).pop();
  }

  void _showImageSourceSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<Map<String, dynamic>>(
          future: UserService().getCurrentUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircleAvatar(radius: 50, child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const CircleAvatar(radius: 50, backgroundImage: AssetImage('assets/user_icon.png'));
            } else {
              final user = snapshot.data!;
              final avatarUrl = user['photoURL'] ?? '';
              return CircleAvatar(
                radius: 50,
                backgroundImage: _image != null
                    ? FileImage(File(_image!.path))
                    : (avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : const AssetImage('assets/user_icon.png')) as ImageProvider,
              );
            }
          },
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            radius: 15,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: IconButton(
              icon: const Icon(Icons.edit, size: 15, color: Colors.white),
              onPressed: _showImageSourceSelector,
            ),
          ),
        ),
      ],
    );
  }
}
