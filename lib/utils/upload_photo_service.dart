import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pit_box/utils/cloudinary_service.dart';

class UploadPhotoService {
  /// Fungsi untuk memilih gambar dari galeri atau kamera
  static Future<File?> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () async {
                  final XFile? pickedImage =
                      await picker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context, pickedImage);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto'),
                onTap: () async {
                  final XFile? pickedImage =
                      await picker.pickImage(source: ImageSource.camera);
                  Navigator.pop(context, pickedImage);
                },
              ),
            ],
          ),
        );
      },
    );

    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  /// Fungsi untuk mengunggah gambar ke Cloudinary
  static Future<String?> uploadPhoto(File imageFile) async {
    try {
      final String? imageUrl = await CloudinaryService.uploadImage(
        imageFile,
        folder: 'event_images', // Folder di Cloudinary
      );
      return imageUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }
}
