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
      appBar: AppBar(
        title: Text('Daftar Reservasi'),
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
                    return ListTile(
                      title: Text(reservation['nama_event']),
                      subtitle: Text('Nama Tim: ${reservation['nama_tim']}'),
                      trailing: Text('Status: ${reservation['status']}'),
                    );
                  },
                ),
    );
  }
}
