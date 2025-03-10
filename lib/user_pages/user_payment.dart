// import 'package:flutter/material.dart';
// import 'package:pit_box/api_service.dart';
// import 'package:pit_box/components/asset_warna.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class PaymentPage extends StatefulWidget {
//   final String reservationId;
//   final int totalAmount;

//   const PaymentPage(
//       {Key? key, required this.reservationId, required this.totalAmount})
//       : super(key: key);

//   @override
//   _PaymentPageState createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   bool _isLoading = false;

//   Future<void> _processPayment() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final response = await ApiService.createPayment(
//         idReservasi: widget.reservationId,
//         totalHarga: widget.totalAmount,
//         metodePembayaran: 'Midtrans', // Contoh metode pembayaran
//       );

//       if (response['redirect_url'] != null) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => WebView(
//               initialUrl: response['redirect_url'],
//               javascriptMode: JavascriptMode.unrestricted,
//             ),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Gagal memproses pembayaran.')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Gagal memproses pembayaran: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pembayaran'),
//         backgroundColor: AppColors.primaryColor,
//       ),
//       body: Center(
//         child: _isLoading
//             ? CircularProgressIndicator()
//             : ElevatedButton(
//                 onPressed: _processPayment,
//                 child: Text('Proses Pembayaran'),
//               ),
//       ),
//     );
//   }
// }
