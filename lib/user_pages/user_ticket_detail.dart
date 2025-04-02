import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/user_pages/user_ticket.dart';

class TicketDetailPage extends StatelessWidget {
  final Ticket ticket;

  const TicketDetailPage({super.key, required this.ticket});

  String _generateQRData() {
    return '''
      {
        "id_tiket": "${ticket.id}",
        "id_transaksi": "${ticket.transactionId}",
        "id_user": "${ticket.userId}",
        "id_event": "${ticket.eventId}",
        "status": "${ticket.statusTicket}"
      }
    ''';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
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
          'Detail Tiket',
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth > 600 ? 600 : screenWidth,
            ),
            child: Column(
              children: [
                _buildQRCodeSection(),
                const SizedBox(height: 20),
                _buildTicketInfoCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQRCodeSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Kode Tiket',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          QrImageView(
            data: _generateQRData(),
            version: QrVersions.auto,
            size: 200.0,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            'ID: ${ticket.id}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          // const SizedBox(height: 14),
          // Text(
          //   'Nama Tim: ${ticket.namaTim}',
          //   style: const TextStyle(
          //     fontSize: 18,
          //     color: AppColors.primaryText,
          //     fontFamily: 'OpenSans',
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildTicketInfoCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildCardTitle('Nama Tim', ticket.namaTim),
          const SizedBox(height: 30),
          _buildAlignedDetailItem(
            'Nama Event',
            ticket.eventName,
            AppColors.primaryText,
          ),
          const Divider(height: 24, thickness: 0.5),
          _buildAlignedDetailItem(
            'Nama Tim',
            ticket.namaTim,
            AppColors.primaryText,
          ),
          const Divider(height: 24, thickness: 0.5),
          _buildAlignedDetailItem(
            'Tanggal',
            ticket.eventDate != 'N/A'
                ? DateFormat('dd MMM yyyy')
                    .format(DateTime.parse(ticket.eventDate))
                : '-',
            AppColors.primaryText,
          ),
          const Divider(height: 24, thickness: 0.5),
          _buildAlignedDetailItem(
            'Waktu',
            ticket.eventTime,
            AppColors.primaryText,
          ),
          const Divider(height: 24, thickness: 0.5),
          _buildAlignedDetailItem(
            'Lokasi',
            ticket.eventLocation,
            AppColors.primaryText,
          ),
          const Divider(height: 24, thickness: 0.5),
          _buildAlignedDetailItem(
            'HTM',
            ticket.eventPrice,
            AppColors.primaryText,
          ),
          const Divider(height: 24, thickness: 0.5),
          _buildAlignedDetailItem(
            'Status',
            ticket.statusTicket,
            ticket.statusTicket.toLowerCase() == 'sudah check-in'
                ? AppColors.greenColor
                : AppColors.yellowColor,
            // AppColors.primaryText,
          ),
        ],
      ),
    );
  }

  Widget _buildAlignedDetailItem(String label, String value, Color colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
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

  Widget _buildCardTitle(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
        const SizedBox(width: 0),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ],
    );
  }

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
