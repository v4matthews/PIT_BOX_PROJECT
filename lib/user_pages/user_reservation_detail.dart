import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_alert_cancel_reservation.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/user_pages/web_view.dart';

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
    if (reservation['status'] == 'Canceled') {
      return const SizedBox
          .shrink(); // Tidak menampilkan tombol jika status adalah 'canceled'
    }

    return Card(
      color: AppColors.whiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  // Logika untuk melanjutkan pembayaran
                  await _viewConfirmationReceipt(context);
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
                onPressed: () async {
                  // Logika untuk membuka confirmation_receipt
                  await _cancleReservation(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
        ),
      ),
    );
  }

  Future<void> _viewConfirmationReceipt(BuildContext context) async {
    try {
      // Tampilkan indikator loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Panggil API untuk mendapatkan data pembayaran
      final paymentResponse = await ApiService.getPayment(reservation['_id']);

      Navigator.pop(context); // Tutup dialog loading

      if (paymentResponse.containsKey('confirmation_receipt')) {
        final receiptUrl = paymentResponse['confirmation_receipt'];

        // Navigasi ke halaman WebView untuk melihat bukti pembayaran
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewPage(
              url: receiptUrl,
            ),
          ),
        );
      } else {
        // _showErrorDialog(context, 'Bukti pembayaran tidak tersedia.');
      }
    } catch (e) {
      Navigator.pop(context); // Tutup dialog loading
      // _showErrorDialog(context, 'Terjadi kesalahan: $e');
    }
  }

  Future<void> _cancleReservation(BuildContext context) async {
    // Tampilkan dialog konfirmasi
    showCancelReservationDialog(context, () async {
      try {
        // Tampilkan indikator loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Panggil API untuk membatalkan reservasi
        final response = await ApiService.cancelReservation(reservation['_id']);
        Navigator.pop(context); // Tutup dialog loading

        if (response['status'] == 'success') {
          // Tampilkan pesan sukses
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(response['message'] ?? 'Reservasi berhasil dibatalkan.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Kembali ke halaman sebelumnya

          // Refresh halaman reservation list
          Navigator.pop(context, true); // Mengirimkan sinyal untuk refresh
        } else {
          // Tampilkan pesan kesalahan
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal membatalkan reservasi.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        Navigator.pop(context); // Tutup dialog loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  // Future<void> _cancleReservation(BuildContext context) async {
  //   try {
  //     // Tampilkan indikator loading
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => const Center(
  //         child: CircularProgressIndicator(),
  //       ),
  //     );

  //     // Panggil API untuk mendapatkan data pembayaran
  //     final response = await ApiService.cancelReservation(reservation['_id']);
  //     print(response['status']);
  //     if (response['status'] == 'success') {
  //       // Tampilkan pesan sukses
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content:
  //               Text(response['message'] ?? 'Reservasi berhasil dibatalkan.'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //       Navigator.pop(context); // Kembali ke halaman sebelumnya
  //     } else {
  //       // Tampilkan pesan kesalahan
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Gagal membatalkan reservasi.'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //     Navigator.pop(context); // Tutup dialog loading
  //   } catch (e) {
  //     Navigator.pop(context); // Tutup dialog loading
  //     // _showErrorDialog(context, 'Terjadi kesalahan: $e');
  //   }
  // }

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
            const SizedBox(height: 25),
            _buildDetailItem(
                'Nama Event',
                reservation['id_event']['nama_event'] ?? '-',
                AppColors.primaryText),
            const Divider(height: 24, thickness: 0.5),
            _buildDetailItem(
                'Tanggal',
                DateFormat('dd MMM yyyy').format(
                  DateTime.parse(reservation['id_event']['tanggal_event'] ??
                      DateTime.now().toString()),
                ),
                AppColors.primaryText),
            const Divider(height: 24, thickness: 0.5),
            _buildDetailItem(
                'Waktu',
                reservation['id_event']['waktu_event'] ?? '-',
                AppColors.primaryText),
            const Divider(height: 24, thickness: 0.5),
            _buildDetailItem(
                'Lokasi',
                reservation['id_event']['kota_event'] ?? '-',
                AppColors.primaryText),
            const Divider(height: 24, thickness: 0.5),
            _buildDetailItem(
              'Status',
              reservation['status'] ?? '-',
              Colors.grey[500] ?? AppColors.lightGreyText,
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
        fontFamily: 'OpenSans',
      ),
    );
  }

  // Section: Detail Item
  Widget _buildDetailItem(String label, String value, Color colors) {
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
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: colors,
            ),
          ),
        ),
      ],
    );
  }
}
