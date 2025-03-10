import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_warna.dart';

class ReservationListPage extends StatefulWidget {
  @override
  _ReservationListPageState createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  List<Map<String, dynamic>> _reservations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    try {
      final userData = await ApiService.getUserData();
      final reservations =
          await ApiService.getReservations(userData['id_user']!);
      setState(() {
        _reservations = reservations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data reservasi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Daftar Reservasi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _reservations.isEmpty
              ? Center(child: Text('Tidak ada reservasi.'))
              : ListView.builder(
                  itemCount: _reservations.length,
                  itemBuilder: (context, index) {
                    final reservation = _reservations[index];
                    final event = reservation['id_event'];
                    return Card(
                      color: Colors.white, // Mengubah warna card menjadi putih
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event['nama_event'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text('Nama Tim: ${reservation['nama_tim']}'),
                            Text('Kategori: ${event['kategori_event']}'),
                            Text('Tanggal: ${event['tanggal_event']}'),
                            Text('Lokasi: ${event['kota_event']}'),
                            SizedBox(height: 10),
                            Text(
                              'Status: ${reservation['status']}',
                              style: TextStyle(
                                color: reservation['status'] == 'Pending'
                                    ? Colors.orange
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
