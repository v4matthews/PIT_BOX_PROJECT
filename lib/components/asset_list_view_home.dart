import 'package:flutter/material.dart';

class RaceEventListView extends StatelessWidget {
  final List raceEvents;

  RaceEventListView({required this.raceEvents});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: raceEvents.length,
      itemBuilder: (context, index) {
        final event = raceEvents[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: ListTile(
            contentPadding: EdgeInsets.all(10),
            title: Text(
              event['nama_event'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              event['tanggal_event'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle event tap
            },
          ),
        );
      },
    );
  }
}
