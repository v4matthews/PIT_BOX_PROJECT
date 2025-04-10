import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pit_box/api_service.dart';

class UploadProfileImagePage extends StatefulWidget {
  @override
  _UploadProfileImagePageState createState() => _UploadProfileImagePageState();
}

class _UploadProfileImagePageState extends State<UploadProfileImagePage> {
  XFile? _pickedFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _pickedFile = pickedFile;
    });
  }

  Future<void> _uploadImage() async {
    if (_pickedFile == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // // final imageUrl = await ApiService.uploadImage(_pickedFile!.path);
      // Navigator.pop(context, imageUrl);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunggah gambar: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Foto Profil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_pickedFile != null)
              Image.file(
                File(_pickedFile!.path),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pilih Gambar'),
            ),
            SizedBox(height: 20),
            if (_pickedFile != null)
              ElevatedButton(
                onPressed: _uploadImage,
                child: _isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text('Unggah Gambar'),
              ),
          ],
        ),
      ),
    );
  }
}
