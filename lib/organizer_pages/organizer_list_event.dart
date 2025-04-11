import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/organizer_pages/organizer_detail_event.dart';
import 'package:pit_box/race_page/detail_page.dart';

class OrganizerListEventPage extends StatefulWidget {
  final String idOrganizer;

  const OrganizerListEventPage({required this.idOrganizer, Key? key})
      : super(key: key);

  @override
  _OrganizerListEventPageState createState() => _OrganizerListEventPageState();
}

class _OrganizerListEventPageState extends State<OrganizerListEventPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _isInitialLoading = true;

  // Status categories with icons and colors
  final List<Map<String, dynamic>> _statusTabs = [
    {
      'status': 'ongoing',
      'label': 'Ongoing',
      'icon': Icons.timelapse,
      'color': Colors.purple,
    },
    {
      'status': 'upcoming',
      'label': 'Upcoming',
      'icon': Icons.event_available,
      'color': Colors.blue,
    },
    {
      'status': 'completed',
      'label': 'Completed',
      'icon': Icons.done_all,
      'color': Colors.green,
    },
    {
      'status': 'canceled',
      'label': 'Canceled',
      'icon': Icons.cancel,
      'color': Colors.red,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusTabs.length, vsync: this);
    _checkInitialTab();
  }

  Future<void> _checkInitialTab() async {
    try {
      final ongoingEvents = await _fetchEventsByStatus('ongoing');
      if (ongoingEvents.isEmpty) {
        // If no ongoing events, start with upcoming tab
        _tabController.index = 1;
      }
    } catch (e) {
      // Handle error if needed
    } finally {
      setState(() {
        _isInitialLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> _fetchEventsByStatus(String status) async {
    final allEvents = await ApiService.getEventsByOrganizer(widget.idOrganizer);
    return allEvents.where((event) => event['status_event'] == status).toList();
  }

  Widget _buildEventList(String status) {
    return FutureBuilder<List<dynamic>>(
      future: _fetchEventsByStatus(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error loading events',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_available,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No events available',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }

        final events = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            // Define the grid layout for the event cards
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              crossAxisSpacing:
                  4, // Reduced horizontal spacing between grid items
              mainAxisSpacing: 8, // Reduced vertical spacing between grid items
              childAspectRatio: 0.8, // Aspect ratio for each grid item
            ),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final imageUrl = event['image_event'];

              return Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrganizerEventDetailPage(event: event),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            image: imageUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: imageUrl == null
                              ? Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.grey[600],
                                  ),
                                )
                              : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event['nama_event'] ?? 'Unnamed Event',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event['kategori_event'] ?? 'No category',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 12,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    event['tanggal_event'] != null
                                        ? DateFormat('dd MMM yyyy').format(
                                            DateTime.parse(
                                                event['tanggal_event']))
                                        : 'No date',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Organizer Events'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Detail Event',
          style: TextStyle(
            color: AppColors.whiteText,
            fontSize: 18,
            fontFamily: 'OpenSans',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whiteText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: Container(
            // color: Colors.black.withOpacity(0.5),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.whiteText,
              unselectedLabelColor: AppColors.whiteText.withOpacity(0.7),
              indicatorColor: AppColors.whiteText,
              indicatorWeight: 3,
              tabs: _statusTabs
                  .map((tab) => Tab(
                        icon: Icon(tab['icon'], size: 20),
                        text: tab['label'],
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:
            _statusTabs.map((tab) => _buildEventList(tab['status'])).toList(),
      ),
    );
  }
}
