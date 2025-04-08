import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_alert_logout.dart';
import 'package:pit_box/components/asset_navbar.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/organizer_pages/organizer_register_event.dart';
import 'package:pit_box/session_service.dart';
import 'package:pit_box/user_pages/user_dashboard.dart';
import 'package:pit_box/user_pages/user_reservation_list.dart';
import 'package:pit_box/user_pages/user_update_password.dart';
import 'package:pit_box/user_pages/user_update_profile.dart';
import 'package:pit_box/user_pages/user_class_info.dart';

class OrganizerHomePage extends StatefulWidget {
  @override
  _OrganizerHomePageState createState() => _OrganizerHomePageState();
}

class _OrganizerHomePageState extends State<OrganizerHomePage> {
  final TextEditingController namaOrganizerController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nomortlpnController = TextEditingController();
  final TextEditingController kotaController = TextEditingController();
  String idUser = '';

  @override
  void initState() {
    super.initState();
    _loadOrganizerData();
  }

  Future<void> _loadOrganizerData() async {
    try {
      final organizerData = await SessionService.getOrganizerData();
      setState(() {
        namaOrganizerController.text = organizerData['nama_organizer'] ?? '';
        emailController.text = organizerData['email_organizer'] ?? '';
        nomortlpnController.text = organizerData['tlpn_organizer'] ?? '';
        kotaController.text = organizerData['kota_organizer'] ?? '';
        idUser = organizerData['id_user'] ?? '';
      });
    } catch (e) {
      // Handle error
      print('Error loading organizer data: $e');
    }
  }

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _confirmLogout() {
    showCustomLogoutDialog(
      context,
      () async {
        await SessionService.clearLoginSession(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout berhasil!'),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              _buildEventStatsSection(),
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

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 70),
          CircleAvatar(
            backgroundColor: AppColors.whiteColor,
            radius: 55,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/icon/profile.png'),
            ),
          ),
          SizedBox(height: 15),
          Text(
            'Halo, ${namaOrganizerController.text}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              color: AppColors.whiteText,
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _navigateToPage(OrganizerRegisterEvent());
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Tambah Pertandingan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.add_box_rounded,
                      color: AppColors.primaryText,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEventStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatContainer(
            title: "Event Berjalan",
            value: "5", // Replace with dynamic data
            color: Colors.blue,
          ),
          _buildStatContainer(
            title: "Total Event",
            value: "20", // Replace with dynamic data
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildStatContainer({
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
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
          _buildSectionHeader('Manajemen Event'),
          _buildProfileRow('Tambah Event',
              onTap: () => _navigateToPage(ClassInformationPage())),
          _buildProfileRow('List Event',
              onTap: () =>
                  _navigateToPage(UserReservationListPage(userId: idUser))),
          SizedBox(height: 30),
          _buildSectionHeader('Account Setting'),
          _buildProfileRow('Edit Profile',
              onTap: () => _navigateToPage(UserUpdateProfile())),
          _buildProfileRow('Ubah Password',
              onTap: () => _navigateToPage(UpdatePasswordPage())),
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

  Widget _buildProfileRow(String label, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
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
      ),
    );
  }

  Widget _buildProfileLogout() {
    return GestureDetector(
      onTap: _confirmLogout,
      child: Row(
        children: [
          Icon(
            Icons.logout,
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
    );
  }
}
