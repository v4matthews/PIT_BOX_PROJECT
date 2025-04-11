import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_alert.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/components/assset_button_loading.dart';
import 'package:pit_box/user_pages/user_dashboard.dart';
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
      final reservationResponse = await ApiService.createReservation(
        idUser: _userId,
        idEvent: widget.event['_id'],
        namaTim: _nameController.text,
        metode_pembayaran: _paymentMethod,
      );

      if (reservationResponse['status'] == 'success') {
        final reservationId = reservationResponse['data']['_id'];
        final totalHarga = widget.event['htm_event'] + 2000;

        final paymentResponse = await ApiService.createPayment(
          idReservasi: reservationId,
          totalHarga: totalHarga,
          metodePembayaran: _paymentMethod,
        );

        if (paymentResponse['status'] == 'success') {
          final paymentUrl = paymentResponse['data']['redirect_url'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewPage(url: paymentUrl),
            ),
          );
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

  Widget _buildSummaryItem(String label, String value, {bool isTotal = false}) {
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
              color: isTotal ? AppColors.primaryColor : Colors.black,
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption(String method, String label, IconData icon) {
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = method),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: _paymentMethod == method
              ? AppColors.primaryColor.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _paymentMethod == method
                ? AppColors.primaryColor
                : Colors.grey[300]!,
            width: _paymentMethod == method ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: _paymentMethod == method
                  ? AppColors.primaryColor
                  : Colors.grey[700],
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: _paymentMethod == method
                    ? AppColors.primaryColor
                    : Colors.grey[700],
                fontWeight: _paymentMethod == method
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (_paymentMethod == method)
              Icon(
                Icons.check_circle,
                color: AppColors.primaryColor,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      resizeToAvoidBottomInset: false,
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
          'Rincian Pemesanan',
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
      ),
      body: Stack(
        children: [
          // Background Image

          // Content
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                  top: 20, left: 16, right: 16, bottom: 100),
              child: Column(
                children: [
                  // Racer Information
                  _buildSection(
                    'Informasi Racer',
                    Column(
                      children: [
                        MyTextField(
                          controller: _nameController,
                          width: double.infinity,
                          hintText: 'Nama Tim',
                          obScureText: false,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Checkbox(
                              value: _nameController.text == _username,
                              onChanged: (bool? value) {
                                setState(() {
                                  _nameController.text =
                                      value == true ? _username : '';
                                });
                              },
                            ),
                            const Text('Gunakan nama saya'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Event Information
                  _buildSection(
                    'Informasi Event',
                    Column(
                      children: [
                        _buildSummaryItem(
                            'Nama Event', widget.event['nama_event']),
                        _buildSummaryItem(
                            'Class', widget.event['kategori_event'] ?? '-'),
                        _buildSummaryItem(
                          'Tanggal',
                          widget.event['tanggal_event'] != null
                              ? DateFormat('dd-MMM-yyyy').format(
                                  DateTime.parse(widget.event['tanggal_event']))
                              : '-',
                        ),
                        _buildSummaryItem(
                            'Jam', widget.event['waktu_event'] ?? '-'),
                        _buildSummaryItem('Jumlah reservasi', '1'),
                      ],
                    ),
                  ),

                  // Payment Summary
                  _buildSection(
                    'Detail Pembayaran',
                    Column(
                      children: [
                        _buildSummaryItem(
                          'Subtotal',
                          'Rp ${NumberFormat("#,##0", "id_ID").format(widget.event['htm_event'])}',
                        ),
                        _buildSummaryItem('Biaya Layanan', 'Rp 2.000'),
                        const Divider(height: 24),
                        _buildSummaryItem(
                          'Total Pembayaran',
                          'Rp ${NumberFormat("#,##0", "id_ID").format(widget.event['htm_event'] + 2000)}',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),

                  // Payment Method
                  _buildSection(
                    'Metode Pembayaran',
                    Column(
                      children: [
                        _buildPaymentMethodOption(
                            'other_qris', 'QRIS', Icons.qr_code),
                        const SizedBox(height: 8),
                        _buildPaymentMethodOption('bank_transfer',
                            'VA Bank Transfer', Icons.account_balance),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : MyLoadingButton(
                      label: "BAYAR DAN RESERVASI",
                      width: double.infinity,
                      onTap: _createReservation,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
