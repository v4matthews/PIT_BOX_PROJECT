import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_icon_shortcut.dart';
import 'package:pit_box/components/asset_navbar.dart';

// kategori page
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
  final List<String> imagePaths = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PITBOX",
          style: TextStyle(
            fontWeight: FontWeight.bold, // Membuat teks bold
            fontSize: 20, // Ukuran teks
          ),
        ),
        backgroundColor: const Color(0xFF4A59A9), // Warna biru untuk AppBar
        foregroundColor: Colors.white, // Warna teks
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            // Carousel Section
            CarouselSlider(
              items: imagePaths
                  .map(
                    (path) => Image.asset(
                      path,
                      fit: BoxFit.cover,
                      width: screenWidth, // Responsif terhadap lebar layar
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: screenHeight * 0.3, // Responsif terhadap tinggi layar
                autoPlay: true,
                viewportFraction: 1.0, // Item memenuhi seluruh lebar layar
                enlargeCenterPage: false,
              ),
            ),

            const SizedBox(width: 16.0),

            // Content Section
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Responsif jumlah kolom berdasarkan lebar layar
                    int crossAxisCount = 4;

                    return GridView.builder(
                      itemCount: 8,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) {
                        final items = [
                          MyIconShortcut(initial: "All", label: "All Class"),
                          MyIconShortcut(initial: "STO", label: "STO"),
                          MyIconShortcut(initial: "DS", label: "Damper Style"),
                          MyIconShortcut(initial: "STB UP", label: "STB UP"),
                          MyIconShortcut(initial: "STB", label: "STB"),
                          MyIconShortcut(initial: "SLP", label: "Sloop"),
                          MyIconShortcut(initial: "NS", label: "Nascar"),
                          MyIconShortcut(initial: "H", label: "My History"),
                        ];

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
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyNavbar(),
    );
  }
}
