import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // URL untuk API server Anda
  static const String registrasiUrl = 'http://localhost:5000/registerUser';
  static const String registrasiOrganizer =
      'http://localhost:5000/registerOrganizer';
  static const String loginUrl = 'http://localhost:5000/loginUser';
  static const String cekUser = 'http://localhost:5000/cekUser';
  static const String cekEmails = 'http://localhost:5000/cekEmail';
  static const String getRegion = 'http://localhost:5000/getRegion';

  // Fungsi untuk mengirimkan request registrasi
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

    final response = await http.post(
      Uri.parse(registrasiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'email_user': email,
        'tlpn_user': nomorTelepon,
        'alamat_user': kota,
        'password_user': password,
      }),
    );

    if (response.statusCode == 201) {
      // Pendaftaran berhasil
      return true;
    } else {
      // Gagal pendaftaran
      throw Exception('Gagal melakukan registrasi: ${response.body}');
    }
  }

  // Fungsi untuk mengirimkan request registrasi
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

    final response = await http.post(
      Uri.parse(registrasiOrganizer),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'team': team,
        'email_organizer': email,
        'tlpn_organizer': nomorTelepon,
        'alamat_organizer': alamat,
        'password_user': password,
      }),
    );

    if (response.statusCode == 201) {
      // Pendaftaran berhasil
      return true;
    } else {
      // Gagal pendaftaran
      throw Exception('Gagal melakukan registrasi: ${response.body}');
    }
  }

  // Fungsi untuk mengirimkan request login
  static Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'password_user': password,
      }),
    );

    if (response.statusCode == 200) {
      // Jika login berhasil, kembalikan data pengguna dan token (jika ada)
      return json.decode(response.body); // Mengembalikan data dalam bentuk Map
    } else {
      // Jika login gagal, lemparkan exception dengan pesan error
      throw Exception('Login gagal: ${response.body}, ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> forgotUser({
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      // Jika login berhasil, kembalikan data pengguna dan token (jika ada)
      return json.decode(response.body); // Mengembalikan data dalam bentuk Map
    } else {
      // Jika login gagal, lemparkan exception dengan pesan error
      throw Exception('Login gagal: ${response.body}, ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> forgotOrganizer({
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      // Jika login berhasil, kembalikan data pengguna dan token (jika ada)
      return json.decode(response.body); // Mengembalikan data dalam bentuk Map
    } else {
      // Jika login gagal, lemparkan exception dengan pesan error
      throw Exception('Login gagal: ${response.body}, ${response.statusCode}');
    }
  }

  // Get Region
  static Future<List<dynamic>> dataRegion() async {
    try {
      final response = await http.get(
        Uri.parse(getRegion),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Berhasil, decode response menjadi List atau Map tergantung API
        final data = json.decode(response.body);
        return data is List ? data : [data];
      } else {
        // Gagal, decode pesan error
        final errorData = json.decode(response.body);
        throw Exception("Failed to load region: ${errorData['message']}");
      }
    } catch (e) {
      // Tangani error lainnya
      throw Exception("Error fetching region: $e");
    }
  }

  //Cek Username
  static Future<bool> cekUsername({
    required String username,
  }) async {
    final response = await http.post(
      Uri.parse(cekUser),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      return false;
    } else {
      throw Exception('Gagal memeriksa username: ${response.body}');
    }
  }

  // Cek Email
  static Future<bool> cekEmail({
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse(cekEmails),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email_user': email,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      return false;
    } else {
      throw Exception('Gagal memeriksa username: ${response.body}');
    }
  }
}
