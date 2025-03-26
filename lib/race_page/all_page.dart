import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_datepicker.dart';
import 'package:pit_box/components/asset_dropdown.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/race_page/detail_page.dart';
import 'package:pit_box/user_pages/user_home_page.dart';
import 'package:pit_box/components/asset_list_view.dart'; // Import the EventListView

class AllCatagories extends StatefulWidget {
  final String? selectedClass;
  final String? searchQuery;
  final String? userLocation;

  const AllCatagories({
    super.key,
    this.selectedClass,
    this.searchQuery,
    this.userLocation,
  });

  @override
  State<AllCatagories> createState() => _AllCatagoriesState();
}

class _AllCatagoriesState extends State<AllCatagories> {
  int currentPage = 1;
  int totalPages = 1;
  final int itemsPerPage = 10;
  bool isLoadingMore = false;

  final TextEditingController _searchController = TextEditingController();
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
  String? selectedLocation;

  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    selectedLocation = widget.userLocation;

    fetchEvents();
    fetchRegionData();

    if (widget.searchQuery != null) {
      _searchController.text = widget.searchQuery!;
      print('User location:sss ${widget.userLocation}');
      filterEventsBySearch(widget.searchQuery!);
    }

    if (widget.userLocation != null) {
      selectedLocation = widget.userLocation;
      print('User location:sss ${widget.userLocation}');
      sortEventsByLocation(widget.userLocation!);
    }

    if (widget.selectedClass != null) {
      selectedClass = widget.selectedClass;
    }

    _searchController.addListener(() {
      filterEventsBySearch(_searchController.text);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMoreEvents();
    }
  }

  void filterEventsBySearch(String query) {
    setState(() {
      // Buat salinan dari semua events
      filteredEvents = List.from(events);

      // Urutkan filteredEvents berdasarkan relevansi dengan query
      filteredEvents.sort((a, b) {
        final aMatch =
            a['nama_event'].toLowerCase().contains(query.toLowerCase()) ||
                a['kota_event'].toLowerCase().contains(query.toLowerCase());
        final bMatch =
            b['nama_event'].toLowerCase().contains(query.toLowerCase()) ||
                b['kota_event'].toLowerCase().contains(query.toLowerCase());

        if (aMatch && !bMatch) {
          return -1; // a lebih relevan, tampilkan di atas
        } else if (!aMatch && bMatch) {
          return 1; // b lebih relevan, tampilkan di atas
        } else {
          return 0; // keduanya sama relevannya
        }
      });
    });
  }

  void sortEventsByLocation(String location) {
    setState(() {
      filteredEvents.sort((a, b) {
        final aMatch = a['kota_event'].toLowerCase() == location.toLowerCase();
        final bMatch = b['kota_event'].toLowerCase() == location.toLowerCase();

        if (widget.searchQuery != null) {
          final aSearchMatch = a['nama_event']
                  .toLowerCase()
                  .contains(widget.searchQuery!.toLowerCase()) ||
              a['kota_event']
                  .toLowerCase()
                  .contains(widget.searchQuery!.toLowerCase());
          final bSearchMatch = b['nama_event']
                  .toLowerCase()
                  .contains(widget.searchQuery!.toLowerCase()) ||
              b['kota_event']
                  .toLowerCase()
                  .contains(widget.searchQuery!.toLowerCase());

          if (aSearchMatch && !bSearchMatch) {
            return -1; // a lebih relevan, tampilkan di atas
          } else if (!aSearchMatch && bSearchMatch) {
            return 1; // b lebih relevan, tampilkan di atas
          }
        }

        if (aMatch && !bMatch) {
          return -1; // a lebih relevan, tampilkan di atas
        } else if (!aMatch && bMatch) {
          return 1; // b lebih relevan, tampilkan di atas
        } else {
          return 0; // keduanya sama relevannya
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
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
        category: (widget.selectedClass == null || widget.selectedClass == '')
            ? null
            : widget.selectedClass,
        page: currentPage,
        limit: itemsPerPage,
      );
      setState(() {
        events = response['events'];
        totalPages = (response['total'] / itemsPerPage).ceil();
        filteredEvents = events;
        isLoading = false;
      });

      if (widget.userLocation != null) {
        sortEventsByLocation(widget.userLocation!);
      }
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
        category: (selectedClass == null ||
                selectedClass == '' ||
                selectedClass == 'ALL')
            ? null
            : selectedClass,
        page: currentPage,
        limit: itemsPerPage,
      );
      setState(() {
        // Simpan semua data yang diterima
        filteredEvents = response['events'];
        totalPages = (response['total'] / itemsPerPage).ceil();
        isLoading = false;
      });

      if (widget.userLocation != null) {
        sortEventsByLocation(widget.userLocation!);
      }

      // Jika ada searchQuery, urutkan data berdasarkan relevansi
      if (widget.searchQuery != null) {
        filterEventsBySearch(widget.searchQuery!);
      }
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
          page: currentPage + 1,
          limit: itemsPerPage,
        );
        setState(() {
          currentPage++;
          filteredEvents.addAll(response['events']);
          isLoadingMore = false;
        });

        if (widget.userLocation != null) {
          sortEventsByLocation(widget.userLocation!);
        }
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
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
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
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
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
                icon: Icon(Icons.filter_list, color: AppColors.whiteText),
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
                                  sortEventsByLocation(selectedLocation!);
                                },
                                items: regionList,
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.whiteText),
            onPressed: () => Navigator.pop(context),
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
