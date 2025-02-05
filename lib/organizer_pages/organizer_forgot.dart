import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_button.dart';
import 'package:pit_box/components/asset_textfield.dart';

class OrganizerForgotPassword extends StatelessWidget {
  OrganizerForgotPassword({super.key});

  final emailController = TextEditingController();

  // Fungsi login
  void forgotOrganizer(BuildContext context) async {
    try {
      final response = await ApiService.forgotOrganizer(
        email: emailController.text,
      );

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
        Navigator.pushReplacementNamed(context, '/loginOrganizer');
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Title Page
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Text(
                  'Organizer Forgot Password',
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
                color: Color(0xFFFFC700),
                width: width,
                ontap: () => forgotOrganizer(context),
              ),

              const SizedBox(height: 15),

              MyButton(
                label: 'BACK TO LOGIN PAGE',
                width: width,
                ontap: () {
                  // Aksi untuk tombol Sign In
                  Navigator.pushNamed(context, '/loginOrganizer');
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
