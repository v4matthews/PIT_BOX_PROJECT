import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/session_service.dart';
import 'package:pit_box/user_pages/user_dashboard.dart';
import 'package:pit_box/user_pages/user_ticket_detail.dart';

class TicketListPage extends StatefulWidget {
  const TicketListPage({super.key});

  @override
  _TicketListPageState createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage>
    with SingleTickerProviderStateMixin {
  late Future<List<Ticket>> _ticketsFuture;
  String _userId = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final userData = await SessionService.getUserData();
      debugPrint("User Data: $userData");
      setState(() {
        _userId = userData['id_user'] ?? '';
      });

      if (_userId.isNotEmpty) {
        setState(() {
          _ticketsFuture = _fetchTickets();
          _isLoading = false;
        });
      } else {
        debugPrint('User ID not found in session.');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Failed to initialize data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Ticket>> _fetchTickets() async {
    try {
      final List<dynamic> ticketData = await ApiService.getTickets(_userId);
      return ticketData.map((data) => Ticket.fromJson(data)).toList();
    } catch (e) {
      debugPrint('Failed to fetch tickets: $e');
      throw Exception('Gagal memuat tiket: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Active dan Inactive tickets
      child: Scaffold(
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
            'Daftar Tiket',
            style: TextStyle(
              color: AppColors.whiteText,
              fontSize: 18,
              fontFamily: 'OpenSans',
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.whiteText),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => UserDashboard()),
              (route) => false,
            ),
          ),
          bottom: const TabBar(
            labelColor: AppColors.whiteText,
            unselectedLabelColor: AppColors.whiteColor,
            indicatorColor: AppColors.whiteText,
            labelStyle: TextStyle(fontFamily: 'OpenSans'),
            tabs: [
              Tab(text: 'Belum Check-in'),
              Tab(text: 'Sudah Check-in'),
            ],
          ),
        ),
        body: _isLoading
            ? _buildLoadingIndicator()
            : _userId.isEmpty
                ? _buildErrorMessage('User ID tidak ditemukan')
                : FutureBuilder<List<Ticket>>(
                    future: _ticketsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadingIndicator();
                      } else if (snapshot.hasError) {
                        return _buildErrorMessage(snapshot.error.toString());
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return _buildEmptyMessage();
                      }

                      final tickets = snapshot.data!;
                      return TabBarView(
                        children: [
                          _buildTicketList(tickets
                              .where((ticket) =>
                                  ticket.statusTicket == 'belum check-in')
                              .toList()),
                          _buildTicketList(tickets
                              .where((ticket) =>
                                  ticket.statusTicket == 'sudah check-in')
                              .toList()),
                        ],
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
      ),
    );
  }

  Widget _buildErrorMessage(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          error.replaceAll('Exception: ', ''),
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildEmptyMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          'Tidak ada tiket yang ditemukan.',
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTicketList(List<Ticket> tickets) {
    if (tickets.isEmpty) {
      return _buildEmptyMessage();
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _ticketsFuture = _fetchTickets();
        });
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return _buildTicketCard(ticket);
        },
      ),
    );
  }

  Widget _buildTicketCard(Ticket ticket) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TicketDetailPage(ticket: ticket),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTicketHeader(ticket),
              const SizedBox(height: 12),
              _buildDetailRow('Nama Tim: ${ticket.namaTim}'),
              _buildDetailRow(
                'Tanggal: ${ticket.eventDate != 'N/A' ? DateFormat('dd MMM yyyy').format(DateTime.parse(ticket.eventDate)) : '-'}',
              ),
              _buildDetailRow('Waktu: ${ticket.eventTime}'),
              _buildDetailRow('Lokasi: ${ticket.eventLocation}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketHeader(Ticket ticket) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            ticket.eventName,
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
            color: ticket.statusTicket == 'sudah check-in'
                ? AppColors.greenColor
                : AppColors.yellowColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            ticket.statusTicket == 'sudah check-in'
                ? 'Sudah Check-in'
                : 'Belum Check-in',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

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
}

class Ticket {
  final String id;
  final String transactionId;
  final String userId;
  final String eventId;
  final String namaTim;
  final String eventName;
  final String eventDate;
  final String eventTime;
  final String eventLocation;
  final String eventPrice;
  final String statusTicket;

  Ticket({
    required this.id,
    required this.transactionId,
    required this.userId,
    required this.eventId,
    required this.namaTim,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    required this.eventPrice,
    required this.statusTicket,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['_id'] ?? 'N/A',
      transactionId: json['id_transaksi'] ?? 'N/A',
      userId: json['id_user'] ?? 'N/A',
      eventId: json['id_event'] ?? 'N/A',
      namaTim: json['nama_tim'] ?? 'N/A',
      eventName: json['nama_event'] ?? 'N/A',
      eventDate: json['tanggal_event'] ?? 'N/A',
      eventTime: json['waktu_event'] ?? 'N/A',
      eventLocation: json['lokasi_event'] ?? 'N/A',
      eventPrice: json['htm_event']?.toString() ?? '-',
      statusTicket: json['status_ticket'] ?? 'belum check-in',
    );
  }
}
