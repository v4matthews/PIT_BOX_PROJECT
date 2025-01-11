import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_alert.dart';
import 'package:pit_box/components/asset_button_login.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_textfield_password.dart';

class OrganizerLoginPage extends StatelessWidget {
  OrganizerLoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Fungsi login
  void loginOrganizer(BuildContext context) async {
    try {
      if (emailController.text.isEmpty) {
        throw Exception('Email belum diisi');
      }
      if (passwordController.text.isEmpty) {
        throw Exception('Password belum diisi');
      }
      // Mengambil username dan password dari controller
      final response = await ApiService.loginOrganizer(
        email: emailController.text, // Menggunakan email sebagai username
        password: passwordController.text,
      );

      // Jika login berhasil, arahkan ke halaman utama
      if (response.isNotEmpty) {
        showCustomDialog(
            context: context,
            isSuccess: true,
            title: 'Login Organizer Berhasil',
            message: Text('Selamat datang di PITBOX!'),
            routeName: '/insertRace');
      }
    } catch (e) {
      showCustomDialog(
          context: context,
          isSuccess: false,
          title: 'Login Organizer Gagal',
          message: Text(e.toString()),
          routeName: '/insertRace');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600; // Menyesuaikan untuk layar kecil
    final width = screenWidth * (isSmallScreen ? 0.7 : 0.6);
    final width2 = (screenWidth * (isSmallScreen ? 0.7 : 0.6) - 6) / 2;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // Title Page
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Organizer Login Page',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: isSmallScreen ? 24 : 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Sub Title Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    'Jadilah bagian dari penyelenggara pertandingan Mini 4WD di kota Anda!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Username (Email) textfield
                MyTextField(
                  controller: emailController,
                  width: width,
                  hintText: 'Email Organizer',
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

                // Forgot your password
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/forgotOrganizer');
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          right:
                              (MediaQuery.of(context).size.width - width) / 2,
                        ),
                        child: Text(
                          'Forgot your password?',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Posisi tombol di tengah
                  children: [
                    MyButton(
                      label: 'LOGIN AS USER',
                      width: width2,
                      ontap: () {
                        // Aksi untuk tombol Sign In
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                    MyButton(
                      label: 'LOGIN',
                      color: Color(0xFFFFC700),
                      width: width2,
                      // Warna biru untuk tombol Register
                      ontap: () => loginOrganizer(
                          context), // Fungsi login dipanggil saat tombol ditekan
                    )
                  ],
                ),

                const SizedBox(height: 50),

                // Register Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ingin mendaftar sebagai Organizer?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context,
                            '/registerOrganizer'); // Arahkan ke halaman Register
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
