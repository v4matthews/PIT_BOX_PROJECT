import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:intl/intl.dart';

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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "FILTER",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                      // Reset selectedClass jika memilih "All Class"
                      selectedClass = null;
                      filteredEvents = events; // Tampilkan semua data
                    } else {
                      selectedClass = value;
                    }
                  });
                },
                items: [
                  'All Class', // Tambahkan opsi "All Class"
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
                      // Reset selectedClass jika memilih "All Class"
                      selectedLocation = null;
                      filteredEvents = events; // Tampilkan semua data
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
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Color(0xFFFFC700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  "Filter Data",
                  style: TextStyle(
                    color: Colors.white, // Mengubah warna teks menjadi putih
                    fontWeight: FontWeight.bold, // Membuat teks menjadi bold
                  ),
                ),
              ),
            ],
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari Lomba Disini',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onSubmitted: (query) {
                  setState(() {
                    filteredEvents = events
                        .where((event) => event['nama_event']
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList();
                  });
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.filter_list_alt),
              onPressed: () => _showFilterModal(context),
            ),
          ],
        ),
      ),
      body: filteredEvents.isEmpty
          ? Center(
              child: Text(
                'Data tidak ditemukan',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                      Container(
                        height: 200,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event['nama_event'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  event['lokasi_event'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'HTM: Rp ${event['htm_event']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('dd-MMM-yyyy').format(
                                      DateTime.parse(event['tanggal_event'])),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
