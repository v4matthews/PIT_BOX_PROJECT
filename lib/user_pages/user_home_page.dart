import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_datepicker.dart';
import 'package:pit_box/components/asset_datepicker_appbar.dart';
import 'package:pit_box/components/asset_list_view_home.dart';
import 'package:pit_box/components/asset_loading.dart';
import 'package:pit_box/components/asset_searchbar_home.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/race_page/event_list_page.dart';
import 'package:pit_box/session_service.dart';
import 'package:pit_box/user_pages/user_detail_poin.dart';
import 'package:pit_box/user_pages/user_ticket.dart';
import 'package:pit_box/utils/location_list.dart';
import 'package:pit_box/components/asset_list_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String userName = "User";
  String userLocation = "User Location";
  String userPoin = '0';
  String userSchedule = 'Belum ada jadwal';
  String userRace = '0';
  bool isLoading = true;
  List raceEvents = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _getUserInfo(),
      _getRaceEvents(),
      _getUpcomingRaceSchedule(),
      _getUserParticipationCount(),
    ]);
    setState(() => isLoading = false);
  }

  void _onRefresh() async {
    try {
      await Future.wait([
        _getUserInfo(),
        _getRaceEvents(),
        _getUpcomingRaceSchedule(),
        _getUserParticipationCount(),
      ]);
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui data: $e')),
      );
    }
  }

  Future<void> _getUserInfo() async {
    final userData = await SessionService.getUserData();
    setState(() {
      userName = userData['nama_user'] ?? 'User';
      userLocation = userData['kota_user'] != null
          ? userData['kota_user']!
              .split(' ')
              .map((word) =>
                  word[0].toUpperCase() + word.substring(1).toLowerCase())
              .join(' ')
          : 'User Location';
      userPoin = userData['poin_user']?.toString() ?? '0';
    });
  }

  Future<void> _getRaceEvents() async {
    try {
      final response = await ApiService.getFilteredEvents();
      setState(() => raceEvents = response['events'] ?? []);
    } catch (e) {}
  }

  Future<void> _updateLocation(String newLocation) async {
    setState(() {
      userLocation = newLocation
          .split(' ')
          .map(
              (word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
          .join(' ');
    });
    await _getRaceEvents(); // Refresh events when location changes
  }

  Future<void> _getUpcomingRaceSchedule() async {
    try {
      final userData = await SessionService.getUserData();
      final userId = userData['id_user'] ?? '';

      if (userId.isEmpty) {
        setState(() => userSchedule = "User ID tidak ditemukan");
        return;
      }

      final tickets = await ApiService.getTickets(userId);
      final now = DateTime.now();
      final sevenDaysFromNow = now.add(Duration(days: 7));

      final upcomingTickets = tickets.where((ticket) {
        if (ticket['tanggal_event'] == null) return false;
        final eventDate = DateTime.parse(ticket['tanggal_event']);
        return eventDate.isAfter(now) && eventDate.isBefore(sevenDaysFromNow);
      }).toList();

      setState(() {
        userSchedule = upcomingTickets.isNotEmpty
            ? "${upcomingTickets.first['nama_event']}"
            : "Belum ada jadwal";
      });
    } catch (e) {}
  }

  Future<void> _getUserParticipationCount() async {
    try {
      final userData = await SessionService.getUserData();
      final userId = userData['id_user'] ?? '';

      if (userId.isEmpty) {
        setState(() => userRace = "0");
        return;
      }

      final participationData = await ApiService.getUserParticipation(userId);
      setState(() => userRace = participationData.length.toString());
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                ),
              ),
            ),
            Positioned.fill(
              child: isLoading
                  ? LoadingWidget(text: "Memuat data...")
                  : SmartRefresher(
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            _buildHorizontalListSection(),
                            _buildCarouselSection(),
                            _buildGridViewSection(),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false, // Removes the back arrow
      flexibleSpace: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      toolbarHeight: 175,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lokasi Anda",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              color: AppColors.whiteText,
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.orangeColor,
                    size: 20,
                  ),
                  SizedBox(width: 5),
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
                    child: Row(
                      children: [
                        Text(
                          userLocation,
                          style: TextStyle(
                            fontSize: 18,
                            letterSpacing: 1,
                            color: AppColors.whiteText,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down_rounded,
                          color: AppColors.whiteText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          PitboxSearchbar(
            searchController: controller,
            onSearch: (query) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllCatagories(
                    searchQuery: query,
                    userLocation: userLocation.toUpperCase(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                    SnackBar(content: Text("Notifikasi ditekan!")),
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
              prefixIcon: Icon(Icons.search, color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black),
              ),
              hintStyle: TextStyle(color: AppColors.primaryText),
            ),
            style: TextStyle(color: AppColors.primaryText),
            onSubmitted: (query) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllCatagories(
                    searchQuery: query,
                    userLocation: userLocation.toUpperCase(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Container(
        height: 175,
        child: PageView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image:
                      AssetImage('assets/images/carousel/carousel_$index.png'),
                  fit: BoxFit.fill,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHorizontalListSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20), // Tambahkan padding horizontal
      child: Row(
        children: [
          Expanded(
            flex: 3, // Jadwal Race lebih panjang
            child: _buildHorizontalCard(
              "Jadwal Race",
              userSchedule,
              "assets/images/icon/jadwal.svg",
            ),
          ),
          SizedBox(width: 10), // Jarak antar kartu
          Expanded(
            flex: 2, // Perlombaan lebih pendek
            child: _buildHorizontalCard(
              "Perlombaan",
              userRace,
              "assets/images/icon/checklist.svg",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFindYourClassSection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
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
    );
  }

  Widget _buildGridViewSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
    );
  }

  Widget _buildHorizontalCard(String title, String value, String icon) {
    return GestureDetector(
      onTap: () {
        if (title == "Jadwal Race" && userSchedule != "Belum ada jadwal") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TicketListPage(),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
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
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ],
              ),
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
        "key": "DAMPER TUNE",
        "icon": "assets/images/icon/tune.svg"
      },
      {
        "label": "Damper Dash",
        "key": "DAMPER DASH",
        "icon": "assets/images/icon/dash.svg"
      },
      {
        "label": "Sloop",
        "key": "SLOOP",
        "icon": "assets/images/icon/sloop.svg"
      },
      {
        "label": "Nascar",
        "key": "NASCAR",
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
              userLocation: userLocation.toUpperCase(),
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
