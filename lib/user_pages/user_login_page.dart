import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_alert.dart';
import 'package:pit_box/components/asset_button.dart';
import 'package:pit_box/components/asset_custom_dialog.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_textfield_password.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/components/assset_button_loading.dart';
import 'package:pit_box/components/square_tile.dart';
import 'package:pit_box/organizer_pages/organizer_forgot.dart';
import 'package:pit_box/organizer_pages/organizer_home.dart';
import 'package:pit_box/organizer_pages/organizer_login_page.dart';
import 'package:pit_box/organizer_pages/organizer_register_page.dart';
import 'package:pit_box/session_service.dart';
import 'package:pit_box/user_pages/user_forgot.dart';
import 'dart:convert';

import 'package:pit_box/user_pages/user_register_page.dart';

void main() {
  runApp(LoginPage());
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false, // Prevent screen from shifting up
        body: TwoLayerPage(),
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/forgotUser': (context) => UserForgetPassword(),
        '/loginOrganizer': (context) => OrganizerLoginPage(),
        '/forgotOrganizer': (context) => OrganizerForgotPassword(),
        '/registerOrganizer': (context) => OrganizerRegisterPage(),
        '/homeOrganizer': (context) => organizerHome(),
        // Tambahkan rute lain jika diperlukan
      },
    );
  }
}

class TwoLayerPage extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  // Fungsi login
  loginUser(BuildContext context) async {
    try {
      // Validasi input
      if (usernameController.text.isEmpty) {
        throw Exception('Username belum diisi');
      }
      if (passwordController.text.isEmpty) {
        throw Exception('Password belum diisi');
      }

      // Panggil API login
      final response = await ApiService.loginUser(
        username: usernameController.text,
        password: passwordController.text,
      );

      if (response['status'] == 'sukses') {
        // Simpan session login
        await SessionService.saveLoginSession(usernameController.text);

        showCustomDialog(
          context: context,
          isSuccess: true,
          title: 'Login Berhasil',
          message: Text('Selamat datang di PITBOX!'),
          routeName: '/home',
        );
      } else if (response['status'] == 'unverified') {
        // Tampilkan dialog untuk verifikasi email
        showResendVerificationDialog(
          context: context,
          username: usernameController.text, // Pass the username to the dialog
          resendAction: (String username) async {
            await resendVerificationEmail(
                context, username); // Pass both context and username
          },
        );
      } else {
        // Jika login gagal, tampilkan pesan error
        showCustomDialog(
          context: context,
          isSuccess: false,
          title: 'Login Gagal',
          message: Text(response['message'] ?? 'Terjadi kesalahan saat login'),
          routeName: '/login',
        );
      }
    } catch (e) {
      showCustomDialog(
        context: context,
        isSuccess: false,
        title: 'Login Gagal',
        message: Text(e.toString().replaceFirst('Exception: ', '')),
        routeName: '/login',
      );
    }
  }

  // Fungsi untuk mengirim ulang email verifikasi
  Future<void> resendVerificationEmail(
      BuildContext context, String username) async {
    try {
      // Call the API to resend verification email
      final response =
          await ApiService.resendVerificationEmail(username: username);

      if (response['status'] == 'sukses') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email verifikasi berhasil dikirim!'),
            duration: Duration(seconds: 2), // Optional: Set duration
          ),
        );
      } else {
        showCustomDialog(
          context: context,
          isSuccess: false,
          title: 'Gagal Mengirim Email Verifikasi',
          message: Text(response['message'] ??
              'Terjadi kesalahan saat mengirim email verifikasi'),
          routeName: '/login',
        );
      }
    } catch (e) {
      // Handle any exceptions that occur
      showCustomDialog(
        context: context,
        isSuccess: false,
        title: 'Gagal Mengirim Ulang',
        message: Text(e.toString().replaceFirst('Exception: ', '')),
        routeName: '/login',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600; // Menyesuaikan untuk layar kecil
    final width = screenWidth * 0.8;

    return Stack(
      children: [
        // Layer 1: Background Biru
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'), // Path to your image
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Layer 2: Layer dengan 60% dari ukuran layar, rounded 50px, dan berwarna putih
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
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
                        'Login Page',
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
                        'Siapkan mobil mini 4WD terbaik Anda dan taklukkan setiap pertandingan di kota Anda!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: isSmallScreen ? 16 : 22,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Username (Email) textfield
                    MyTextField(
                      controller: usernameController,
                      width: width,
                      hintText: 'Username',
                      obScureText: false,
                    ),

                    const SizedBox(height: 20),

                    // Password textfield
                    PasswordField(
                      controller: passwordController,
                      width: width,
                      hintText: 'Password',
                    ),

                    const SizedBox(height: 15),

                    // Forget your password
                    Container(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/forgotUser');
                            },
                            child: Text(
                              'Forgot your password?',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: isSmallScreen ? 14 : 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Sign in Button
                    MyLoadingButton(
                      label: "LOGIN",
                      width: width,
                      onTap: () async {
                        await loginUser(context);
                      },
                    ),

                    const SizedBox(height: 25),

                    Container(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Belum memiliki akun? ',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: isSmallScreen ? 16 : 22,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Sign Up',
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

                    const SizedBox(height: 250),

                    // Login as Organizer
                    Container(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/loginOrganizer');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Login sebagai ',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: isSmallScreen ? 16 : 22,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Organizer',
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
    );
  }
}
