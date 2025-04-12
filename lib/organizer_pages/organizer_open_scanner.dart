import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_warna.dart';

class OrganizerOpenScanner extends StatefulWidget {
  @override
  _OrganizerOpenScannerState createState() => _OrganizerOpenScannerState();
}

class _OrganizerOpenScannerState extends State<OrganizerOpenScanner> {
  String? idTiket;

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
          'Scan Tiket',
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
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                  setState(() {
                    final Map<String, dynamic> jsonData =
                        jsonDecode(barcodes.first.rawValue!);
                    idTiket = jsonData['id_tiket'];
                  });

                  if (idTiket != null) {
                    // Cetak data hasil scan ke konsol
                    print('ID Tiket: $idTiket');
                    // Pause scanner setelah berhasil scan
                    MobileScannerController().stop();
                  } else {
                    // Tampilkan snackbar jika id_tiket tidak ditemukan
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tiket tidak valid'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              controller: MobileScannerController(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: idTiket != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'ID Tiket:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          idTiket!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await ApiService.updateTicketStatus(idTiket!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      const Text('Berhasil Check In Tiket'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              // Navigator.pop(context, idTiket);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Gagal memproses tiket: ${e.toString().split(':').last.trim()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentColor,
                          ),
                          child: const Text(
                            'Konfirmasi Sign In',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      'Arahkan kamera ke QR Code',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
