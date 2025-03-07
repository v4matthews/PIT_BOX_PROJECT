import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_alert.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/components/assset_button_loading.dart';

class ReservationPage extends StatefulWidget {
  final Map<String, dynamic> event;

  const ReservationPage({Key? key, required this.event}) : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final TextEditingController _teamNameController = TextEditingController();
  String _message = '';
  bool _isLoading = false;
  bool _useUsernameAsTeamName = false;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await ApiService.getUserData();
    setState(() {
      _username = userData['nama_user'] ?? '';
    });
  }

  Future<void> _createReservation() async {
    if (_teamNameController.text.isEmpty) {
      showCustomDialog(
        context: context,
        isSuccess: false,
        title: 'Gagal',
        message: Text('Nama tim belum diisi.'),
        routeName: '',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userData = await ApiService.getUserData();
      final response = await ApiService.createReservation(
        idUser: userData['_id']!,
        idEvent: widget.event['id_event'],
        namaTim: _teamNameController.text,
      );

      if (response) {
        showCustomDialog(
          context: context,
          isSuccess: true,
          title: 'Berhasil',
          message: Text('Reservasi berhasil dibuat!'),
          routeName: '/home',
        );
      } else {
        showCustomDialog(
          context: context,
          isSuccess: false,
          title: 'Gagal',
          message: Text('Gagal membuat reservasi.'),
          routeName: '/home',
        );
      }
    } catch (e) {
      showCustomDialog(
        context: context,
        isSuccess: false,
        title: 'Gagal',
        message: Text('Gagal membuat reservasi: $e'),
        routeName: '/home',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final width = screenWidth * 0.8;

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: Stack(
        children: [
          // Layer 1: Background Biru
          Container(
            color: AppColors.primaryColor,
          ),
          // Layer 2: Layer dengan 60% dari ukuran layar, rounded 50px, dan berwarna putih
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
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
                      // Title Page
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.1,
                            right: screenWidth * 0.1,
                            top: 40),
                        child: Text(
                          'Buat Reservasi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: isSmallScreen ? 35 : 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Sub Title Text
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.1, vertical: 10),
                        child: Text(
                          'Pastikan data yang Anda masukkan benar untuk mempermudah proses reservasi.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: isSmallScreen ? 16 : 22,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Nama Tim textfield
                      MyTextField(
                        controller: _teamNameController,
                        width: width,
                        hintText: 'Nama Tim',
                        obScureText: false,
                      ),

                      const SizedBox(height: 10),

                      // Checkbox untuk menggunakan nama pengguna sebagai nama tim
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _useUsernameAsTeamName,
                            onChanged: (bool? value) {
                              setState(() {
                                _useUsernameAsTeamName = value ?? false;
                                if (_useUsernameAsTeamName) {
                                  _teamNameController.text = _username;
                                } else {
                                  _teamNameController.clear();
                                }
                              });
                            },
                          ),
                          Text(
                            'Gunakan nama pengguna sebagai nama tim',
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Buat Reservasi Button
                      _isLoading
                          ? CircularProgressIndicator()
                          : MyLoadingButton(
                              label: "BUAT RESERVASI",
                              width: width,
                              onTap: () async {
                                await _createReservation();
                              },
                            ),

                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          // Navigate to the previous page when the row is tapped
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Kembali ke list event? ',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: isSmallScreen ? 16 : 22,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Kembali',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w400,
                                fontSize: isSmallScreen ? 16 : 22,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // // Pesan
                      // Text(
                      //   _message,
                      //   style: TextStyle(
                      //     color: _message.contains('berhasil')
                      //         ? Colors.green
                      //         : Colors.red,
                      //     fontSize: 16,
                      //   ),
                      // ),
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
