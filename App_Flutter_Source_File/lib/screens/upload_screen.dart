import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'result_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final ImagePicker _picker = ImagePicker();
  // ignore: unused_field
  Uint8List? _imageBytes;
  // ignore: unused_field
  String? _imageName;

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked == null) return;

    final bytes = await picked.readAsBytes();

    setState(() {
      _imageBytes = bytes;
      _imageName = picked.name;
    });

    // Navigate to ResultScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          imageBytes: bytes,
          imageName: picked.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5D7BB),
      appBar: AppBar(
        title: const Text("تصویر اپ لوڈ کریں"), // Upload Image
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text("گیلری سے منتخب کریں"), // Pick From Gallery
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text("کیمرے سے تصویر لیں"), // Capture Using Camera
              onPressed: () => _pickImage(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }
}
