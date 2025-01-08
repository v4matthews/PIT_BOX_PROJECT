import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_icon_shortcut.dart';
import 'package:pit_box/components/asset_navbar.dart';

// categori page
import 'package:pit_box/race_page/all_page.dart';

void main() {
  runApp(UserHome());
}

class UserHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Header section
          Container(
            color: Color(0xFF4A59A9),
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content section
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllCatagories()),
                            );
                          },
                          child: MyIconShortcut(
                              initial: "All", label: "All Class"),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllCatagories(
                                  selectedClass: "STO",
                                ),
                              ),
                            );
                          },
                          child: MyIconShortcut(initial: "STO", label: "STO"),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllCatagories(
                                  selectedClass: "Damper Style",
                                ),
                              ),
                            );
                          },
                          child: MyIconShortcut(
                              initial: "DS", label: "Damper Style"),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllCatagories(
                                  selectedClass: "STB UP",
                                ),
                              ),
                            );
                          },
                          child: MyIconShortcut(
                              initial: "STB UP", label: "STB UP"),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllCatagories(
                                  selectedClass: "STB",
                                ),
                              ),
                            );
                          },
                          child: MyIconShortcut(initial: "STB", label: "STB"),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllCatagories(
                                  selectedClass: "Sloop",
                                ),
                              ),
                            );
                          },
                          child: MyIconShortcut(initial: "SLP", label: "Sloop"),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllCatagories(
                                  selectedClass: "Nascar",
                                ),
                              ),
                            );
                          },
                          child: MyIconShortcut(initial: "NS", label: "Nascar"),
                        ),
                        MyIconShortcut(initial: "H", label: "My History"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyNavbar(),
    );
  }

  //     bottomNavigationBar: BottomNavigationBar(
  //       backgroundColor: Colors.white,
  //       selectedItemColor: Colors.yellow,
  //       unselectedItemColor: Colors.grey,
  //       currentIndex: 1, // Highlight "Home"
  //       items: [
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.confirmation_number),
  //           label: 'My Ticket',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.home),
  //           label: 'Home',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.person),
  //           label: 'Account',
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildIconButton(String label, IconData icon) {
  //   return Column(
  //     children: [
  //       CircleAvatar(
  //         radius: 24,
  //         backgroundColor: Colors.grey[300],
  //         child: Icon(
  //           icon,
  //           color: Colors.grey[600],
  //         ),
  //       ),
  //       SizedBox(height: 8),
  //       Text(
  //         label,
  //         textAlign: TextAlign.center,
  //         style: TextStyle(
  //           fontSize: 12,
  //           color: Colors.black,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
