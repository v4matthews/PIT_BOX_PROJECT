import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_alert.dart';
import 'package:pit_box/components/asset_button.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_textfield_email.dart';
import 'package:pit_box/components/asset_textfield_number.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/components/assset_button_loading.dart';

class UserForgetPassword extends StatelessWidget {
  UserForgetPassword({super.key});

  final emailController = TextEditingController();
  final nomorTeleponController = TextEditingController();

  // Fungsi forgot password
  Future<void> forgotUser(BuildContext context) async {
    try {
      // Mengambil email dan nomor telepon dari controller
      final response = await ApiService.forgotUser(
        email: emailController.text,
        nomorTelepon: nomorTeleponController.text,
      );

      // Jika berhasil, arahkan ke halaman login
      if (response['status'] == 'sukses') {
        showCustomDialog(
          context: context,
          isSuccess: true,
          title: 'Periksa Email Anda',
          message: Text(response['message']),
          routeName: '/login',
        );
      } else {
        showCustomDialog(
          context: context,
          isSuccess: false,
          title: 'Gagal diproses',
          message: Text(response['message']),
          routeName: '/login',
        );
      }
    } catch (e) {
      showCustomDialog(
        context: context,
        isSuccess: false,
        title: 'Gagal Mengirim Password',
        message: Text(e.toString()),
        routeName: '/login',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600; // Deteksi layar kecil
    final width = screenWidth * 0.8;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
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
              height: MediaQuery.of(context).size.height * 0.7,
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
                            top: 120),
                        child: Text(
                          'Forgot Password',
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
                            horizontal: screenWidth * 0.05, vertical: 10),
                        child: Text(
                          'Kami akan mengirimkan password Anda melalui email. Pastikan email dan nomor telepon Anda aktif.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: isSmallScreen ? 16 : 22,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Email textfield
                      EmailTextField(
                        controller: emailController,
                        width: width,
                        hintText: 'Email',
                        obScureText: false,
                      ),

                      const SizedBox(height: 20),

                      // Phone number textfield
                      NumberTextField(
                        controller: nomorTeleponController,
                        width: width,
                        hintText: 'Nomor Telepon',
                        obScureText: false,
                      ),

                      const SizedBox(height: 50),

                      // Send Password Button
                      MyLoadingButton(
                        label: "SEND PASSWORD",
                        width: width,
                        onTap: () async {
                          await forgotUser(context);
                        },
                      ),

                      const SizedBox(height: 20),

                      // Sign Up Option
                      Container(
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Kembali ke halaman ',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: isSmallScreen ? 16 : 22,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w300,
                                      fontSize: isSmallScreen ? 16 : 22,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
