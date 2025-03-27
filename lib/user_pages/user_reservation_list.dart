// filepath: D:/Tugas Akhir/Project TA/pit_box/pit_box/lib/user_pages/user_reservation_list.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_box/api_service.dart';

class UserReservationListPage extends StatefulWidget {
  final String userId;

  const UserReservationListPage({Key? key, required this.userId})
      : super(key: key);

  @override
  _UserReservationListPageState createState() =>
      _UserReservationListPageState();
}

class _UserReservationListPageState extends State<UserReservationListPage> {
  late Future<List<Map<String, dynamic>>> _reservationsFuture;

  @override
  void initState() {
    super.initState();
    _reservationsFuture = ApiService.getReservations(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Reservasi'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _reservationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Terjadi kesalahan: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Tidak ada reservasi yang ditemukan.'),
            );
          }

          final reservations = snapshot.data!;

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              // print("reservation Nama: $reservation['id_event']['nama_event']");
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                      reservation['id_event']['nama_event'] ?? 'Nama Event'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Tanggal Reservasi: ${reservation['reserved_at'] != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(reservation['reserved_at'])) : '-'}'),
                      Text('Lokasi: ${reservation['kota_event'] ?? '-'}'),
                      Text('Status: ${reservation['status'] ?? '-'}'),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Aksi ketika item di klik
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservationDetailPage(
                          reservation: reservation,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ReservationDetailPage extends StatelessWidget {
  final Map<String, dynamic> reservation;

  const ReservationDetailPage({Key? key, required this.reservation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Reservasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Event: ${reservation['nama_event'] ?? '-'}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Tanggal: ${reservation['tanggal_event'] ?? '-'}'),
            Text('Lokasi: ${reservation['kota_event'] ?? '-'}'),
            Text('Status: ${reservation['status'] ?? '-'}'),
            const SizedBox(height: 16),
            Text('Deskripsi: ${reservation['deskripsi_event'] ?? '-'}'),
          ],
        ),
      ),
    );
  }
}
