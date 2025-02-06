import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/race_page/all_page.dart';
import 'package:pit_box/session_service.dart';

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  String userName = "User";
  String userLocation = "User Location";
  String userPoin = '0';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  void _getUserInfo() async {
    final userData = await SessionService.getUserData();
    setState(() {
      userName = userData['nama_user'] ?? 'User';
      userLocation = userData['kota_user'] ?? 'User Location';
      userPoin = userData['poin_user'] ?? '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Container 1: Informasi Pengguna
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Halo, $userName",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Notifikasi ditekan!")),
                            );
                          },
                        ),
                      ],
                    ),
                    Text(
                      userLocation,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[300],
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Search...",
                        filled: true,
                        fillColor: AppColors.whiteColor,
                        prefixIcon:
                            Icon(Icons.search, color: AppColors.primaryText),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: TextStyle(color: AppColors.primaryText),
                      ),
                      style: TextStyle(color: AppColors.primaryText),
                    ),
                  ],
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  children: [
                    // Bagian 1: Carousel
                    SizedBox(
                      height: 180,
                      child: PageView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/banner_imlek.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 30),

                    // Bagian 2: ListView Horizontal
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          // Contoh card horizontal
                          _buildHorizontalCard("Poin", userPoin, Colors.blue),
                          _buildHorizontalCard("Tickets", "Go", Colors.orange),
                          _buildHorizontalCard("Perlombaan", "5", Colors.green),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Text(
                              "Category",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.black26,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 5),

                    // Bagian 3: Grid View
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 8,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return _buildGridItem(index);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalCard(String title, String value, Color color) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black26.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(int index) {
    List<Map<String, dynamic>> items = [
      {
        "label": "All Class",
        "key": "",
        "icon": "../assets/images/icon/allclass.png"
      },
      {"label": "STB", "key": "STB", "icon": "../assets/images/icon/stb.png"},
      {
        "label": "STB UP",
        "key": "STB UP",
        "icon": "../assets/images/icon/stbup.png"
      },
      {"label": "STO", "key": "STO", "icon": "../assets/images/icon/sto.png"},
      {
        "label": "DAMPER TUNE",
        "key": "Damper Style",
        "icon": "../assets/images/icon/tune.png"
      },
      {
        "label": "DAMPER DASH",
        "key": "Damper Style",
        "icon": "../assets/images/icon/dash.png"
      },
      {
        "label": "SLOOP",
        "key": "Sloop",
        "icon": "../assets/images/icon/sloop.png"
      },
      {
        "label": "NASCAR",
        "key": "Nascar",
        "icon": "../assets/images/icon/nascar.png"
      },
    ];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllCatagories(
              selectedClass: items[index]['key'],
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black12, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black26.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.start, // Menyusun secara horizontal
          children: [
            Image.asset(
              items[index]['icon'],
              width: 75, // Sesuaikan ukuran ikon
              height: 75,
              fit: BoxFit.contain,
            ),
            // Memberi jarak antara ikon dan teks
            Text(
              items[index]['label'],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
