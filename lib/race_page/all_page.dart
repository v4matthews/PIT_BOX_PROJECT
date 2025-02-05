import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:intl/intl.dart';
import 'package:pit_box/race_page/detail_page.dart';
import 'package:pit_box/user_pages/user_home_page.dart';

class AllCatagories extends StatefulWidget {
  final String? selectedClass;

  const AllCatagories({super.key, this.selectedClass});

  @override
  State<AllCatagories> createState() => AllCatagoriesState();
}

class AllCatagoriesState extends State<AllCatagories> {
  int currentPage = 1;
  int totalPages = 1;
  final int itemsPerPage = 10;
  bool isLoadingMore = false;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dateController1 = TextEditingController();
  final TextEditingController _dateController2 = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List events = [];
  List filteredEvents = [];
  List<String> regionList = [];

  String? selectedClass;
  DateTime? selectedDate1;
  DateTime? selectedDate2;
  String? selectedLocation;

  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    fetchEvents();
    fetchRegionData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMoreEvents();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchEvents() async {
    setState(() {
      isLoading = true;
      isError = false;
      currentPage = 1;
    });
    try {
      final response = await ApiService.getFilteredEvents(
        category: widget.selectedClass,
        page: currentPage,
        limit: itemsPerPage,
      );
      setState(() {
        events = response['events'];
        totalPages = (response['total'] / itemsPerPage).ceil();
        filteredEvents = events;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  void filterEvents() async {
    setState(() {
      isLoading = true;
      currentPage = 1;
    });
    try {
      final response = await ApiService.getFilteredEvents(
        category: selectedClass,
        location: selectedLocation,
        date1: selectedDate1?.toIso8601String(),
        date2: selectedDate2?.toIso8601String(),
        page: currentPage,
        limit: itemsPerPage,
      );
      setState(() {
        filteredEvents = response['events'];
        totalPages = (response['total'] / itemsPerPage).ceil();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memfilter data: $e')),
      );
    }
  }

  Future<void> loadMoreEvents() async {
    if (currentPage < totalPages && !isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });
      try {
        final response = await ApiService.getFilteredEvents(
          category: selectedClass,
          location: selectedLocation,
          date1: selectedDate1?.toIso8601String(),
          date2: selectedDate2?.toIso8601String(),
          page: currentPage + 1,
          limit: itemsPerPage,
        );
        setState(() {
          currentPage++;
          filteredEvents.addAll(response['events']);
          isLoadingMore = false;
        });
      } catch (e) {
        setState(() {
          isLoadingMore = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data tambahan: $e')),
        );
      }
    }
  }

  Future<void> _showFilterModal(BuildContext context) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 1024;

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
          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
          child: SingleChildScrollView(
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
                        fontSize: isSmallScreen ? 16 : 18,
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
                    minimumSize: Size.fromHeight(isSmallScreen ? 45 : 50),
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
                      fontSize: isSmallScreen ? 14 : 16,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data region: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 1024;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  UserHome()), // Replace with your target page
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,  
            ),
            onPressed: () {
              Navigator.pop(context);
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
                    ),
                  ),
                  onSubmitted: (query) {
                    setState(() {
                      filteredEvents = events.where((event) {
                        final namaEvent = event['nama_event'].toLowerCase();
                        final kotaEvent = event['kota_event'].toLowerCase();
                        final lowerQuery = query.toLowerCase();

                        return namaEvent.contains(lowerQuery) ||
                            kotaEvent.contains(lowerQuery);
                      }).toList();
                    });
                  },
                ),
              ),
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
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : isError
                ? Center(
                    child: Text(
                      'Gagal memuat data',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : filteredEvents.isEmpty
                    ? Center(
                        child: Text(
                          'Data tidak ditemukan',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredEvents.length +
                                  (isLoadingMore ? 1 : 0),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isSmallScreen
                                    ? 2
                                    : isMediumScreen
                                        ? 3
                                        : 4,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.65,
                              ),
                              itemBuilder: (context, index) {
                                if (index == filteredEvents.length &&
                                    isLoadingMore) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                final event = filteredEvents[index];
                                final String? imageUrl = event['gambar_event'];

                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EventDetailPage(event: event),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 1.1,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(12),
                                            ),
                                            child: imageUrl != null &&
                                                    imageUrl.isNotEmpty
                                                ? Image.network(
                                                    imageUrl,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      } else {
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
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
                                                          fontSize:
                                                              isSmallScreen
                                                                  ? 14
                                                                  : 18,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                event['nama_event'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      isSmallScreen ? 14 : 18,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                event['kota_event'],
                                                style: TextStyle(
                                                  fontSize:
                                                      isSmallScreen ? 12 : 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                'HTM: Rp ${event['htm_event']}',
                                                style: TextStyle(
                                                  fontSize:
                                                      isSmallScreen ? 12 : 16,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                (event['tanggal_event'] !=
                                                            null &&
                                                        event['waktu_event'] !=
                                                            null)
                                                    ? '${DateFormat('dd-MMM-yyyy').format(DateTime.parse(event['tanggal_event']))} ${event['waktu_event']}'
                                                    : '-',
                                                style: TextStyle(
                                                  fontSize:
                                                      isSmallScreen ? 12 : 16,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
      ),
    );
  }
}
