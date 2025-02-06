import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Import package qr_flutter
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/user_pages/user_ticket.dart';

class TicketDetailPage extends StatelessWidget {
  final Ticket ticket;

  const TicketDetailPage({super.key, required this.ticket});

  // Fungsi untuk menggabungkan data tiket menjadi satu string
  String _generateQRData() {
    return '''
      {
        "id_tiket": "${ticket.id}",
        "id_transaksi": "${ticket.transactionId}",
        "id_user": "${ticket.userId}",
        "id_event": "${ticket.eventId}",
        "status": "${ticket.isActive ? 'Aktif' : 'Tidak Aktif'}"
      }
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Detail Tiket',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // QR Code di bagian atas
              Center(
                child: QrImageView(
                  data: _generateQRData(), // Data yang akan diencode ke QR
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Card 1: Nama Event dan Status
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.eventName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Status: ${ticket.isActive ? 'Aktif' : 'Tidak Aktif'}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Card 2: Tanggal, Waktu, dan HTM
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tanggal: ${ticket.eventDate}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Waktu: ${ticket.eventTime}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'HTM: ${ticket.eventPrice}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Card 3: Lokasi dan Status Pembayaran
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lokasi: ${ticket.eventLocation}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Status Pembayaran:',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green, // Warna bisa disesuaikan
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
