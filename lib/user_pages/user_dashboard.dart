import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/user_pages/user_home_page.dart';
import 'package:pit_box/user_pages/user_home_page_old.dart';
import 'package:pit_box/user_pages/user_ticket.dart';
import 'package:pit_box/user_pages/user_profile_page.dart';
import 'package:pit_box/utils/date_picker.dart';
import 'package:pit_box/utils/location_list.dart';

class UserDashboard extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserDashboard> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    TicketListPage(), // Halaman Ticket
    UserHomePage(), // Konten halaman Home
    // DatePickerPage(),
    UserProfilePage(), // Halaman Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: const Color(0xFF379777),
      //   title: _selectedIndex == 0
      //       ? Text(
      //           'Ticket',
      //           style: TextStyle(
      //             color: const Color(0xFFF4CE14),
      //             fontSize: 18,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         )
      //       : _selectedIndex == 1
      //           ? Text(
      //               'Home',
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 18,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             )
      //           : _selectedIndex == 2
      //               ? Text(
      //                   'Profile',
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 18,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                 )
      //               : Text(''),
      // ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number), label: 'Ticket'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.accentColor,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Buat halaman HomeContent sebagai contoh
class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Welcome to Home',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
