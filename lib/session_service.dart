import 'package:flutter/material.dart';
import 'package:pit_box/user_pages/user_login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pit_box/api_service.dart';

class SessionService {
  static const String _keyUsername = 'username';
  static const String _keyIsLoggedIn = 'isLoggedIn';

  // Save login session
  static Future<void> saveLoginSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  // Clear login session (logout)
  static Future<void> clearLoginSession(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Menghapus semua data sesi

    // Navigasi ke halaman login dengan menghapus semua halaman sebelumnya
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false, // Menghapus semua halaman sebelumnya
    );
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Get stored username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  // Save user data
  static Future<void> saveUserData(Map<String, String> userData) async {
    await ApiService.saveUserData(userData);
  }

  // Get user data
  static Future<Map<String, String>> getUserData() async {
    return await ApiService.getUserData();
  }
}
