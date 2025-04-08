import 'package:flutter/material.dart';
import 'package:pit_box/user_pages/user_login_page.dart';
import 'package:pit_box/organizer_pages/organizer_login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pit_box/api_service.dart';

class SessionService {
  // Key untuk shared preferences
  static const String _keyUsername = 'username';
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUserType = 'userType'; // 'user' atau 'organizer'
  static const String _keyUserId = 'userId';

  // Simpan session login
  // Simpan session login
  static Future<void> saveLoginSession({
    required String username,
    required String userType, // 'user' atau 'organizer'
    String? emailOrganizer,
  }) async {
    print("saveLoginSession: $username, $userType");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyUserType, userType);
    await prefs.setBool(_keyIsLoggedIn, true);

    // Cetak username jika userType adalah 'organizer'
    if (userType == 'organizer' && emailOrganizer != null) {
      await prefs.setString('email_organizer', emailOrganizer);
    }
  }

  // Logout
  static Future<void> clearLoginSession(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Dapatkan tipe user sebelum logout untuk redirect ke halaman login yang tepat
    final userType = prefs.getString(_keyUserType);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
            userType == 'organizer' ? OrganizerLoginPage() : LoginPage(),
      ),
      (route) => false,
    );
  }

  // Cek status login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Dapatkan username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  // Dapatkan user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  // Dapatkan tipe user
  static Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserType);
  }

  // Simpan data user
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await ApiService.saveUserData(
        userData.map((key, value) => MapEntry(key, value.toString())));
  }

  // Dapatkan data user
  static Future<Map<String, dynamic>> getUserData() async {
    return await ApiService.getUserData();
  }

  static Future<Map<String, dynamic>> getOrganizerData() async {
    return await ApiService.getOrganizerData();
  }

  // Redirect berdasarkan tipe user
  static Future<void> redirectBasedOnUserType(BuildContext context) async {
    final userType = await getUserType();

    if (userType == 'organizer') {
      Navigator.pushReplacementNamed(context, '/homeOrganizer');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}
