import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_alert_logout.dart';
import 'package:pit_box/components/asset_navbar.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/organizer_pages/organizer_list_event.dart';
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
  final TextEditingController _namaOrganizerController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomortlpnController = TextEditingController();
  final TextEditingController _kotaController = TextEditingController();

  String _idOrganizer = '';
  String _eventBerjalan = '0';
  String _totalEvent = '0';
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await _loadOrganizerData();
      // Panggil _loadJumlahEvent setelah _loadOrganizerData selesai
      if (_idOrganizer.isNotEmpty) {
        await _loadJumlahEvent();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data. Silakan coba lagi.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
      _errorMessage = '';
    });

    try {
      await _loadOrganizerData();
      await _loadJumlahEvent();
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data. Silakan coba lagi.';
      });
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  Future<void> _loadOrganizerData() async {
    try {
      final organizerData = await SessionService.getOrganizerData();
      if (organizerData != null) {
        setState(() {
          _namaOrganizerController.text = organizerData['nama_organizer'] ?? '';
          _emailController.text = organizerData['email_organizer'] ?? '';
          _nomortlpnController.text = organizerData['tlpn_organizer'] ?? '';
          _kotaController.text = organizerData['kota_organizer'] ?? '';
          _idOrganizer = organizerData['id_organizer'] ?? '';
        });
      }
    } catch (e) {
      print('Error loading organizer data: $e');
      rethrow;
    }
  }

  Future<void> _loadJumlahEvent() async {
    try {
      if (_idOrganizer.isEmpty) return;

      final List<dynamic> eventData =
          await ApiService.getEventsByOrganizer(_idOrganizer);

      if (eventData != null) {
        final ongoingEvents = eventData
            .where((event) =>
                event['status_event'] == 'ongoing' ||
                event['status_event'] == 'upcoming')
            .length;

        final totalEvents = eventData
            .where((event) => event['status_event'] != 'canceled')
            .length;

        setState(() {
          _eventBerjalan = ongoingEvents.toString();
          _totalEvent = totalEvents.toString();
        });
      }
    } catch (e) {
      print('Error loading event data: $e');
      setState(() {
        _eventBerjalan = '0';
        _totalEvent = '0';
      });
      // Optionally show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data event')),
      );
    }
  }

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ).then((_) {
      // Refresh data when returning from other pages
      _refreshData();
    });
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
        body: _isLoading
            ? _buildLoadingView()
            : _errorMessage.isNotEmpty
                ? _buildErrorView()
                : RefreshIndicator(
                    onRefresh: _refreshData,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          _buildHeader(),
                          SizedBox(height: 20),
                          _buildEventStatsSection(),
                          SizedBox(height: 20),
                          _buildProfileInfoSection(),
                          SizedBox(height: 20),
                          _buildAccountSetting(),
                          SizedBox(height: 20),
                          if (_isRefreshing)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Memuat data...'),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 50),
          SizedBox(height: 20),
          Text(
            _errorMessage,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadInitialData,
            child: Text('Coba Lagi'),
          ),
        ],
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
              backgroundImage:
                  AssetImage('assets/images/icon/profile_organizer.png'),
            ),
          ),
          SizedBox(height: 15),
          Text(
            _namaOrganizerController.text,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              color: AppColors.whiteText,
            ),
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _navigateToPage(OrganizerRegisterEvent(
                    idOrganizer: _idOrganizer,
                  ));
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
            value: _eventBerjalan,
          ),
          _buildStatContainer(
            title: "Total Event",
            value: _totalEvent,
          ),
        ],
      ),
    );
  }

  Widget _buildStatContainer({
    required String title,
    required String value,
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
          _buildProfileRow('List Event',
              onTap: () => _navigateToPage(
                  OrganizerListEventPage(idOrganizer: _idOrganizer))),
          _buildProfileRow('Edit Event',
              onTap: () => _navigateToPage(
                  UserReservationListPage(userId: _idOrganizer))),
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
