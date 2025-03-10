import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_alert.dart';
import 'package:pit_box/components/asset_alert_confirmation.dart';
import 'package:pit_box/components/asset_button.dart';
import 'package:pit_box/components/asset_navbar.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/session_service.dart';
import 'package:pit_box/user_pages/user_reservation_list.dart';
import 'package:pit_box/user_pages/user_update_password.dart';
import 'package:pit_box/user_pages/user_update_profile.dart';
import 'package:pit_box/user_pages/user_update_profile_page.dart'; // Import halaman UserUpdateProfile
import 'package:pit_box/components/asset_alert.dart';
import 'package:pit_box/user_pages/user_class_info.dart'; // Import halaman ClassInformationPage

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController idUserController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController namaUserController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nomortlpnController = TextEditingController();
  final TextEditingController kotaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController statusUserController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final userData = await SessionService.getUserData();
    setState(() {
      usernameController.text = userData['username'] ?? '';
      namaUserController.text = userData['nama_user'] ?? '';
      _isLoading = false;
    });
  }

  void _navigateToPage(String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  void _navigateToClassInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClassInformationPage()),
    );
  }

  void _navigateToUpdateProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserUpdateProfile()),
    );
  }

  void _resevationList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReservationListPage()),
    );
  }

  void _navigateToUpdatePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdatePasswordPage()),
    );
  }

  void _confirmLogout() {
    showCustomLogoutDialog(
      context,
      () async {
        await _logout();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout berhasil!'),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }

  Future<void> _logout() async {
    await SessionService.clearLoginSession(); // Hapus session
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (Route<dynamic> route) => false,
    ); // Arahkan ke halaman login dan hapus semua rute sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: AppColors.whiteColor,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileHeader('/edit_profile'),
                      ],
                    ),
                  ),
                  // Bagian Info Profile
                  _buildProfileInfoSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Divider(
              color: Colors.grey,
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          _buildProfileRow('Class Event',
              "Mari mengenal Class perlombaan yang tersedia", '/classInfo',
              isEditable: false, onTap: _navigateToClassInfo),
          _buildProfileRow('Edit Profile', "Ubah dan sesuaikan profile Anda",
              '/edit_profile',
              onTap: _navigateToUpdateProfile),
          _buildProfileRow('Ubah Password',
              "Sesuaikan dan atur ulang kata sandi Anda", '/change_password',
              onTap: _navigateToUpdatePassword),
          _buildProfileRow(
              'List Reservasi', "Cek status Reservasi Anda", '/reservationList',
              onTap: _resevationList),
          _buildProfileLogout(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(String routeName) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: GestureDetector(
        onTap: () => _navigateToPage(routeName),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              namaUserController.text,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '@' + usernameController.text,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value, String routeName,
      {bool isEditable = true, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: GestureDetector(
        onTap: onTap ?? (isEditable ? () => _navigateToPage(routeName) : null),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right, // Ikon >
                  color: Colors.grey[600],
                  size: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileLogout() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: GestureDetector(
        onTap: _confirmLogout,
        child: Row(
          children: [
            Icon(
              Icons.logout, // Ikon logout
              color: AppColors.primaryText,
            ),
            SizedBox(width: 10),
            Text(
              "Logout",
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Icon(
              Icons.chevron_right, // Ikon >
              color: Colors.grey[600],
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
