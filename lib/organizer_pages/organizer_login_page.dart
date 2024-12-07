import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_button_login.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_textfield_password.dart';

class OrganizerLoginPage extends StatelessWidget {
  OrganizerLoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Fungsi login
  void loginUser(BuildContext context) async {
    try {
      // Mengambil username dan password dari controller
      final response = await ApiService.loginUser(
        username: usernameController.text, // Menggunakan email sebagai username
        password: passwordController.text,
      );

      // Jika login berhasil, arahkan ke halaman utama
      if (response.isNotEmpty) {
        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.success,
            title: "Login Berhasil",
            text: "Selamat datang di PIT BOX",
          ),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.danger,
            title: "Login Gagal",
            text: "Silahkan pastikan username & password tidak kosong!",
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Login Gagal'),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog error
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final width = screenWidth * 0.8;
    final width2 = (screenWidth * 0.8 - 6) / 2;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
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
                        fontSize: 30,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Jadilah bagian dari penyelenggara pertandingan Mini 4WD di kota Anda!',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Username (Email) textfield
              MyTextField(
                controller: usernameController,
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
                        right: (MediaQuery.of(context).size.width - width) / 2,
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
                    color: Color(0xFF4A59A9),
                    width: width2,
                    ontap: () {
                      // Aksi untuk tombol Sign In
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                  MyButton(
                    label: 'LOGIN',
                    width: width2,
                    // Warna biru untuk tombol Register
                    ontap: () => loginUser(
                        context), // Fungsi login dipanggil saat tombol ditekan
                  )
                ],
              ),

              // // Sign in Button
              // MyButton(
              //   ontap: () => loginUser(
              //       context), // Fungsi login dipanggil saat tombol ditekan
              // ),

              const SizedBox(height: 50),

              //Tombol signin as user

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
    );
  }
}
