import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/user_pages/user_reservation.dart';

class EventDetailPage extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  String organizerName = '-';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrganizerName();
  }

  Future<void> _fetchOrganizerName() async {
    try {
      print("organizer Id : ${widget.event['id_organizer']}");
      final response =
          await ApiService.getDataOrganizer(widget.event['id_organizer']);
      print('Organizer response: $response');
      if (mounted) {
        setState(() {
          organizerName = response['nama_organizer']?.toString() ?? '-';
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching organizer name: $e');
      if (mounted) {
        setState(() {
          organizerName = '-';
          isLoading = false;
        });
      }
    }
  }

  void showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
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
          'Detail Event',
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth > 600 ? 600 : screenWidth,
                  ),
                  child: Column(
                    children: [
                      _buildEventImageSection(context),
                      const SizedBox(height: 15),
                      _buildInfoHeader(),
                      const SizedBox(height: 15),
                      _buildEventInfoCard(),
                      const SizedBox(height: 15),
                      _buildInfoLokasi(),
                      const SizedBox(height: 15),
                      _buildDeskripsiEvent(),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar:
          isLoading ? null : _buildBottomNavigationBar(context),
    );
  }

  Widget _buildEventImageSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.event['image_event'] != null) {
          showFullImage(context, widget.event['image_event']);
        }
      },
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
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
          child: widget.event['image_event'] != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.event['image_event'],
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Icon(Icons.photo, size: 50, color: Colors.grey),
                ),
        ),
      ),
    );
  }

  Widget _buildInfoHeader() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.event['nama_event'] ?? '-',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              fontFamily: 'OpenSans',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Penyelenggara: $organizerName',
            style: TextStyle(
              fontSize: 18,
              // fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              fontFamily: 'OpenSans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventInfoCard() {
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
          _buildCardTitle('Detail Event'),
          const SizedBox(height: 20),
          _buildAlignedDetailItem(
              'Kategori', widget.event['kategori_event'] ?? '-'),
          const SizedBox(height: 15),
          _buildAlignedDetailItem(
            'HTM',
            widget.event['htm_event'] != null
                ? 'Rp ${NumberFormat('#,###').format(widget.event['htm_event'])}'
                : '-',
          ),
          const SizedBox(height: 15),
          _buildAlignedDetailItem(
            'Tanggal',
            widget.event['tanggal_event'] != null
                ? DateFormat('dd MMM yyyy')
                    .format(DateTime.parse(widget.event['tanggal_event']))
                : '-',
          ),
          const SizedBox(height: 15),
          _buildAlignedDetailItem('Waktu', widget.event['waktu_event'] ?? '-'),
        ],
      ),
    );
  }

  Widget _buildInfoLokasi() {
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
          _buildCardTitle('Informasi Lokasi'),
          const SizedBox(height: 20),
          _buildAlignedDetailItem(
              'Kota Event', widget.event['kota_event'] ?? '-'),
          const SizedBox(height: 15),
          _buildAlignedDetailItem(
              'Lokasi', widget.event['alamat_event'] ?? '-'),
        ],
      ),
    );
  }

  Widget _buildDeskripsiEvent() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle('Deskripsi Event'),
          const SizedBox(height: 20),
          Text(
            widget.event['deskripsi_event'] ?? '-',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontFamily: 'OpenSans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlignedDetailItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontFamily: 'OpenSans',
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
              color: AppColors.blackColor,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
          fontFamily: 'OpenSans',
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReservationPage(event: widget.event),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'Reservasi Event',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
