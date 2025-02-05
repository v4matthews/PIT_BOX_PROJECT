import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:intl/intl.dart';

class organizerHome extends StatefulWidget {
  final String? selectedClass;

  const organizerHome({super.key, this.selectedClass});

  @override
  State<organizerHome> createState() => organizerHomeState();
}

class organizerHomeState extends State<organizerHome> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dateController1 = TextEditingController();
  final TextEditingController _dateController2 = TextEditingController();

  List events = []; // Data lomba dari API
  List filteredEvents = []; // Data lomba yang telah difilter
  List<String> regionList = [];

  String? selectedClass;
  DateTime? selectedDate1;
  DateTime? selectedDate2;
  String? selectedLocation;

  @override
  void initState() {
    super.initState();
    fetchEvents();
    fetchRegionData();
  }

  Future<void> fetchEvents() async {
    try {
      final response = await ApiService.getAllCategories();
      setState(() {
        events = response;
        filteredEvents = events; // Tampilkan semua data awalnya
        if (widget.selectedClass != null) {
          // Filter berdasarkan selectedClass
          filteredEvents = events.where((event) {
            return event['kategori'] == widget.selectedClass;
          }).toList();
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  void filterEvents() {
    setState(() {
      filteredEvents = events.where((event) {
        final classMatch =
            selectedClass == null || event['kategori'] == selectedClass;
        final locationMatch = selectedLocation == null ||
            event['lokasi_event'] == selectedLocation;
        final date1Match = selectedDate1 == null ||
            DateTime.parse(event['tanggal_event']).isAfter(selectedDate1!);
        final date2Match = selectedDate2 == null ||
            DateTime.parse(event['tanggal_event']).isBefore(selectedDate2!);

        return classMatch && locationMatch && date1Match && date2Match;
      }).toList();
    });
  }

  Future<void> _showFilterModal(BuildContext context) async {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen =
        screenWidth < 600; // Consider screen as small if width < 600px

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(isSmallScreen
              ? 12.0
              : 16.0), // Adjust padding based on screen size
          child: SingleChildScrollView(
            // Wrap the content in a scroll view
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "FILTER",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            isSmallScreen ? 16 : 18, // Responsive font size
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Class",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  value: selectedClass,
                  onChanged: (value) {
                    setState(() {
                      if (value == 'All Class') {
                        selectedClass = null;
                        filteredEvents = events;
                      } else {
                        selectedClass = value;
                      }
                    });
                  },
                  items: [
                    'All Class',
                    'STO',
                    'Damper Style',
                    'STB',
                    'STB UP',
                    'Sloop',
                    'Nascar',
                  ].map((String className) {
                    return DropdownMenuItem<String>(
                      value: className,
                      child: Text(className),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Lokasi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  value: selectedLocation,
                  onChanged: (value) {
                    setState(() {
                      if (value == 'Semua Lokasi') {
                        selectedLocation = null;
                        filteredEvents = events;
                      } else {
                        selectedLocation = value;
                      }
                    });
                  },
                  items: regionList.map((String location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Tanggal 1",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  controller: _dateController1,
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate1 ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate1 = pickedDate;
                        _dateController1.text =
                            selectedDate1!.toLocal().toString().split(' ')[0];
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Tanggal 2",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  controller: _dateController2,
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate2 ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate2 = pickedDate;
                        _dateController2.text =
                            selectedDate2!.toLocal().toString().split(' ')[0];
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    filterEvents();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(
                        isSmallScreen ? 45 : 50), // Responsive button height
                    backgroundColor: Color(0xFF4A59A9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    "Filter Data",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 14 : 16, // Responsive text size
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchRegionData() async {
    try {
      final result = await ApiService.dataRegion();
      setState(() {
        regionList =
            result.map<String>((region) => region['name'] as String).toList();
      });
    } catch (e) {
      // Menampilkan pesan error jika gagal memuat data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data region: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.white,
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 16.0), // Memberi jarak dari tepi kanan
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _showFilterModal(context),
                  icon: Row(
                    mainAxisSize:
                        MainAxisSize.min, // Menyesuaikan ukuran dengan konten
                    children: [
                      Icon(
                        Icons.filter_list_alt,
                        color: Colors.white, // Warna ikon
                      ),
                      SizedBox(width: 8), // Jarak antara ikon dan teks
                      Text(
                        'Filter',
                        style: TextStyle(
                          color: Colors.white, // Warna teks
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      body: filteredEvents.isEmpty
          ? Center(
              child: Text(
                'Data tidak ditemukan',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredEvents.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Dua item dalam satu baris
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.67,
              ),
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                final imageUrl = event['gambar_event'] ??
                    'assets/images/noimage.png'; // URL gambar fallback

                return InkWell(
                  onTap: () {
                    // Tambahkan aksi jika kartu diklik
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Klik pada ${event['nama_event']}')),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Menampilkan gambar dengan rasio 1.1
                        AspectRatio(
                          aspectRatio: 1.1, // Rasio 1.1
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.network(
                              imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event['nama_event'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallScreen ? 16 : 28,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                event['lokasi_event'],
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 26,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'HTM: Rp ${event['htm_event']}',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 12 : 24,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                DateFormat('dd-MMM-yyyy').format(
                                    DateTime.parse(event['tanggal_event'])),
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 12 : 24,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
