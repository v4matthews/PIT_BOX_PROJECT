import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_list_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showSearchField =
      false; // State to control the visibility of the search field
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Nama Wilayah',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total Race: 0',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Range Tanggal (tlg1-tgl2)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            showSearchField =
                                !showSearchField; // Toggle search field visibility
                          });
                        },
                      ),
                    ],
                  ),
                  if (showSearchField)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari Lomba Disini',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount:
                    10, // Item count nanti akan mengambil data jumlah race yang ada di database
                itemBuilder: (context, index) {
                  // List view akan disesuaikan dengan data yang ada di database
                  return MyListView(
                    lokasiRace: 'Magelang',
                    htmRace: 'Rp 75.000',
                    namaRace: 'Nama Race',
                    tanggalRace: 'Senin, 12 Januari 2024',
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.tiktok),
            label: 'My Ticket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.amber),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
