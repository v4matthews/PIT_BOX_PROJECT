import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_navbar.dart';
import 'package:pit_box/components/asset_warna.dart';

class TicketListPage extends StatelessWidget {
  final List<Ticket> tickets = [
    Ticket(
        'Nama Race', 'Senin, 12 Januari 2024', 'Magelang', 'Rp 75.000', true),
    Ticket(
        'Nama Race', 'Senin, 12 Januari 2024', 'Magelang', 'Rp 75.000', true),
    Ticket(
        'Nama Race', 'Senin, 12 Januari 2024', 'Magelang', 'Rp 75.000', false),
    Ticket(
        'Nama Race', 'Senin, 12 Januari 2024', 'Magelang', 'Rp 75.000', false),
  ];

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/tickets');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
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
  final String name;
  final String date;
  final String location;
  final String price;
  final bool isActive;

  Ticket(this.name, this.date, this.location, this.price, this.isActive);
}

class TicketCard extends StatelessWidget {
  final Ticket ticket;

  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // Tetap putih agar kontras dengan background
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4, // Menambahkan efek bayangan agar lebih terlihat
      shadowColor: Colors.black26, // Warna bayangan yang lebih soft
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.name,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(ticket.date),
                  Text('Lokasi : ${ticket.location}'),
                  Text('HTM : ${ticket.price}'),
                ],
              ),
            ),
            Container(
              width: 90.0,
              height: 40.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ticket.isActive ? Color(0xFF4CAF50) : Colors.grey,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                ticket.isActive ? 'Active' : 'Non Active',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
