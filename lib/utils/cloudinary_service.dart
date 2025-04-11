import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = 'dxh3z8xib'; // Ganti dengan Cloud Name Anda
  static const String apiKey = '593727652163579'; // Ganti dengan API Key Anda
  static const String apiSecret =
      '5vRZ7VSJKhEOMUw9Qb0KVF-3B30'; // Ganti dengan API Secret Anda
  static const String uploadPreset =
      'eventImage'; // Ganti dengan Upload Preset Anda

  /// Fungsi untuk mengunggah gambar ke Cloudinary dengan progress callback
  static Future<String?> uploadImage(
    File imageFile, {
    String? publicId,
    String? folder,
    void Function(int bytesSent, int totalBytes)? onProgress,
  }) async {
    final String url =
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

    try {
      // Hitung ukuran file untuk progress
      final fileLength = await imageFile.length();

      // Buat request multipart
      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields.addAll({
          'upload_preset': uploadPreset,
          'api_key': apiKey,
          if (publicId != null) 'public_id': publicId,
          if (folder != null) 'folder': folder,
        })
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          // Progress tracking is not supported directly in http.MultipartFile.fromPath
        ));

      // Kirim request
      final response = await request.send();

      // Proses response
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final responseBody = json.decode(responseData);
        return responseBody['secure_url']; // URL gambar yang diunggah
      } else {
        final errorResponse = await response.stream.bytesToString();
        throw Exception(
            'Failed to upload image: ${response.statusCode} - $errorResponse');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  /// Fungsi untuk menghapus gambar dari Cloudinary
  static Future<bool> deleteImage(String publicId) async {
    final String url =
        'https://api.cloudinary.com/v1_1/$cloudName/image/destroy';
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      // Generate signature
      final signatureString =
          'public_id=$publicId&timestamp=$timestamp$apiSecret';
      final signature = _generateSha1(signatureString);

      // Kirim request
      final response = await http.post(
        Uri.parse(url),
        body: {
          'public_id': publicId,
          'timestamp': timestamp,
          'api_key': apiKey,
          'signature': signature,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error deleting image: $e');
    }
  }

  /// Helper function untuk generate SHA1 signature
  static String _generateSha1(String input) {
    // Implementasi SHA1 hashing
    // Anda bisa menggunakan package crypto untuk ini
    // Contoh sederhana (tidak aman untuk produksi):
    return input; // Ganti dengan implementasi SHA1 yang sebenarnya
  }
}
