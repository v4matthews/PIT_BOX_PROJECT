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
    final isSmallScreen = screenWidth < 600; // Deteksi layar kecil
    final width = screenWidth * (isSmallScreen ? 0.7 : 0.6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Title Page
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Text(
                    'Forgot Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: isSmallScreen ? 24 : 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Sub Title Text
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Text(
                    'Kami akan mengirimkan password Anda melalui email. Pastikan email Anda aktif.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Email textfield
                MyTextField(
                  controller: emailController,
                  width: width,
                  hintText: 'Email',
                  obScureText: false,
                ),

                const SizedBox(height: 50),

                // Send Password Button
                MyButton(
                  label: 'SEND PASSWORD',
                  color: const Color(0xFFFFC700),
                  width: width,
                  ontap: () => forgotUser(context),
                ),

                const SizedBox(height: 15),

                // Back to Login Page Button
                MyButton(
                  label: 'BACK TO LOGIN PAGE',
                  width: width,
                  ontap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),

                const SizedBox(height: 60),

                // Sign Up Option
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
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
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
