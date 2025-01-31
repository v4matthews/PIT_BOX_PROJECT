import 'package:flutter/material.dart';

class MyNavbar extends StatelessWidget {
  const MyNavbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1, // Index tab yang aktif
      selectedItemColor: Color(0xFFFFC700),
      unselectedItemColor: Colors.grey[600],
      backgroundColor: Colors.white,
      elevation: 8, // Memberikan bayangan pada navbar
      type: BottomNavigationBarType.fixed, // Semua item terlihat
      selectedFontSize: 14, // Ukuran teks yang dipilih
      unselectedFontSize: 12, // Ukuran teks yang tidak dipilih
      iconSize: 28, // Ukuran ikon
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
      ],
    );
  }
}
