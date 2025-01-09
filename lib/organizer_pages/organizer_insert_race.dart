import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:image_picker/image_picker.dart';
import 'package:pit_box/components/asset_button_login.dart';
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

  // Function to pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (kIsWeb) {
          // For Web
          _webImagePath = pickedFile.path;
        } else {
          // For Android/iOS
          _selectedImage = File(pickedFile.path);
        }
      });
    }
  }

  // Function to reset the image
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Create Event",
          style: TextStyle(
            fontWeight: FontWeight.bold, // Membuat teks bold
            fontSize: 20, // Ukuran teks
          ),
        ),
        backgroundColor: const Color(0xFF4A59A9), // Warna biru untuk AppBar
        foregroundColor: Colors.white, // Warna teks
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image selection preview
            // Image selection preview dengan GestureDetector dan ikon silang
            Center(
              child: GestureDetector(
                onTap:
                    _pickImageFromGallery, // Memanggil fungsi pick gambar ketika diklik
                child: Stack(
                  alignment: Alignment
                      .topRight, // Menempatkan ikon di pojok kanan atas
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _selectedImage != null
                          ? Image.file(_selectedImage!,
                              fit: BoxFit.cover) // For devices
                          : _webImagePath != null
                              ? Image.network(_webImagePath!,
                                  fit: BoxFit.cover) // For Web
                              : Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                    if (_selectedImage != null || _webImagePath != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(Icons.clear, color: Colors.white),
                          onPressed:
                              _resetImage, // Menghapus gambar saat ikon ditekan
                        ),
                      ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Event form fields
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

            // Post button
            MyButton(
              label: "POST",
              width: width,
              ontap: null,
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
