import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/webview_page.dart';

class EventDetailPage extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A59A9),
        title: const Text(
          'DETAIL EVENT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold, // Set the title text color to white
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar event
            Container(
              width: MediaQuery.of(context).size.width,
              child: AspectRatio(
                aspectRatio: 1, // Rasio aspek 1:1
                child: event['gambar_event'] != null
                    ? Image.network(
                        event['gambar_event'],
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Text(
                            'Foto Tidak Tersedia',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Nama Event
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 18.0, vertical: 6.0), // Reduced vertical padding
              child: Text(
                event['nama_event'] ?? 'Nama Race',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 18.0, vertical: 2.0), // Reduced vertical padding
              child: Text(
                'Class: ${event['kategori_event'] ?? '-'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10), // Reduced height of the SizedBox

            // Detail event dengan shadow
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6.0, // Radius blur
                    offset: const Offset(3, 3), // Posisi bayangan (x, y)
                  ),
                ],
              ),
              width: double.infinity, // Lebar penuh layar
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DAY & TIME',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      (event['tanggal_event'] != null &&
                              event['waktu_event'] != null)
                          ? '${DateFormat('dd-MMM-yyyy').format(DateTime.parse(event['tanggal_event']))} | ${event['waktu_event']}'
                          : '-',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'PRICE',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Rp: ${event['htm_event'] ?? '-'}',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6.0, // Radius blur
                    offset: const Offset(3, 3), // Posisi bayangan (x, y)
                  ),
                ],
              ),
              width: double.infinity, // Lebar penuh layar
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LOCATION',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${event['kota_event']}',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${event['alamat_event']}',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'DESCRIPTION',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      event['deskripsi_event'] ?? '-',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          child: ElevatedButton(
            onPressed: () => _getTicket(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A59A9),
              padding: const EdgeInsets.symmetric(vertical: 5),
            ),
            child: Text(
              'GET TICKET',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getTicket(BuildContext context) async {
    final transactionData = {
      "id_event": event['id_event'],
      "nama_event": event['nama_event'],
      "htm_event": event['htm_event'],
      "nama_user": "Nama User", // Replace with actual user name
      "email_user": "user@example.com", // Replace with actual user email
    };

    final redirectUrl = await ApiService.createTransaction(transactionData);

    if (redirectUrl != null) {
      // Open the payment URL in a webview or browser
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewPage(url: redirectUrl),
        ),
      );
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create transaction')),
      );
    }
  }
}
