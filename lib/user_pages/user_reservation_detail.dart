import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_box/components/asset_warna.dart';

class UserReservationDetailPage extends StatelessWidget {
  final Map<String, dynamic> reservation;

  const UserReservationDetailPage({Key? key, required this.reservation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Reservation Data: $reservation');
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: _buildAppBar(context),
      body: _buildDetailBody(context),
    );
  }

  // Section: AppBar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: const Text(
        'Detail Reservasi',
        style: TextStyle(
          color: AppColors.whiteText,
          fontSize: 18,
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.whiteText),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  // Section: Detail Body
  // Section: Detail Body
  Widget _buildDetailBody(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: screenWidth > 600 ? 600 : screenWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEventInfoCard(),
              const SizedBox(height: 20),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

// Section: Action Buttons
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // Logika untuk melanjutkan pembayaran
              print('Lanjutkan Pembayaran');
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.whiteColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: BorderSide(color: AppColors.primaryColor),
            ),
            child: const Text(
              'Lanjutkan Pembayaran',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Logika untuk membatalkan reservasi
              print('Batalkan Reservasi');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Batalkan Reservasi',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Section: Event Info Card
  Widget _buildEventInfoCard() {
    return Card(
      color: AppColors.whiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardTitle('Informasi Event'),
            const SizedBox(height: 16),
            _buildDetailItem(
                'Nama Event', reservation['id_event']['nama_event'] ?? '-'),
            const Divider(height: 24, thickness: 0.5),
            _buildDetailItem(
                'Tanggal',
                DateFormat('dd MMM yyyy').format(
                  DateTime.parse(reservation['id_event']['tanggal_event'] ??
                      DateTime.now().toString()),
                )),
            const Divider(height: 24, thickness: 0.5),
            _buildDetailItem(
                'Waktu', reservation['id_event']['waktu_event'] ?? '-'),
            const Divider(height: 24, thickness: 0.5),
            _buildDetailItem(
                'Lokasi', reservation['id_event']['kota_event'] ?? '-'),
            const Divider(height: 24, thickness: 0.5),
            _buildDetailItem(
              'Status',
              reservation['status'] ?? '-',
            ),
          ],
        ),
      ),
    );
  }

  // Section: Card Title
  Widget _buildCardTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
    );
  }

  // Section: Detail Item
  Widget _buildDetailItem(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
