import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:intl/intl.dart';
import 'package:pit_box/race_page/detail_page.dart';

class AllCatagories extends StatefulWidget {
  final String? selectedClass;

  const AllCatagories({super.key, this.selectedClass});

  @override
  State<AllCatagories> createState() => AllCatagoriesState();
}

class AllCatagoriesState extends State<AllCatagories> {
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
            return event['kategori_event'] == widget.selectedClass;
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
            selectedClass == null || event['kategori_event'] == selectedClass;
        final locationMatch =
            selectedLocation == null || event['kota_event'] == selectedLocation;
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
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white, // Set the back button color to white
            ),
            onPressed: () {
              Navigator.pop(context); // Action when back button is pressed
            },
          ),
          title: Row(
            children: [
              Expanded(
                  child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari Class Lomba atau Kota',
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 10.0,
                  ), // Mengurangi tinggi dan lebar search bar
                ),
                onSubmitted: (query) {
                  setState(() {
                    filteredEvents = events.where((event) {
                      final namaEvent = event['nama_event'].toLowerCase();
                      final kotaEvent = event['kota_event'].toLowerCase();
                      final lowerQuery = query.toLowerCase();

                      // Cari berdasarkan nama_event atau kota_event
                      return namaEvent.contains(lowerQuery) ||
                          kotaEvent.contains(lowerQuery);
                    }).toList();
                  });
                },
              )),
              IconButton(
                icon: const Icon(
                  Icons.filter_list_alt,
                  color: Colors.white,
                ),
                onPressed: () => _showFilterModal(context),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF4A59A9),
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
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final event = filteredEvents[index];
                  final String? imageUrl =
                      event['gambar_event']; // Mengambil URL gambar dari event

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailPage(event: event),
                        ),
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
                              child: imageUrl != null && imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      (loadingProgress
                                                              .expectedTotalBytes ??
                                                          1)
                                                  : null,
                                            ),
                                          );
                                        }
                                      },
                                    )
                                  : Container(
                                      color: Colors.grey[300],
                                      child: Center(
                                        child: Text(
                                          'Foto Tidak Tersedia',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 14 : 20,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
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
                                    fontSize: isSmallScreen ? 14 : 24,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  event['kota_event'],
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 12 : 20,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'HTM: Rp ${event['htm_event']}',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 12 : 20,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  (event['tanggal_event'] != null &&
                                          event['waktu_event'] != null)
                                      ? '${DateFormat('dd-MMM-yyyy').format(DateTime.parse(event['tanggal_event']))} ${event['waktu_event']}'
                                      : '-',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 12 : 20,
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
              ));
  }
}
