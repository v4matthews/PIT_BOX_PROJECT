import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrganizerDashboard extends StatefulWidget {
  const OrganizerDashboard({Key? key}) : super(key: key);

  @override
  _OrganizerDashboardState createState() => _OrganizerDashboardState();
}

class _OrganizerDashboardState extends State<OrganizerDashboard> {
  String? namaOrganizer;

  @override
  void initState() {
    super.initState();
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      namaOrganizer = prefs.getString('namaOrganizer') ?? '-';
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(screenHeight),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildHeader(double screenHeight) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.3,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: _buildProfileSection(),
          ),
          _buildSettingsButton(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 40),
        CircleAvatar(
          radius: 16,
          backgroundImage: namaOrganizer != '-'
              ? const AssetImage('assets/profile_placeholder.png')
              : null,
          child: namaOrganizer == '-'
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 10),
        Text(
          namaOrganizer ?? '-',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/cek_margin');
          },
          child: const Text('Cek Margin'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/insertRace');
          },
          child: const Text('Tambah Event'),
        ),
      ],
    );
  }

  Widget _buildSettingsButton() {
    return Positioned(
      top: 10,
      right: 10,
      child: IconButton(
        icon: const Icon(Icons.settings, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(context, '/profile');
        },
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(text: 'Dashboard'),
                Tab(text: 'Pertandingan'),
                Tab(text: 'Laporan'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildDashboardContent(),
                  Center(
                    child: Text(
                      'Konten Pertandingan',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Konten Laporan',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildDashboardCard('Total Event Dibuat', '10')),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildDashboardCard('Pendapatan', 'Rp 5.000.000')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildDashboardCard('Event Aktif', '3')),
              const SizedBox(width: 10),
              Expanded(child: _buildDashboardCard('Event Selesai', '7')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
