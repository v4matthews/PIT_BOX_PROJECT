import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:image_picker/image_picker.dart';
import 'package:pit_box/components/asset_textfield.dart';

class EventFormPage extends StatefulWidget {
  @override
  _EventFormPageState createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  String? _webImagePath;

  final TextEditingController namaEventController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();
  final TextEditingController htmController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (kIsWeb) {
          // Jika berjalan di Web
          _webImagePath = pickedFile.path;
        } else {
          // Jika berjalan di Android/iOS
          _selectedImage = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _resetImage() async {
    setState(() {
      _selectedImage = null;
      _webImagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final width = screenWidth * 0.8;
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Event'),
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _selectedImage != null
                    ? Image.file(_selectedImage!,
                        fit: BoxFit.cover) // Untuk perangkat
                    : _webImagePath != null
                        ? Image.network(_webImagePath!,
                            fit: BoxFit.cover) // Untuk Web
                        : Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _pickImageFromGallery,
                  child: Text('Pick Image'),
                ),
                ElevatedButton(
                  onPressed: _resetImage,
                  child: Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            MyTextField(
              controller: namaEventController,
              width: width,
              hintText: 'Nama Event',
              obScureText: false,
            ),
            SizedBox(height: 16),
            MyTextField(
              controller: kategoriController,
              width: width,
              hintText: 'Kategori',
              obScureText: false,
            ),
            SizedBox(height: 16),
            MyTextField(
              controller: htmController,
              width: width,
              hintText: 'HTM Event',
              obScureText: false,
            ),
            SizedBox(height: 16),
            MyTextField(
              controller: tanggalController,
              width: width,
              hintText: 'Tanggal Event',
              obScureText: false,
            ),
            SizedBox(height: 16),
            MyTextField(
              controller: lokasiController,
              width: width,
              hintText: 'Lokasi Event',
              obScureText: false,
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Tambahkan logika untuk menyimpan data event di sini
                },
                child: Text('Post'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EventFormPage(),
  ));
}
