import 'package:flutter/material.dart';
import 'package:pit_box/user_pages/user_home_page_old.dart';
import 'package:pit_box/user_pages/user_profile_page.dart';
import 'package:pit_box/race_page/all_page.dart';
import 'package:pit_box/user_pages/user_ticket.dart';

class MyNavbar extends StatelessWidget {
  final int currentIndex;

  const MyNavbar({Key? key, this.currentIndex = 0}) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/all');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/ticket');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex, // Index tab yang aktif
      selectedItemColor: Color(0xFFFFC700),
      unselectedItemColor: Colors.grey[600],
      backgroundColor: Colors.white,
      elevation: 8, // Memberikan bayangan pada navbar
      type: BottomNavigationBarType.fixed, // Semua item terlihat
      selectedFontSize: 14, // Ukuran teks yang dipilih
      unselectedFontSize: 12, // Ukuran teks yang tidak dipilih
      iconSize: 28, // Ukuran ikon
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'All Class',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.confirmation_number),
          label: 'Tickets',
        ),
      ],
    );
  }
}
