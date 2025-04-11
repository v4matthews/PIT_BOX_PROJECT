import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_alert.dart';
import 'package:pit_box/components/asset_alert_cancel_reservation.dart';
import 'package:pit_box/components/asset_alert_logout.dart';
import 'package:pit_box/components/asset_button.dart';
import 'package:pit_box/components/asset_navbar.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/session_service.dart';
import 'package:pit_box/user_pages/user_dashboard.dart';
import 'package:pit_box/user_pages/user_reservation_list.dart';
import 'package:pit_box/user_pages/user_update_password.dart';
import 'package:pit_box/user_pages/user_update_profile.dart';
import 'package:pit_box/user_pages/user_update_profile_page.dart';
import 'package:pit_box/user_pages/user_class_info.dart';

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
  String idUser = '';
  String userPoin = '0';
  String userRace = '0';
  String userWin = '0';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final userData = await SessionService.getUserData();
    print(userData);
    setState(() {
      usernameController.text = userData['username'] ?? '';
      namaUserController.text = userData['nama_user'] ?? '';
      userPoin = userData['poin_user'] ?? '';
      idUser = userData['id_user'] ?? '';
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
      MaterialPageRoute(
          builder: (context) => UserReservationListPage(userId: idUser)),
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
    await SessionService.clearLoginSession(context); // Hapus session
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UserDashboard()),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundGrey,
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    _buildProfileHeaderSection(),
                    SizedBox(height: 20),
                    _buildProfileInfoSection(),
                    SizedBox(height: 20),
                    _buildAccountSetting(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProfileHeaderSection() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60),
          Text(
            'Halo, ${namaUserController.text}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              color: AppColors.whiteText,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '@${usernameController.text}',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'OpenSans',
              color: AppColors.whiteText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          _buildSectionHeader('Pitbox Section'),
          _buildProfileRow('Class Event',
              isEditable: false, onTap: _navigateToClassInfo),
          _buildProfileRow('List Reservasi', onTap: _resevationList),
          SizedBox(height: 30),
          _buildSectionHeader('Account Setting'),
          _buildProfileRow('Edit Profile', onTap: _navigateToUpdateProfile),
          _buildProfileRow('Ubah Password', onTap: _navigateToUpdatePassword),
        ],
      ),
    );
  }

  Widget _buildAccountSetting() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          _buildProfileLogout(),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String label,
      {bool isEditable = true, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: _confirmLogout,
        child: Row(
          children: [
            Icon(
              Icons.logout, // Ikon logout
              color: AppColors.redColor,
            ),
            SizedBox(width: 10),
            Text(
              "Logout",
              style: TextStyle(
                color: AppColors.redColor,
                fontSize: 18,
                fontFamily: 'OpenSans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
