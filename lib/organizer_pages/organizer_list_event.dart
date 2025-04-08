import 'package:flutter/material.dart';

class OrganizerListEventPage extends StatefulWidget {
  @override
  _OrganizerListEventPageState createState() => _OrganizerListEventPageState();
}

class _OrganizerListEventPageState extends State<OrganizerListEventPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organizer Events'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Started'),
            Tab(text: 'Ongoing'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventList('Started'),
          _buildEventList('Ongoing'),
          _buildEventList('Completed'),
        ],
      ),
    );
  }

  Widget _buildEventList(String status) {
    // Replace this with your actual data fetching and rendering logic
    return ListView.builder(
      itemCount: 10, // Example item count
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('$status Event ${index + 1}'),
          subtitle: Text('Details of $status Event ${index + 1}'),
          onTap: () {
            // Handle event tap
          },
        );
      },
    );
  }
}
