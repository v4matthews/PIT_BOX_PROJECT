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
import 'package:pit_box/user_pages/user_update_profile_page.dart'; // Import halaman UserUpdateProfile
import 'package:pit_box/components/asset_alert.dart';
import 'package:pit_box/user_pages/user_class_info.dart'; // Import halaman ClassInformationPage

class OrganizerProfilePage extends StatefulWidget {
  @override
  _OrganizerProfilePageState createState() => _OrganizerProfilePageState();
}

class _OrganizerProfilePageState extends State<OrganizerProfilePage> {
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
    // Navigator.pushNamedAndRemoveUntil(
    //   context,
    //   '/login',
    //   (Route<dynamic> route) => false,
    // ); // Arahkan ke halaman login dan hapus semua rute sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigasi ke halaman utama saat tombol back ditekan
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UserDashboard()),
          (route) => false, // Menghapus semua halaman sebelumnya
        );
        return false; // Mencegah aksi back default
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundGrey,
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/bg.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileHeader(),
                        ],
                      ),
                    ),
                    // Bagian Info Profile
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

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.whiteColor,
            radius: 60,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.whiteColor, // Set the border color
                  width: 3.0, // Set the border width
                ),
              ),
            ),
            backgroundImage: AssetImage(
                'assets/images/icon/profile.png'), // Replace with your profile icon asset
          ),
          SizedBox(height: 10),
          Text(
            'Halo, ' + namaUserController.text,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
                color: AppColors.whiteText),
          ),
          SizedBox(height: 4),
          Text(
            '@' + usernameController.text,
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'OpenSans',
                color: AppColors.whiteText),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProfileStat('Poin', userPoin), // Replace with actual data
              Container(
                height: 30,
                child: VerticalDivider(
                  color: AppColors.whiteText,
                  thickness: 1,
                ),
              ),
              _buildProfileStat('Race', userRace), // Replace with actual data
              Container(
                height: 30,
                child: VerticalDivider(
                  color: AppColors.whiteText,
                  thickness: 1,
                ),
              ),
              _buildProfileStat('Win', userWin), // Replace with actual data
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteText),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.whiteText,
          ),
        ),
      ],
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
                // fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
