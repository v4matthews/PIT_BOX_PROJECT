import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_navbar.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/user_pages/user_ticket_detail_page.dart';

class TicketListPage extends StatefulWidget {
  @override
  _TicketListPageState createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  List<Ticket> tickets = [];

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  Future<void> _fetchTickets() async {
    try {
      final List<dynamic> ticketData = await ApiService.getTickets();
      setState(() {
        tickets = ticketData.map((data) => Ticket.fromJson(data)).toList();
      });
    } catch (e) {
      print('Failed to fetch tickets: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'TICKET',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return TicketCard(ticket: ticket);
        },
      ),
    );
  }
}

class Ticket {
  final String id;
  final String transactionId;
  final String userId;
  final String eventId;
  final String eventName;
  final String eventDate;
  final String eventTime;
  final String eventLocation;
  final String eventPrice;
  final bool isActive;

  Ticket({
    required this.id,
    required this.transactionId,
    required this.userId,
    required this.eventId,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    required this.eventPrice,
    required this.isActive,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['_id'] ?? 'N/A',
      transactionId: json['id_transaksi'] ?? 'N/A',
      userId: json['id_user'] ?? 'N/A',
      eventId: json['id_event'] ?? 'N/A',
      eventName: json['nama_event'] ?? 'N/A',
      eventDate: json['tanggal_event'] ?? 'N/A',
      eventTime: json['waktu_event'] ?? 'N/A',
      eventLocation: json['lokasi_event'] ?? 'N/A',
      eventPrice: json['htm_event']?.toString() ?? '-',
      isActive: json['is_active'] ?? false,
    );
  }
}

class TicketCard extends StatelessWidget {
  final Ticket ticket;

  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketDetailPage(ticket: ticket),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 4,
        shadowColor: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.eventName,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text('Tanggal: ${ticket.eventDate}'),
                    Text('Waktu: ${ticket.eventTime}'),
                    Text('Lokasi: ${ticket.eventLocation}'),
                    Text('HTM: ${ticket.eventPrice}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
