import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/organizer_pages/organizer_home_page.dart';
import 'package:pit_box/organizer_pages/organizer_open_scanner.dart';
import 'package:pit_box/organizer_pages/organizer_update_event.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart'; // Add this import

class OrganizerEventDetailPage extends StatefulWidget {
  final Map<String, dynamic> event;

  const OrganizerEventDetailPage({
    super.key,
    required this.event,
  });

  @override
  State<OrganizerEventDetailPage> createState() =>
      _OrganizerEventDetailPageState();
}

class _OrganizerEventDetailPageState extends State<OrganizerEventDetailPage> {
  late Future<List<Map<String, dynamic>>> _participantsFuture;
  bool _isLoading = true;
  List<Map<String, dynamic>> _participants = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false); // Add refresh controller

  @override
  void initState() {
    super.initState();
    _loadParticipants();
  }

  Future<void> _loadParticipants() async {
    try {
      setState(() => _isLoading = true);
      final participants =
          await ApiService.getParticipants(widget.event['_id'].toString());
      setState(() {
        _participants = participants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // Add this function for pull-to-refresh
  void _onRefresh() async {
    await _loadParticipants();
    _refreshController.refreshCompleted();
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
      body: SmartRefresher(
        // Wrap your content with SmartRefresher
        controller: _refreshController,
        onRefresh: _onRefresh,
        enablePullDown: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenWidth > 600 ? 600 : screenWidth,
              ),
              child: Column(
                children: [
                  _buildEventImageSection(),
                  const SizedBox(height: 15),
                  _buildEventInfoCard(),
                  const SizedBox(height: 15),
                  _buildParticipantsList(),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 100,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.qr_code_scanner,
                color: AppColors.primaryText,
                size: 32,
              ),
              onPressed: () async {
                final scannedData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrganizerOpenScanner(),
                  ),
                );

                if (scannedData != null) {
                  // Handle the scanned data
                  debugPrint('Scanned QR Code Data: $scannedData');
                }
              },
            ),
            const Text(
              'Scan Ticket',
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventImageSection() {
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
            'Total Pendapatan Anda',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.primaryColor,
              fontFamily: 'OpenSans',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            (widget.event['htm_event'] != null && _participants.isNotEmpty)
                ? 'Rp ${NumberFormat('#,###').format(widget.event['htm_event'] * _participants.length)}'
                : 'Rp 0',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
              fontFamily: 'OpenSans',
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Status Event',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryColor,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.event['status_event'] ?? '-',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: widget.event['status_event'] == 'ongoing'
                            ? AppColors.greenColor
                            : widget.event['status_event'] == 'upcoming'
                                ? AppColors.yellowColor
                                : (widget.event['status_event'] ==
                                            'completed' ||
                                        widget.event['status_event'] ==
                                            'cancelled')
                                    ? Colors.grey
                                    : Colors.grey,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 45,
                child: VerticalDivider(
                  color: AppColors.lightGreyText,
                  thickness: 1,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Jumlah Peserta',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryColor,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _participants.length.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
            'Nama Event',
            widget.event['nama_event'] ?? '-',
          ),
          const SizedBox(height: 15),
          _buildAlignedDetailItem(
            'Kategori',
            widget.event['kategori_event'] ?? '-',
          ),
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
          _buildAlignedDetailItem(
            'Waktu',
            widget.event['waktu_event'] ?? '-',
          ),
          const SizedBox(height: 15),
          _buildAlignedDetailItem(
            'Kota',
            widget.event['kota_event'] ?? '-',
          ),
          const SizedBox(height: 15),
          _buildAlignedDetailItem(
            'Lokasi',
            widget.event['alamat_event'] ?? '-',
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  if (_participants.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Tidak bisa menghapus event karena sudah ada peserta yang terdaftar.',
                        ),
                      ),
                    );
                    return;
                  }

                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Konfirmasi'),
                      content: const Text(
                          'Apakah Anda yakin ingin menghapus event ini?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Hapus'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    // Call API to delete the event
                    try {
                      await ApiService.deleteEvent(
                          widget.event['_id'].toString());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Berhasil menghapus event')),
                      );
                      Navigator.pop(context); // Go back after deletion
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gagal menghapus event')),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.delete, color: AppColors.redColor),
                label: const Text(
                  'Hapus Event',
                  style: TextStyle(color: AppColors.redColor),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: AppColors.primaryText),
                  ),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to the edit event page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrganizerUpdateEventPage(
                          event: widget
                              .event), // Pass the event data to the edit event page
                    ),
                  );
                },
                icon: const Icon(Icons.edit, color: AppColors.primaryText),
                label: const Text(
                  'Edit Event',
                  style: TextStyle(color: AppColors.primaryText),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: AppColors.primaryText),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsList() {
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildCardTitle('Daftar Peserta'),
          ),
          const SizedBox(height: 20),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_participants.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Belum ada peserta yang terdaftar.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'No',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Nama Tim',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Status Peserta',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _participants.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final participant = _participants[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              participant['nama_tim'] ?? 'Nama tidak tersedia',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryText,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              participant['status_ticket'] ?? '-',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryText,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
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
          flex: 4,
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

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'diterima':
        return Colors.green;
      case 'menunggu':
        return Colors.orange;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Widget _buildBottomNavigationBar(BuildContext context) {
  //   return BottomAppBar(
  //     color: Colors.white,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         IconButton(
  //           icon: const Icon(Icons.edit_note_rounded),
  //           color: AppColors.primaryText,
  //           onPressed: () {
  //             // Navigasi ke halaman edit event
  //           },
  //         ),
  //         IconButton(
  //           icon: const Icon(Icons.qr_code_scanner),
  //           color: AppColors.primaryText,
  //           onPressed: () async {
  //             // final scannedData = await Navigator.push(
  //             //   context,
  //             //   MaterialPageRoute(
  //             //     builder: (context) => const OrganizerOpenScanner(),
  //             //   ),
  //             // );

  //             // if (scannedData != null) {
  //             //   // Lakukan sesuatu dengan data yang di-scan
  //             //   debugPrint('Data QR Code: $scannedData');
  //             // }
  //           },
  //         ),
  //         IconButton(
  //           icon: const Icon(Icons.check_circle_outline_rounded),
  //           color: AppColors.primaryText,
  //           onPressed: () {
  //             // Navigasi ke halaman set achievement
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: AppColors.primaryText,
      unselectedItemColor: AppColors.primaryText,
      backgroundColor: Colors.white,
      currentIndex: 1,
      type: BottomNavigationBarType.fixed, // Semua item terlihat

      iconSize: 28, // Ukuran ikon
      // onTap: (index) async {
      //   if (index == 1) {
      //     final scannedData = await Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => OrganizerOpenScanner(),
      //       ),
      //     );

      //     if (scannedData != null) {
      //       // Lakukan sesuatu dengan data yang di-scan
      //       print('Data QR Code: $scannedData');
      //     }
      //   }
      // },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.edit_note_rounded),
          label: 'Edit Event',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner),
          label: 'Scan Ticket',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_circle_outline_rounded),
          label: 'Set Achivement',
        ),
      ],
    );
  }
}
