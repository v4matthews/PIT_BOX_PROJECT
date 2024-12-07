import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_button_login.dart';
import 'package:pit_box/components/asset_textfield.dart';

class UserForgetPassword extends StatelessWidget {
  UserForgetPassword({super.key});

  final emailController = TextEditingController();

  // Fungsi login
  void forgotUser(BuildContext context) async {
    try {
      // Mengambil username dan password dari controller
      final response = await ApiService.forgotUser(
        email: emailController.text, // Menggunakan email sebagai username
      );

      // Jika login berhasil, arahkan ke halaman utama
      if (response.isNotEmpty) {
        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.success,
            title: "Password successfully Sent!",
            text:
                "Password anda sudah di kirimkan ke Email, harap periksa Email anda.",
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.danger,
            title: "Periksa Email anda",
            text: "Email yang anda masukan salah atau tidak terdaftar!",
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
    // final width2 = (screenWidth * 0.8 - 6) / 2;
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
                      'Forgot Password',
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
                      'Kami akan mengirimkan password Anda melalui email Pastikan email anda aktif',
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
                controller: emailController,
                width: width,
                hintText: 'Email',
                obScureText: false,
              ),

              const SizedBox(height: 50),

              MyButton(
                label: 'SEND PASSWORD',
                width: width,
                // Warna biru untuk tombol Register
                ontap: () => forgotUser(
                    context), // Fungsi login dipanggil saat tombol ditekan
              ),

              const SizedBox(height: 15),

              MyButton(
                label: 'BACK TO LOGIN PAGE',
                color: Color(0xFF4A59A9),
                width: width,
                ontap: () {
                  // Aksi untuk tombol Sign In
                  Navigator.pushNamed(context, '/login');
                },
              ),

              const SizedBox(height: 60),

              // Register Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Belum memiliki akun?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/register'); // Arahkan ke halaman Register
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
