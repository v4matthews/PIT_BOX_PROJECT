import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // URL Base untuk API server Anda
  static const String _baseUrl =
      'https://pit-box-project-backend-452431537344.us-central1.run.app';

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

  // Fungsi Registrasi User
  static Future<bool> registerUser({
    required String username,
    required String email,
    required String nomorTelepon,
    required String kota,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      throw Exception('Password dan konfirmasi password tidak cocok');
    }

    final response = await _postRequest(_registerUserEndpoint, {
      'username': username,
      'email_user': email,
      'tlpn_user': nomorTelepon,
      'alamat_user': kota,
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
    required String team,
    required String email,
    required String nomorTelepon,
    required String alamat,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      throw Exception('Password dan konfirmasi password tidak cocok');
    }

    final response = await _postRequest(_registerOrganizerEndpoint, {
      'team': team,
      'email_organizer': email,
      'tlpn_organizer': nomorTelepon,
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
      throw Exception('Login gagal: ${response.body}');
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
      throw Exception('Login gagal: ${response.body}');
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
}
