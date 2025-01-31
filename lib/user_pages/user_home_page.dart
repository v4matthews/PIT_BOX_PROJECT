import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_icon_shortcut.dart';
import 'package:pit_box/components/asset_navbar.dart';
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
    setState(() {
      userName = name;
    });
  }

  void _logout() async {
    await SessionService.clearLoginSession(); // Clear the session
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to login page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildContent(),
          ],
        ),
      ),
      bottomNavigationBar: MyNavbar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 250,
      color: Color(0xFF4A59A9),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(),
          SizedBox(height: 50),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Padding kanan dan kiri
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, $userName',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                userLocation,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Padding kanan dan kiri
      child: Row(
        children: [
          // Tombol tiket
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Color(0xFFFFC700),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.confirmation_number_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                // Handle ticket button press
              },
            ),
          ),
          SizedBox(width: 10), // Jarak antara tombol tiket dan TextField
          // Kolom pencarian
          Expanded(
            child: TextField(
              onChanged: (value) {
                // Implement your filter logic here
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Container untuk Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              width: double.infinity,
              padding:
                  EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 30),
              child: Column(
                children: [
                  // Grid Items
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (index < 7) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllCatagories(
                                  selectedClass:
                                      index == 0 ? null : items[index].label,
                                ),
                              ),
                            );
                          }
                        },
                        child: items[index],
                      );
                    },
                  ),
                  SizedBox(height: 30),

                  // Card Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Card 1
                        Container(
                          width: (MediaQuery.of(context).size.width - 64) / 2,
                          child: Card(
                            color: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: Colors.grey, width: 1),
                            ),
                            child: Container(
                              height: isSmallScreen ? 100 : 130,
                              padding: EdgeInsets.only(left: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Point Anda',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 18 : 24,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    '0',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 24 : 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Card 2
                        Container(
                          width: (MediaQuery.of(context).size.width - 64) / 2,
                          child: Card(
                            color: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: Colors.grey, width: 1),
                            ),
                            child: Container(
                              height: isSmallScreen ? 100 : 130,
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Anda belum memiliki jadwal perlombaan',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20),
              child: Row(
                children: [
                  // Tulisan "Category"
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8), // Jarak antara teks dan garis
                  // Garis horizontal
                  Expanded(
                    child: Container(
                      height: 2, // Tinggi garis
                      color: Colors.grey, // Warna garis
                    ),
                  ),
                ],
              ),
            ),

            // Grid View Category
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: categoryItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (index < 8) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllCatagories(
                              selectedClass: index == 0
                                  ? null
                                  : categoryItems[index].label,
                            ),
                          ),
                        );
                      }
                    },
                    child: categoryItems[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
