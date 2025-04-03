import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_alert.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/components/assset_button_loading.dart';
import 'package:pit_box/user_pages/user_payment.dart';
import 'package:pit_box/user_pages/web_view.dart';

class ReservationPage extends StatefulWidget {
  final Map<String, dynamic> event;

  const ReservationPage({Key? key, required this.event}) : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final TextEditingController _nameController = TextEditingController();
  String _message = '';
  bool _isLoading = false;
  String _username = '';
  String _userId = '';
  String _paymentMethod = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await ApiService.getUserData();
    setState(() {
      _username = userData['nama_user'] ?? '';
      _userId = userData['id_user'] ?? '';
      _nameController.text = _username;
      // You might want to pre-fill email if available in user data
    });
  }

  Future<void> _createReservation() async {
    if (_nameController.text.isEmpty || _paymentMethod.isEmpty) {
      showCustomDialog(
        context: context,
        isSuccess: false,
        title: 'Gagal',
        message: Text('Harap isi semua informasi yang diperlukan.'),
        routeName: '',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Buat reservasi
      final reservationResponse = await ApiService.createReservation(
        idUser: _userId,
        idEvent: widget.event['_id'],
        namaTim: _nameController.text,
        metode_pembayaran: _paymentMethod,
      );
      print("paymentResponse: $reservationResponse");
      if (reservationResponse['status'] == 'success') {
        print("masuk success");
        final reservationId = reservationResponse['data']['_id'];
        final totalHarga = widget.event['htm_event'] +
            2000; // Tambahkan pajak atau biaya lainnya
        print("reservationId: $reservationId");
        print("totalHarga: $totalHarga");
        // Proses pembayaran
        final paymentResponse = await ApiService.createPayment(
          idReservasi: reservationId,
          totalHarga: totalHarga,
          metodePembayaran: _paymentMethod,
        );
        print("paymentResponse: $paymentResponse");

        if (paymentResponse['status'] == 'success') {
          final paymentUrl = paymentResponse['data']['redirect_url'];
          print("paymentUrl: $paymentUrl");

          // Navigasi ke halaman webview untuk pembayaran
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewPage(
                url: paymentUrl,
              ),
            ),
          );

          // Navigasi ke halaman pembayaran
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => UserPaymentPage(
          //       reservationId: reservationId,
          //       amount: totalHarga,
          //     ),
          //   ),
          // );
        } else {
          throw Exception('Gagal memproses pembayaran.');
        }
      } else {
        throw Exception('Gagal membuat reservasi.');
      }
    } catch (e) {
      showCustomDialog(
        context: context,
        isSuccess: false,
        title: 'Gagal',
        message: Text('${e.toString().replaceAll('Exception: ', '')}'),
        routeName: '',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final width = screenWidth * 0.9; // Adjusted width to make container wider

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.95,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.05, // Adjusted padding
                            right: screenWidth * 0.05, // Adjusted padding
                            top: 40),
                        child: Text(
                          'Rincian Pemesanan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: isSmallScreen ? 30 : 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Personal Information
                      Container(
                        width: width,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Informasi Racer',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            MyTextField(
                              controller: _nameController,
                              width: width,
                              hintText: 'Nama Tim',
                              obScureText: false,
                            ),
                            // const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Checkbox(
                                    value: _nameController.text == _username,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          _nameController.text = _username;
                                        } else {
                                          _nameController.clear();
                                        }
                                      });
                                    },
                                  ),
                                  Text('Gunakan nama saya'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Event Information
                      Container(
                        width: width,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Informasi Event',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            _buildSummaryItem(
                                'Nama Event', widget.event['nama_event']),
                            _buildSummaryItem(
                                'Class',
                                widget.event['kategori_event'] ??
                                    '20 July 2024'),

                            _buildSummaryItem(
                                'Tanggal',
                                widget.event['tanggal_event'] != null
                                    ? DateFormat('dd-MMM-yyyy').format(
                                        DateTime.parse(
                                            widget.event['tanggal_event']))
                                    : '20 July 2024'),
                            _buildSummaryItem(
                                'Jam',
                                widget.event[
                                    'waktu_event']), // You might want to make this dynamic
                            _buildSummaryItem(
                                'Jumlah reservasi', '1'), // Adjust as needed
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Payment Summary
                      Container(
                        width: width,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detail Pembayaran',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            _buildSummaryItem('Subtotal',
                                'Rp ${NumberFormat("#,##0", "id_ID").format(widget.event['htm_event'])}'), // Replace with actual data
                            _buildSummaryItem('Biaya Layanan',
                                'Rp 2.000'), // Replace with actual data
                            Divider(),
                            _buildSummaryItem(
                              'Total Pembayaran',
                              'Rp ${NumberFormat("#,##0", "id_ID").format(widget.event['htm_event'] + 2000)}', // Replace with actual data
                              // style: TextStyle(
                              //   fontSize: 18,
                              //   color: Colors.blue,
                              //   fontWeight: FontWeight.bold,
                              // ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      Container(
                        width: width,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Metode Pembayaran',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _paymentMethod = 'other_qris';
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: _paymentMethod == 'other_qris'
                                          ? Colors.blue
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.qr_code,
                                          color: _paymentMethod == 'other_qris'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'QRIS',
                                          style: TextStyle(
                                            color:
                                                _paymentMethod == 'other_qris'
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _paymentMethod = 'bank_transfer';
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: _paymentMethod == 'bank_transfer'
                                          ? Colors.blue
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.account_balance,
                                          color:
                                              _paymentMethod == 'bank_transfer'
                                                  ? Colors.white
                                                  : Colors.black,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'VA Bank Transfer',
                                          style: TextStyle(
                                            color: _paymentMethod ==
                                                    'bank_transfer'
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Pay and Reserve Button
                      _isLoading
                          ? CircularProgressIndicator()
                          : MyLoadingButton(
                              label: "PAY AND RESERVE",
                              width: width,
                              onTap: () async {
                                await _createReservation();
                              },
                            ),

                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Back to event',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w400,
                            fontSize: isSmallScreen ? 16 : 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
