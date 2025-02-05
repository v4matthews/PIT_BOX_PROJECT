import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_icon_shortcut.dart';
import 'package:pit_box/components/asset_navbar.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/session_service.dart'; // Import SessionService
import 'package:pit_box/race_page/all_page.dart';
import 'package:pit_box/user_pages/user_login_page.dart'; // Kategori Page

void main() {
  runApp(UserHome());
}

class UserHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        '/home': (context) => UserHome(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = 'Nama User';
  String userLocation = 'Lokasi User';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  void _getUserInfo() async {
    String name = await SessionService.getUsername() ?? 'Default Name';
    final lokasi = await SessionService.getUserData();
    setState(() {
      userName = name;
      userLocation = lokasi['kota_user'] ?? '';
    });
  }

  void _logout() async {
    await SessionService.clearLoginSession(); // Clear the session
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to login page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildCarousel(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 120,
      color: AppColors.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, $userName', //Nanti rubah jadi nama
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 20 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                userLocation, //Nanti rubah jadi lokasi
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 16 : 20,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout, // Call the logout function
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 800;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double carouselHeight = isSmallScreen
        ? screenHeight * 0.2
        : screenHeight * 0.3; // Adjusted height
    return Container(
      height: carouselHeight,
      child: PageView(
        children: [
          Image.asset(
            'assets/images/banner_imlek.jpg',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/banner.png',
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membangun GridView
  Widget _buildGrid(List items, int crossAxisCount) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (index < items.length) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllCatagories(
                    selectedClass: index == 0 ? null : items[index].label,
                  ),
                ),
              );
            }
          },
          child: items[index],
        );
      },
    );
  }

  Widget _buildContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    final items = [
      MyIconShortcut(initial: "H", label: "History"),
      MyIconShortcut(initial: "STO", label: "STO"),
      MyIconShortcut(initial: "DS", label: "Damper Style"),
      MyIconShortcut(initial: "STB UP", label: "STB UP"),
    ];

    final categoryItems = [
      MyIconShortcut(initial: "All", label: "All Class"),
      MyIconShortcut(initial: "STB", label: "STB"),
      MyIconShortcut(initial: "STB UP", label: "STB UP"),
      MyIconShortcut(initial: "STO", label: "STO"),
      MyIconShortcut(initial: "SD", label: "Damper Style"),
      MyIconShortcut(initial: "BMAX", label: "BMAX"),
      MyIconShortcut(initial: "NS", label: "Nascar"),
      MyIconShortcut(initial: "NS", label: "Sloop"),
    ];

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        children: [
          // Container untuk Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: _buildGrid(items, 4),
          ),

          // Category Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                const Text(
                  'Category',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(height: 2, color: Colors.grey),
                ),
              ],
            ),
          ),

          // GridView Category
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20),
            child: _buildGrid(categoryItems, 4),
          ),
        ],
      ),
    );
  }
}
