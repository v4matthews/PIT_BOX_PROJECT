import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ApiService {
  // URL Base untuk API server Anda
  static const String _baseUrl =
      'https://pit-box-project-backend-452431537344.us-central1.run.app';
  // static const String _baseUrl = 'http://localhost:5000';

  // Endpoint API
  static const String _registerUserEndpoint = '/registerUser';
  static const String _registerOrganizerEndpoint = '/registerOrganizer';
  static const String _loginUserEndpoint = '/loginUser';
  static const String _loginOrganizerEndpoint = '/loginOrganizer';
  static const String _cekUserEndpoint = '/cekUser';
  static const String _cekEmailUserEndpoint = '/cekEmail';
  static const String _cekEmailOrganizerEndpoint = '/cekEmailOrganizer';
  static const String _getRegionEndpoint = '/getRegion';
  static const String _getAllCategoriesEndpoint = '/getAllCategories';

  //ON DEV
  static const String _forgetUserEndpoint = '/forgetUserEndpoint';
  static const String _forgetOrganizerEndpoint = '/forgetOrganizerEndpoint';
  static const String _insertEventEndpoint = '/insertEvent';

  static const String _createTransactionEndpoint = '/create-transaction';

  // Helper untuk membuat header
  static Map<String, String> _jsonHeaders() => {
        'Content-Type': 'application/json',
      };

  // Fungsi HTTP Helper
  static Future<http.Response> _postRequest(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse(_baseUrl + endpoint);
    return await http.post(url,
        headers: _jsonHeaders(), body: json.encode(body));
  }

  static Future<http.Response> _getRequest(String endpoint) async {
    final url = Uri.parse(_baseUrl + endpoint);
    return await http.get(url, headers: _jsonHeaders());
  }

  // Fungsi untuk membuat transaksi
  static Future<String?> createTransaction(
      Map<String, dynamic> transactionData) async {
    final response =
        await _postRequest(_createTransactionEndpoint, transactionData);

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      return responseData['redirect_url'];
    } else {
      print('Failed to create transaction: ${response.body}');
      return null;
    }
  }

  // Fungsi Registrasi User
  static Future<bool> registerUser({
    required String username,
    required String nama,
    required String email,
    required String nomorTelepon,
    required String kota,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      throw Exception('Password dan konfirmasi password tidak cocok');
    }

    final String idUser = Uuid().v4();

    final response = await _postRequest(_registerUserEndpoint, {
      'id_user': idUser,
      'username': username,
      'nama_user': nama,
      'email_user': email,
      'tlpn_user': nomorTelepon,
      'kota_user': kota,
      'password_user': password,
    });

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Gagal melakukan registrasi: ${response.body}');
    }
  }

  // Fungsi Registrasi Organizer
  static Future<bool> registerOrganizer({
    required String nama,
    required String email,
    required String nomorTelepon,
    required String kota,
    required String alamat,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      throw Exception('Password dan konfirmasi password tidak cocok');
    }

    final String idOrganizer = Uuid().v4();

    final response = await _postRequest(_registerOrganizerEndpoint, {
      'id_organizer': idOrganizer,
      'nama_organizer': nama,
      'email_organizer': email,
      'tlpn_organizer': nomorTelepon,
      'kota_organizer': kota,
      'alamat_organizer': alamat,
      'password_organizer': password,
    });

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Gagal melakukan registrasi: ${response.body}');
    }
  }

  // Fungsi Login User
  static Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) async {
    final response = await _postRequest(_loginUserEndpoint, {
      'username': username,
      'password_user': password,
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('${response.body}');
    }
  }

  // Fungsi Login Organizer
  static Future<Map<String, dynamic>> loginOrganizer({
    required String email,
    required String password,
  }) async {
    final response = await _postRequest(_loginOrganizerEndpoint, {
      'email_organizer': email,
      'password_organizer': password,
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('${response.body}');
    }
  }

  // Fungsi Forgot Password User
  static Future<Map<String, dynamic>> forgotUser({
    required String email,
  }) async {
    final response = await _postRequest(_forgetUserEndpoint, {
      'email_user': email,
    });

    if (response.statusCode == 200) {
      // Jika login berhasil, kembalikan data pengguna dan token (jika ada)
      return json.decode(response.body); // Mengembalikan data dalam bentuk Map
    } else {
      // Jika login gagal, lemparkan exception dengan pesan error
      throw Exception('Login gagal: ${response.body}, ${response.statusCode}');
    }
  }

  // Fungsi Forgot Password Organizer
  static Future<Map<String, dynamic>> forgotOrganizer({
    required String email,
  }) async {
    final response = await _postRequest(_forgetOrganizerEndpoint, {
      'email_organizer': email,
    });

    if (response.statusCode == 200) {
      // Jika login berhasil, kembalikan data pengguna dan token (jika ada)
      return json.decode(response.body); // Mengembalikan data dalam bentuk Map
    } else {
      // Jika login gagal, lemparkan exception dengan pesan error
      throw Exception('Login gagal: ${response.body}, ${response.statusCode}');
    }
  }

  // Fungsi Get Region
  static Future<List<dynamic>> dataRegion() async {
    final response = await _getRequest(_getRegionEndpoint);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data is List ? data : [data];
    } else {
      throw Exception('Gagal memuat data region: ${response.body}');
    }
  }

  // Fungsi Get All Categories
  static Future<List<dynamic>> getAllCategories() async {
    final response = await _getRequest(_getAllCategoriesEndpoint);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data is List ? data : [data];
    } else {
      throw Exception('Gagal memuat kategori: ${response.body}');
    }
  }

  // Fungsi Cek Username
  static Future<bool> cekUsername({
    required String username,
  }) async {
    final response = await _postRequest(_cekUserEndpoint, {
      'username': username,
    });

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      return false;
    } else {
      throw Exception('Gagal memeriksa username: ${response.body}');
    }
  }

  // Fungsi Cek Email
  static Future<bool> getEmail({
    required String email,
  }) async {
    final response = await _postRequest(_cekEmailOrganizerEndpoint, {
      'email_user': email,
    });

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      return false;
    } else {
      throw Exception('Gagal memeriksa email: ${response.body}');
    }
  }

  // Fungsi Cek Email Organizer
  static Future<bool> getEmailOrganier({
    required String email,
  }) async {
    final response = await _postRequest(_cekEmailOrganizerEndpoint, {
      'email_organizer': email,
    });

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      return false;
    } else {
      throw Exception('Gagal memeriksa email organizer: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> _uploadImage(String filePath) async {
    final url = Uri.parse('$_baseUrl/uploadImage'); // Sesuaikan endpoint upload
    final request = http.MultipartRequest('POST', url);

    // Tambahkan file gambar
    request.files.add(await http.MultipartFile.fromPath('image', filePath));

    // Kirim permintaan
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      return json.decode(responseData.body);
    } else {
      throw Exception('Gagal mengunggah gambar: ${response.statusCode}');
    }
  }

  static Future<bool> insertEvent({
    required String nama,
    required String kategori,
    required String htm,
    required String tanggal,
    required String waktu,
    required String kota,
    required String alamat,
    required String deskripsi,
  }) async {
    final String idEvent = Uuid().v4();

    final response = await _postRequest(_insertEventEndpoint, {
      'id_event': idEvent,
      'nama_event': nama,
      'kategori_event': kategori,
      'htm_event': htm,
      'tanggal_event': tanggal,
      'waktu_event': waktu,
      'kota_event': kota,
      'alamat_event': alamat,
      'deskripsi_event': deskripsi,
    });

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Gagal melakukan registrasi: ${response.body}');
    }
  }

  static Future<bool> insertEventPending({
    required String name,
    required String location,
    required String date,
    required String categoryId,
    required String organizerId,
    String? imagePath, // Untuk gambar opsional
    String? description,
    double? price, // HTM Event
  }) async {
    final String eventId = Uuid().v4(); // Membuat ID unik untuk event

    // Siapkan body permintaan
    final body = {
      'id_event': eventId,
      'name': name,
      'location': location,
      'date': date,
      'category_id': categoryId,
      'organizer_id': organizerId,
      'description': description ?? '',
      'price': price ?? 0.0,
    };

    // Jika ada gambar, tambahkan proses pengunggahan
    if (imagePath != null) {
      try {
        final imageUploadResponse = await _uploadImage(imagePath);
        if (imageUploadResponse['success'] == true) {
          body['image_url'] = imageUploadResponse['url'];
        } else {
          throw Exception('Gagal mengunggah gambar');
        }
      } catch (e) {
        throw Exception('Terjadi kesalahan saat mengunggah gambar: $e');
      }
    }

    // Kirim permintaan POST
    final response = await _postRequest(
        _insertEventEndpoint, body); // Endpoint harus diubah jika berbeda
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Gagal menambahkan event: ${response.body}');
    }
  }

  //=================================

  static Future<Map<String, dynamic>> getFilteredEvents({
    String? category,
    String? location,
    String? date1,
    String? date2,
    int page = 1,
    int limit = 10,
  }) async {
    final url =
        Uri.parse('$_baseUrl/getFilteredEvents').replace(queryParameters: {
      if (category != null) 'category': category,
      if (location != null) 'location': location,
      if (date1 != null) 'date1': date1,
      if (date2 != null) 'date2': date2,
      'page': page.toString(),
      'limit': limit.toString(),
    });

    final response = await http.get(url, headers: _jsonHeaders());

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Gagal memuat data yang difilter: ${response.body}');
    }
  }
}
