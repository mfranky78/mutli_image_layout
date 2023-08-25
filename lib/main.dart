import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserNamePage(),
    );
  }
}

class UserNamePage extends StatefulWidget {
  @override
  _UserNamePageState createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  String? profileImage;
  List<String> galleryImages = [];

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera,preferredCameraDevice: CameraDevice.front);

    if (pickedImage != null) {
      setState(() {
        profileImage = pickedImage.path;
      });
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    if (pickedImages != null) {
      setState(() {
        galleryImages.addAll(pickedImages.map((image) => image.path).toList());
      });
    }
  }

  void _deleteImage(int index) {
    setState(() {
      galleryImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserPage'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.settings))],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _takePicture,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: profileImage != null
                      ? DecorationImage(
                          image: FileImage(File(profileImage!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: profileImage == null
                    ? const Icon(
                        Icons.camera_alt_outlined,
                        size: 80,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Username',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('Location', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
            const SizedBox(height: 40),
            const Text('Gallery', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                itemCount: galleryImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () => _deleteImage(index),
                    child: Image.file(
                      File(galleryImages[index]),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImages,
        child: const Icon(Icons.photo_library),
      ),
    );
  }
}
