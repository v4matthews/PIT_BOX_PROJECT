// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:pit_box/components/asset_warna.dart';

// class OrganizerOpenScanner extends StatefulWidget {
//   @override
//   _OrganizerOpenScannerState createState() => _OrganizerOpenScannerState();
// }

// class _OrganizerOpenScannerState extends State<OrganizerOpenScanner> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   String? scannedData;

//   @override
//   void reassemble() {
//     super.reassemble();
//     if (controller != null) {
//       controller!.pauseCamera();
//       controller!.resumeCamera();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/images/bg.jpg'),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         backgroundColor: Colors.transparent,
//         centerTitle: true,
//         title: const Text(
//           'Scan Tiket',
//           style: TextStyle(
//             color: AppColors.whiteText,
//             fontSize: 18,
//             fontFamily: 'OpenSans',
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppColors.whiteText),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 4,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//               overlay: QrScannerOverlayShape(
//                 borderColor: AppColors.primaryColor,
//                 borderRadius: 10,
//                 borderLength: 30,
//                 borderWidth: 10,
//                 cutOutSize: MediaQuery.of(context).size.width * 0.8,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Center(
//               child: scannedData != null
//                   ? Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Data QR Code:',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           scannedData!,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         const SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: () {
//                             Navigator.pop(context, scannedData);
//                           },
//                           child: const Text('Konfirmasi'),
//                         ),
//                       ],
//                     )
//                   : const Text(
//                       'Arahkan kamera ke QR Code',
//                       style: TextStyle(fontSize: 16),
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         scannedData = scanData.code;
//       });
//       controller.pauseCamera(); // Pause kamera setelah berhasil scan
//     });
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }
