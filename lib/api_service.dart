import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pit_box/session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ApiService {
  // URL Base untuk API server Anda
  static const String _baseUrl =
      'https://pit-box-project-backend-452431537344.us-central1.run.app';
  // static const String _baseUrl = 'http://localhost:8080';

  // Endpoint API
  static const String _registerUserEndpoint = '/registerUser';
  static const String _registerOrganizerEndpoint = '/registerOrganizer';
  static const String _resendVerificationEndpoint = '/resend-verification';
  static const String _loginUserEndpoint = '/loginUser';
  static const String _loginOrganizerEndpoint = '/loginOrganizer';
  static const String _cekUserEndpoint = '/cekUser';
  static const String _cekEmailUserEndpoint = '/cekEmail';
  static const String _cekEmailOrganizerEndpoint = '/cekEmailOrganizer';
  static const String _getRegionEndpoint = '/getRegion';
  static const String _getAllCategoriesEndpoint = '/getAllCategories';
  static const String _updateUserEndpoint = '/updateUser';
  static const String _forgetUserEndpoint = '/forgetUserEndpoint';
  static const String _forgetOrganizerEndpoint = '/forgetOrganizerEndpoint';
  static const String _insertEventEndpoint = '/insertEvent';
  static const String _createTransactionEndpoint = '/create-transaction';
  static const String _verifyPasswordEndpoint = '/verifyPassword';
  static const String _getTicketsEndpoint = '/getTickets';
  static const String _updatePasswordEndpoint = '/updatePassword';
  static const String _createReservation = '/createReservation';
  static const String _getReservationsEndpoint = '/getReservations';
  static const String _createPaymentEndpoint = '/createPayment';
  static const String _updateReservationStatus = '/updateReservationStatus';
  static const String _getEnabledPaymentMethodsUrl = '/getPaymentMethods';
  static const String _getEventByOrganizer = '/getEvents';

  // static const String _getUserData = '/getUserData';

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

  static Future<http.Response> _putRequest(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse(_baseUrl + endpoint);
    return await http.put(url,
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
      throw Exception('${json.decode(response.body)['message']}');
    }
  }

  // Optimized updateUser function
  static Future<bool> updateUser({
    required String idUser,
    required String username,
    required String nama,
    required String email,
    required String nomorTelepon,
    required String kota,
  }) async {
    print(idUser);
    print(username);
    print(nama);
    print(email);
    print(nomorTelepon);
    print(kota);

    final response = await _putRequest(_updateUserEndpoint, {
      'id_user': idUser,
      'username': username,
      'nama_user': nama,
      'email_user': email,
      'tlpn_user': nomorTelepon,
      'kota_user': kota,
    });
    print('Response Update User: ${response}');
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('${json.decode(response.body)['message']}');
    }
  }

  // Fungsi Update Password
  static Future<bool> updatePassword({
    required String idUser,
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _putRequest(_updatePasswordEndpoint, {
      'id_user': idUser,
      'current_password': currentPassword,
      'new_password': newPassword,
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('${json.decode(response.body)['message']}');
    }
  }

  static Future<bool> saveProfileUrl({
    required String idUser,
    required String profileUrl,
  }) async {
    try {
      final response = await _postRequest('/saveUserProfileUrl', {
        'id_user': idUser,
        'profile_url': profileUrl,
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          return true;
        } else {
          throw Exception(
              'Gagal menyimpan URL profil: ${responseData['message']}');
        }
      } else {
        throw Exception('Gagal menyimpan URL profil: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menyimpan URL profil: $e');
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

  static Future<Map<String, dynamic>> resendVerificationEmail(
      {required String username}) async {
    try {
      final response = await _postRequest(_resendVerificationEndpoint, {
        "username": username,
      });

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Jika berhasil, kembalikan data respons
        return jsonDecode(response.body);
      } else {
        // Jika gagal, lempar exception dengan pesan error
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      throw Exception('Gagal mengirim ulang email verifikasi: $e');
    }
  }

  // Fungsi Login Organizer
  static Future<Map<String, dynamic>> loginOrganizer({
    required String email,
    required String password,
  }) async {
    print('Email: $email, Password: $password');
    final response = await _postRequest(_loginOrganizerEndpoint, {
      'email_organizer': email,
      'password_organizer': password,
    });
    print('Response: ${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('${response.body}');
    }
  }

  // Fungsi Forgot Password User
  static Future<Map<String, dynamic>> forgotUser({
    required String email,
    required String nomorTelepon,
  }) async {
    final response = await _postRequest(_forgetUserEndpoint, {
      'email_user': email,
      'tlpn_user': nomorTelepon,
    });

    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
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
      return json.decode(response.body);
    } else {
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

  // Fungsi untuk verifikasi password
  static Future<bool> verifyPassword(String password) async {
    final username = await SessionService.getUsername();
    if (username == null) {
      throw Exception('Username tidak ditemukan di sesi');
    }

    final response = await _postRequest(_verifyPasswordEndpoint, {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
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

  static Future<bool> insertEvent({
    required String idOrganizer,
    required String nama,
    required String kategori,
    required String htm,
    required String tanggal,
    required String waktu,
    required String kota,
    required String alamat,
    required String deskripsi,
    required String image,
  }) async {
    print("image omg: $image");
    final response = await _postRequest(_insertEventEndpoint, {
      'id_organizer': idOrganizer,
      'nama_event': nama,
      'kategori_event': kategori,
      'htm_event': htm,
      'tanggal_event': tanggal,
      'waktu_event': waktu,
      'kota_event': kota,
      'alamat_event': alamat,
      'deskripsi_event': deskripsi,
      'image_event': image,
    });

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Gagal melakukan registrasi: ${response.body}');
    }
  }

  // static Future<bool> insertEventPending({
  //   required String name,
  //   required String location,
  //   required String date,
  //   required String categoryId,
  //   required String organizerId,
  //   String? imagePath,
  //   String? description,
  //   double? price,
  // }) async {
  //   final String eventId = Uuid().v4();

  //   final body = {
  //     'id_event': eventId,
  //     'name': name,
  //     'location': location,
  //     'date': date,
  //     'category_id': categoryId,
  //     'organizer_id': organizerId,
  //     'description': description ?? '',
  //     'price': price ?? 0.0,
  //   };

  //   if (imagePath != null) {
  //     try {
  //       final imageUploadResponse = await _uploadImage(imagePath);
  //       if (imageUploadResponse['success'] == true) {
  //         body['image_url'] = imageUploadResponse['url'];
  //       } else {
  //         throw Exception('Gagal mengunggah gambar');
  //       }
  //     } catch (e) {
  //       throw Exception('Terjadi kesalahan saat mengunggah gambar: $e');
  //     }
  //   }

  //   final response = await _postRequest(_insertEventEndpoint, body);
  //   if (response.statusCode == 201) {
  //     return true;
  //   } else {
  //     throw Exception('Gagal menambahkan event: ${response.body}');
  //   }
  // }

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

  static Future<List<dynamic>> getEventsByOrganizer(String idOrganizer) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/getEventsByOrganizer/$idOrganizer'),
        headers: _jsonHeaders(),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return List<dynamic>.from(responseData); // Ensure we return a List
      } else if (response.statusCode == 404) {
        throw Exception('Tidak ada event ditemukan untuk organizer ini');
      } else {
        throw Exception('Gagal mengambil data event: ${response.body}');
      }
    } catch (e) {
      print('Error in getEventsByOrganizer: $e');
      throw Exception('Terjadi kesalahan saat mengambil data event');
    }
  }

  static Future<Map<String, dynamic>> getDataOrganizer(
      String idOrganizer) async {
    print('idOrganizer: $idOrganizer'); // Debug print statement
    final response = await _postRequest('/getDataOrganizer', {
      'id_organizer': idOrganizer,
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Organizer tidak ditemukan!');
    } else {
      throw Exception('Gagal mengambil data organizer: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getParticipants(
      String idEvent) async {
    print('idEvent: $idEvent'); // Debug print statement
    final response = await http.post(
      Uri.parse('$_baseUrl/getParticipan'),
      headers: _jsonHeaders(),
      body: json.encode({'id_event': idEvent}),
    );

    print('Response: ${response.body}'); // Debug print statement

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return List<Map<String, dynamic>>.from(responseData);
    } else if (response.statusCode == 404) {
      throw Exception('Tidak ada peserta ditemukan untuk event ini');
    } else {
      throw Exception('Gagal mengambil data peserta: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getUserParticipation(
      String idUser) async {
    print('idUser: $idUser'); // Debug print statement
    final response = await _postRequest('/countUserParticipan', {
      'id_user': idUser,
    });
    print('Response: ${response.body}'); // Debug print statement
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return List<Map<String, dynamic>>.from(responseData);
    } else if (response.statusCode == 404) {
      throw Exception('Anda belum tergabung dalam event apapun');
    } else {
      throw Exception('Gagal mengambil data partisipasi: ${response.body}');
    }
  }

  // ON DEV ============================
  static Future<void> saveUserData(Map<String, String> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('id_user', userData['id_user'] ?? '');
    await prefs.setString('username', userData['username'] ?? '');
    await prefs.setString('nama_user', userData['nama_user'] ?? '');
    await prefs.setString('email_user', userData['email_user'] ?? '');
    await prefs.setString('tlpn_user', userData['tlpn_user'] ?? '');
    await prefs.setString('kota_user', userData['kota_user'] ?? '');
    print('Saved user data: $userData'); // Debug print statement
  }

  static Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    if (username == null) {
      return {};
    }

    final response = await http.get(Uri.parse('$_baseUrl/getUser/$username'));
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      print('Data User: ${userData['poin_user']}'); // Debug print statement
      return {
        // 'id_user': userData[index]["_id"] ?? '',]
        'id_user': userData["_id"] ?? '',
        'username': userData['username'] ?? '',
        'nama_user': userData['nama_user'] ?? '',
        'email_user': userData['email_user'] ?? '',
        'tlpn_user': userData['tlpn_user'] ?? '',
        'kota_user': userData['kota_user'] ?? '',
        'poin_user': (userData['poin_user'] ?? 0).toString(),
      };
    } else {
      print('Failed to retrieve user data: ${response.body}');
      return {};
    }
  }

  static Future<Map<String, String>> getOrganizerData() async {
    final prefs = await SharedPreferences.getInstance();
    final emailOrganizer = prefs.getString('email_organizer');
    print('Email Organizer: $emailOrganizer'); // Debugging

    if (emailOrganizer == null) {
      print('Email organizer tidak ditemukan di SharedPreferences');
      return {};
    }

    final response =
        await http.get(Uri.parse('$_baseUrl/getOrganizer/$emailOrganizer'));
    if (response.statusCode == 200) {
      final organizerData = json.decode(response.body);
      return {
        'id_organizer': organizerData["_id"] ?? '',
        'nama_organizer': organizerData['nama_organizer'] ?? '',
        'email_organizer': organizerData['email_organizer'] ?? '',
        'tlpn_organizer': organizerData['tlpn_organizer'] ?? '',
        'kota_organizer': organizerData['kota_organizer'] ?? '',
        'alamat_organizer': organizerData['alamat_organizer'] ?? '',
      };
    } else {
      print('Failed to retrieve organizer data: ${response.body}');
      return {};
    }
  }

  // ON DEV ============================
  // Function to get tickets
  // static Future<List<dynamic>> getTickets(id_user) async {
  //   final response = await _postRequest(_getTicketsEndpoint, {
  //     'id_user': id_user,
  //   });

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     print('Tickets: $data'); // Debug print statement
  //     return data is List ? data : [data];
  //   } else {
  //     throw Exception('Failed to load tickets: ${response.body}');
  //   }
  // }

  static Future<List<dynamic>> getTickets(String idUser) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$_getTicketsEndpoint/$idUser'),
      headers: _jsonHeaders(),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        return responseData['data'];
      } else {
        throw Exception('Failed to load tickets: ${responseData['message']}');
      }
    } else if (response.statusCode == 404) {
      throw Exception('Anda belum memiliki ticket');
    } else {
      throw Exception('Failed to load tickets: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> createReservation({
    required String idUser,
    required String idEvent,
    required String namaTim,
    required String metode_pembayaran,
  }) async {
    final response = await _postRequest(_createReservation, {
      'id_user': idUser,
      'id_event': idEvent,
      'nama_tim': namaTim,
      'metode_pembayaran': metode_pembayaran,
    });

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      final responseData = json.decode(response.body);
      throw Exception(responseData['message'] ?? 'Terjadi kesalahan');
    }
  }

  // Fungsi untuk mendapatkan data reservasi
  static Future<List<Map<String, dynamic>>> getReservations(
      String idUser) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$_getReservationsEndpoint/$idUser'),
      headers: _jsonHeaders(),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success') {
        List<dynamic> data = responseData['data'];
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception(
            'Gagal memuat data reservasi: ${responseData['message']}');
      }
    } else {
      print('${response}');
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['message']);
    }
  }

  // Fungsi untuk membatalkan reservasi
  static Future<Map<String, dynamic>> cancelReservation(
      String reservationId) async {
    final response = await _postRequest('/cancelReservation', {
      'reservation_id': reservationId,
    });
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        print(responseData);
        return {
          'status': responseData['status'],
          'message': responseData['message'],
        };
      } else {
        return {
          'status': 'error',
          'message': responseData['message'],
        };
      }
    } else {
      return {
        'status': 'error',
        'message': 'Gagal membatalkan reservasi: ${response.body}',
      };
    }
  }

  // static Future<Map<String, dynamic>> createPayment({
  //   required String idReservasi,
  //   required int totalHarga,
  //   required String metodePembayaran,
  // }) async {
  //   print(
  //       'ID Reservasi: $idReservasi, Total Harga: $totalHarga, Metode Pembayaran: $metodePembayaran');
  //   final response = await _postRequest(_createPaymentEndpoint, {
  //     'id_reservasi': idReservasi,
  //     'total_harga': totalHarga,
  //     'metode_pembayaran': metodePembayaran,
  //   });

  //   print("response: ${response.body}");

  //   if (response.statusCode == 201) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('Gagal membuat pembayaran: ${response.body}');
  //   }
  // }

  static Future<Map<String, dynamic>> createPayment({
    required String idReservasi,
    required int totalHarga,
    required String metodePembayaran,
  }) async {
    try {
      final response = await _postRequest(_createPaymentEndpoint, {
        'id_reservasi': idReservasi,
        'total_harga': totalHarga,
        'metode_pembayaran': metodePembayaran,
      });

      final responseData = json.decode(response.body);
      // print("responseData ${responseData['data']['redirect_url']}");
      if (response.statusCode == 201) {
        // return {
        //   'status': 'success',
        //   'redirect_url': responseData['data']['redirect_url'],
        //   'payment_data': responseData
        // };
        return json.decode(response.body);
      } else {
        throw Exception(responseData['message'] ?? 'Gagal membuat pembayaran');
      }
    } catch (e) {
      debugPrint('Error creating payment: $e');
      rethrow;
    }
  }

  static Future<void> checkPaymentStatus(String orderId) async {
    try {
      final response =
          await _postRequest('/check-payment-status', {'order_id': orderId});

      final responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        throw Exception(
            responseData['message'] ?? 'Gagal memeriksa status pembayaran');
      }

      return responseData;
    } catch (e) {
      debugPrint('Error checking payment status: $e');
      rethrow;
    }
  }

  // Fungsi untuk mendapatkan data pembayaran berdasarkan id_reservasi
  static Future<Map<String, dynamic>> getPayment(String idReservasi) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/getPayment/$idReservasi'),
      headers: _jsonHeaders(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Pembayaran tidak ditemukan!');
    } else {
      throw Exception('Gagal mengambil data pembayaran: ${response.body}');
    }
  }

  // // Fungsi untuk mendapatkan data pengguna
  // static Future<Map<String, dynamic>> getUserData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final username = prefs.getString('username');
  //   if (username == null) {
  //     throw Exception('User data not found');
  //   }

  //   final response = await _getRequest('/getUser/$username');
  //   if (response.statusCode == 200) {
  //     final userData = json.decode(response.body);
  //     return userData;
  //   } else {
  //     throw Exception('Failed to retrieve user data: ${response.body}');
  //   }
  // }

  static Future<Map<String, dynamic>> processPayment({
    required String reservationId,
    required int amount,
  }) async {
    print('Reservation ID: $reservationId, Amount: $amount');
    final response = await _postRequest('/createPayment', {
      'reservation_id': reservationId,
      'amount': amount,
    });

    print('Payment Response: ${response.body}');
    if (response.statusCode == 201) {
      print('Payment berhasil kembali');
      return jsonDecode(response.body);
    } else {
      print('Payment gagal kembali');
      throw Exception('Failed to process payment: ${response.body}');
    }
  }

  // Fungsi untuk memperbarui status reservasi
  static Future<Map<String, dynamic>> updateReservationStatus({
    required String reservationId,
    required String status,
  }) async {
    final response = await _putRequest(_updateReservationStatus, {
      'reservation_id': reservationId,
      'status': status,
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update reservation status: ${response.body}');
    }
  }

  // Fungsi untuk menangani callback dari Midtrans
  static Future<void> handleMidtransCallback(
      Map<String, dynamic> callbackData) async {
    final String orderId = callbackData['order_id'];
    final String transactionStatus = callbackData['transaction_status'];
    final String fraudStatus = callbackData['fraud_status'];

    try {
      // Ambil data reservasi berdasarkan order_id
      final reservationResponse = await http.get(
        Uri.parse('$_baseUrl/getReservation/$orderId'),
        headers: _jsonHeaders(),
      );

      if (reservationResponse.statusCode != 200) {
        throw Exception('Reservasi tidak ditemukan!');
      }

      // Update status reservasi berdasarkan callback
      String updatedStatus;
      if (transactionStatus == 'capture' && fraudStatus == 'accept') {
        updatedStatus = 'Paid';
      } else if (transactionStatus == 'settlement') {
        updatedStatus = 'Paid';
      } else if (transactionStatus == 'cancel' ||
          transactionStatus == 'deny' ||
          transactionStatus == 'expire') {
        updatedStatus = 'Failed';
      } else if (transactionStatus == 'pending') {
        updatedStatus = 'Pending Payment';
      } else {
        throw Exception('Status transaksi tidak valid!');
      }

      // Kirim permintaan untuk memperbarui status reservasi
      await updateReservationStatus(
          reservationId: orderId, status: updatedStatus);
      print('Status pembayaran diperbarui!');
    } catch (e) {
      print('Gagal memperbarui status pembayaran: $e');
      throw Exception('Gagal memperbarui status pembayaran: $e');
    }
  }

  static Future<List<String>> getEnabledPaymentMethods() async {
    final response = await http.get(Uri.parse(_getEnabledPaymentMethodsUrl));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return List<String>.from(responseData['data']);
    } else {
      throw Exception('Gagal mengambil metode pembayaran: ${response.body}');
    }
  }

  // static Future<Map<String, dynamic>> uploadImage(String filePath) async {
  //   try {
  //     final url = Uri.parse('$_baseUrl/uploadImage');
  //     var request = http.MultipartRequest('POST', url);

  //     request.files.add(
  //       await http.MultipartFile.fromPath(
  //         'image',
  //         filePath,
  //         filename: 'event_${DateTime.now().millisecondsSinceEpoch}.jpg',
  //       ),
  //     );

  //     final response = await request.send();
  //     final responseData = await response.stream.bytesToString();
  //     print('Response: ${response}');
  //     print('Response Data: $responseData');
  //     if (response.statusCode == 200) {
  //       final decodedResponse = json.decode(responseData);
  //       if (decodedResponse['status'] == 'success') {
  //         return decodedResponse;
  //       } else {
  //         throw Exception(
  //             'Gagal mengunggah gambar: ${decodedResponse['message']}');
  //       }
  //     } else {
  //       throw Exception('Gagal mengunggah gambar: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Terjadi kesalahan saat mengunggah gambar: $e');
  //   }
  // }

  // static Future<bool> insertEvent({
  //   required String idOrganizer,
  //   required String nama,
  //   required String kategori,
  //   required String htm,
  //   required String tanggal,
  //   required String waktu,
  //   required String kota,
  //   required String alamat,
  //   required String deskripsi,
  //   required String
  //       image, // Ini sekarang adalah fileId dari gambar yang diupload
  // }) async {
  //   final response = await _postRequest(_insertEventEndpoint, {
  //     'id_organizer': idOrganizer,
  //     'nama_event': nama,
  //     'kategori_event': kategori,
  //     'htm_event': htm,
  //     'tanggal_event': tanggal,
  //     'waktu_event': waktu,
  //     'kota_event': kota,
  //     'alamat_event': alamat,
  //     'deskripsi_event': deskripsi,
  //     'imageId': image, // Gunakan field imageId untuk menyimpan ID gambar
  //   });

  //   if (response.statusCode == 201) {
  //     return true;
  //   } else {
  //     throw Exception('Gagal menyimpan event: ${response.body}');
  //   }
  // }
}


// Fungsi Create Reservation

