import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:intl/intl.dart';
import 'package:pit_box/components/asset_datepicker.dart';
import 'package:pit_box/components/asset_dropdown.dart';
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

class _AllCatagoriesState extends State<AllCatagories>
    with SingleTickerProviderStateMixin {
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
  List<String> categories = [
    'ALL',
    'STB',
    'STB UP',
    'STO',
    'DAMPER TUNE',
    'DAMPER DASH',
    'NASCAR',
    'SLOOP',
  ]; // Add your categories here

  String? selectedClass;

  DateTime? selectedDate1;
  DateTime? selectedDate2;
  String? selectedLocation;

  bool isLoading = true;
  bool isError = false;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);
    fetchEvents();
    fetchRegionData();

    if (widget.searchQuery != null) {
      _searchController.text = widget.searchQuery!;
      filterEventsBySearch(widget.searchQuery!);
    }
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        selectedClass = categories[_tabController.index];
      });
      filterEvents();
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
    _tabController.dispose();
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
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: AppColors.whiteColor,
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
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 10.0,
                    ),
                  ),
                  onSubmitted: (query) {
                    filterEventsBySearch(query);
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.filter_list, color: Colors.black),
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: AppColors.whiteColor,
                    context: context,
                    builder: (BuildContext context) {
                      final screenWidth = MediaQuery.of(context).size.width;
                      final fieldWidth = screenWidth * 0.9;
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 16),
                            Center(
                              child: Text(
                                'Filter Event',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: AssetDropdown(
                                hintText: "Pilih Kota",
                                selectedValue: selectedLocation,
                                width: fieldWidth,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedLocation = newValue;
                                  });
                                  Navigator.pop(context);
                                  filterEvents();
                                },
                                items: regionList,
                              ),
                            ),
                            SizedBox(height: 16),
                            Center(
                              child: MyDateField(
                                controller: _dateController1,
                                hintText: 'Pilih Tanggal 1',
                                width: fieldWidth,
                                onDateSelected: (pickedDate) {
                                  setState(() {
                                    selectedDate1 = pickedDate;
                                    _dateController1.text =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                  });
                                  Navigator.pop(context);
                                  filterEvents();
                                },
                              ),
                            ),
                            SizedBox(height: 16),
                            Center(
                              child: MyDateField(
                                controller: _dateController2,
                                hintText: 'Pilih Tanggal 2',
                                width: fieldWidth,
                                onDateSelected: (pickedDate) {
                                  setState(() {
                                    selectedDate2 = pickedDate;
                                    _dateController2.text =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                  });
                                  Navigator.pop(context);
                                  filterEvents();
                                },
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true, // Tambahkan ini agar tab dapat di-scroll
            labelColor: AppColors.primaryText,
            unselectedLabelColor: AppColors.secondaryText,
            indicatorColor: AppColors.primaryText,
            indicatorWeight: 4.0,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            tabs: categories.map((category) => Tab(text: category)).toList(),
          ),
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
