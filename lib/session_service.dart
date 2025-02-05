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
  static Future<void> clearLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove('id_user');
    await prefs.remove('nama_user');
    await prefs.remove('email_user');
    await prefs.remove('tlpn_user');
    await prefs.remove('kota_user');
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
