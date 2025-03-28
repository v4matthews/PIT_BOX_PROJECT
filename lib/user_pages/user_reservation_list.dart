// Section: Imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/user_pages/user_reservation_detail.dart';

// Section: UserReservationListPage Widget
class UserReservationListPage extends StatefulWidget {
  final String userId;

  const UserReservationListPage({Key? key, required this.userId})
      : super(key: key);

  @override
  _UserReservationListPageState createState() =>
      _UserReservationListPageState();
}

// Section: UserReservationListPage State
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
      backgroundColor: AppColors.backgroundGrey,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // Section: AppBar
  AppBar _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text(
        'Daftar Reservasi',
        style: TextStyle(
          color: AppColors.whiteText,
          fontSize: 18,
          fontFamily: 'OpenSans',
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.whiteText),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  // Section: Body
  Widget _buildBody() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _reservationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else if (snapshot.hasError) {
          return _buildErrorMessage(snapshot.error);
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyMessage();
        }

        final reservations = snapshot.data!;
        return _buildReservationList(reservations);
      },
    );
  }

  // Section: Loading Indicator
  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
      ),
    );
  }

  // Section: Error Message
  Widget _buildErrorMessage(Object? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Terjadi kesalahan: $error',
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Section: Empty Message
  Widget _buildEmptyMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Tidak ada reservasi yang ditemukan.',
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Section: Reservation List
  Widget _buildReservationList(List<Map<String, dynamic>> reservations) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _reservationsFuture = ApiService.getReservations(widget.userId);
        });
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final reservation = reservations[index];
          return _buildReservationCard(reservation);
        },
      ),
    );
  }

  // Section: Reservation Card
  Widget _buildReservationCard(Map<String, dynamic> reservation) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ReservationDetailPage(
          //       reservation: reservation,
          //     ),
          //   ),
          // );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserReservationDetailPage(
                reservation: reservation,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReservationHeader(reservation),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Tanggal Reservasi: ${reservation['reserved_at'] != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(reservation['reserved_at'])) : '-'}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Section: Reservation Header
  Widget _buildReservationHeader(Map<String, dynamic> reservation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            reservation['id_event']['nama_event'] ?? 'Nama Event',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(reservation['status']),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            reservation['status'] ?? '-',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  // Section: Detail Row
  Widget _buildDetailRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  // Section: Status Color
  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Pending Payment':
        return AppColors.yellowColor;
      case 'Paid':
        return AppColors.greenColor;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
