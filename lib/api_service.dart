import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // URL untuk API server Anda
  static const String registrasiUrl = 'http://localhost:5000/registerUser';
  static const String loginUrl = 'http://localhost:5000/loginUser';

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
}
