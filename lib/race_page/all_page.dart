import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:intl/intl.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/race_page/detail_page.dart';
import 'package:pit_box/user_pages/user_home_page.dart';
import 'package:pit_box/components/asset_list_view.dart'; // Import the EventListView

class AllCatagories extends StatefulWidget {
  final String? selectedClass;
  final String? searchQuery;

  const AllCatagories({super.key, this.selectedClass, this.searchQuery});

  @override
  State<AllCatagories> createState() => _AllCatagoriesState();
}

class _AllCatagoriesState extends State<AllCatagories> {
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

    if (widget.searchQuery != null) {
      _searchController.text = widget.searchQuery!;
      filterEventsBySearch(widget.searchQuery!);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMoreEvents();
    }
  }

  void filterEventsBySearch(String query) {
    setState(() {
      filteredEvents = events.where((event) {
        final namaEvent = event['nama_event'].toLowerCase();
        final kotaEvent = event['kota_event'].toLowerCase();
        final lowerQuery = query.toLowerCase();

        return namaEvent.contains(lowerQuery) || kotaEvent.contains(lowerQuery);
      }).toList();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _dateController1.dispose();
    _dateController2.dispose();
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
        Navigator.pop(context, true); // Mengirimkan nilai true saat kembali
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
              Navigator.pop(
                  context, true); // Mengirimkan nilai true saat kembali
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
            ],
          ),
          backgroundColor: AppColors.primaryColor,
        ),
        body: isLoading
            ? const Center(
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
                    : EventListView(
                        events: filteredEvents,
                        isLoadingMore: isLoadingMore,
                        scrollController: _scrollController,
                        isSmallScreen: isSmallScreen,
                        isMediumScreen: isMediumScreen,
                      ),
      ),
    );
  }
}
