import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _keyUsername = 'username';
  static const String _keyIsLoggedIn = 'isLoggedIn';

  // Simpan informasi login
  static Future<void> saveLoginSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  // Hapus informasi login (logout)
  static Future<void> clearLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyIsLoggedIn);
  }

  // Cek apakah pengguna sudah login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Ambil username yang tersimpan
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }
}
