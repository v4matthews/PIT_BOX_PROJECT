import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_loading.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/race_page/all_page.dart';
import 'package:pit_box/session_service.dart';
import 'package:pit_box/utils/location_list.dart';
import 'package:pit_box/components/asset_list_view.dart';

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  String userName = "User";
  String userLocation = "User Location";
  String userPoin = '0';
  bool isLoading = true;
  List raceEvents = [];

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _getRaceEvents();
  }

  void _getUserInfo() async {
    final userData = await SessionService.getUserData();
    setState(() {
      userName = userData['nama_user'] ?? 'User';
      userLocation = userData['kota_user'] ?? 'User Location';
      userPoin = userData['poin_user'] ?? '0';
      isLoading = false;
    });
  }

  void _getRaceEvents() async {
    try {
      final response = await ApiService.getFilteredEvents();
      setState(() {
        raceEvents = response['events'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data perlombaan: $e')),
      );
    }
  }

  void _updateLocation(String newLocation) {
    setState(() {
      userLocation = newLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        toolbarHeight: 0, // This makes the AppBar height 0
      ),
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: isLoading
            ? LoadingWidget(text: "Memuat data...")
            // ? Center(
            //     child: CircularProgressIndicator(),
            //   )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Container 1: Informasi Pengguna
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      decoration: BoxDecoration(
                          // color: AppColors.whi,
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
                                  fontFamily: 'Montserrat',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.notifications,
                                  color: AppColors.primaryText,
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Notifikasi ditekan!")),
                                  );
                                },
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              final selectedLocation = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LocationListPage(),
                                ),
                              );
                              if (selectedLocation != null) {
                                _updateLocation(selectedLocation);
                              }
                            },
                            child: Text(
                              userLocation,
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.primaryText,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          TextField(
                            decoration: InputDecoration(
                              hintText: "Cari class lomba / kategori",
                              filled: true,
                              fillColor: AppColors.whiteColor,
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              hintStyle:
                                  TextStyle(color: AppColors.primaryText),
                            ),
                            style: TextStyle(color: AppColors.primaryText),
                            onSubmitted: (query) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllCatagories(
                                    searchQuery: query,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Carousel Gambar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: 200,
                        child: PageView.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/carousel/carousel_$index.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        children: [
                          // Bagian 2: ListView Horizontal
                          SizedBox(
                            height: 75,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _buildHorizontalCard(150, "Race Point",
                                    userPoin, "assets/images/icon/poin.svg"),
                                _buildHorizontalCard(
                                    225,
                                    "Jadwal Race",
                                    "Belum ada jadwal",
                                    "assets/images/icon/jadwal.svg"),
                                _buildHorizontalCard(160, "Perlombaan", "5",
                                    "assets/images/icon/checklist.svg"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10),

                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Text(
                              "Find Your Class",
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

                    // Grid View Kategori
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 8,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1 / 1,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          return _buildGridItem(index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHorizontalCard(
      double width, String title, String value, String icon) {
    return Container(
      width: width,
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black26.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
                textAlign: TextAlign.left,
                softWrap: true,
              ),
            ],
          ),
          SizedBox(width: 10),
          SvgPicture.asset(
            icon,
            width: 35,
            height: 35,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(int index) {
    List<Map<String, dynamic>> items = [
      {"label": "All Class", "key": "", "icon": "assets/images/icon/all.svg"},
      {"label": "STB", "key": "STB", "icon": "assets/images/icon/stb.svg"},
      {
        "label": "STB UP",
        "key": "STB UP",
        "icon": "assets/images/icon/stbup.svg"
      },
      {"label": "STO", "key": "STO", "icon": "assets/images/icon/sto.svg"},
      {
        "label": "Damper Tune",
        "key": "damperstyletune",
        "icon": "assets/images/icon/tune.svg"
      },
      {
        "label": "Damper Dash",
        "key": "damperstyledash",
        "icon": "assets/images/icon/dash.svg"
      },
      {
        "label": "Sloop",
        "key": "Sloop",
        "icon": "assets/images/icon/sloop.svg"
      },
      {
        "label": "Nascar",
        "key": "Nascar",
        "icon": "assets/images/icon/nascar.svg"
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
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black26.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              items[index]['icon'],
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 5),
            Text(
              items[index]['label'],
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
