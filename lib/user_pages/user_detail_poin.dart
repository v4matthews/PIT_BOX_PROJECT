import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_warna.dart';

class UserDetailPoinPage extends StatelessWidget {
  final int totalPoin;
  final List<Map<String, dynamic>> poinHistory;

  const UserDetailPoinPage({
    Key? key,
    required this.totalPoin,
    required this.poinHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        iconTheme: const IconThemeData(color: AppColors.whiteText),
      ),
      body: Column(
        children: [
          // Top section: Total Points
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                const Text(
                  'Total Poin Anda',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                    fontFamily: 'OpenSans',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  totalPoin.toString(),
                  style: const TextStyle(
                    fontSize: 30, // Increased font size for emphasis
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                    fontFamily: 'OpenSans',
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
          // Bottom section: Points history
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: AppColors.backgroundGrey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Riwayat Pendapatan Poin',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    child: poinHistory.isEmpty
                        ? const Center(
                            child: Text('Tidak ada riwayat poin'),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: poinHistory.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final history = poinHistory[index];
                              return Card(
                                elevation: 2,
                                margin: EdgeInsets.zero,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  title: Text(
                                    history['description'] ?? 'No description',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      'Tanggal: ${history['date'] ?? 'N/A'} | Poin: ${history['poin']?.toString() ?? '0'}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  trailing: Text(
                                    '+${history['poin']?.toString() ?? '0'}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: UserDetailPoinPage(
      totalPoin: 1200,
      poinHistory: [
        {
          'description': 'Menyelesaikan tugas A',
          'date': '2023-10-01',
          'poin': 200
        },
        {
          'description': 'Menyelesaikan tugas B',
          'date': '2023-10-05',
          'poin': 300
        },
        {
          'description': 'Menyelesaikan tugas C',
          'date': '2023-10-10',
          'poin': 700
        },
      ],
    ),
  ));
}
