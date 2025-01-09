import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_button_login.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_textfield_password.dart';
import 'package:pit_box/components/asset_textfield_email.dart';
import 'package:pit_box/components/asset_textfield_number.dart';
import 'package:pit_box/api_service.dart';

class OrganizerRegisterPage extends StatefulWidget {
  OrganizerRegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<OrganizerRegisterPage> {
  final teamController = TextEditingController();
  final emailController = TextEditingController();
  final nomortlpnController = TextEditingController();
  final alamatController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  // Sign In Method
  void registerPage(BuildContext context) async {
    try {
      final result = await ApiService.registerOrganizer(
        team: teamController.text,
        email: emailController.text,
        nomorTelepon: nomortlpnController.text,
        alamat: alamatController.text,
        password: passwordController.text,
        confirmPassword: confirmpasswordController.text,
      );

      if (result == true) {
        // Navigasi ke halaman login setelah sukses registrasi
        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.success,
            title: "Registrasi Berhasil",
            // text: "Silahkan melakukan login",
          ),
        );
        Navigator.pushReplacementNamed(context, '/loginOrganizer');
      }
    } catch (e) {
      // Menampilkan error jika gagal registrasi
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Gagal Registrasi'),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<bool> cekEmail(BuildContext context) async {
    try {
      final result = await ApiService.getEmailOrganier(
        email: emailController.text,
      );

      if (result == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600; // Responsivitas
    final width = screenWidth * (isSmallScreen ? 0.7 : 0.6);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Welcome Text
                Text(
                  'Organizer Register Page',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                // team textfield
                MyTextField(
                  controller: teamController,
                  width: width,
                  hintText: 'Nama Tim / Penyelenggara',
                  obScureText: false,
                ),

                const SizedBox(height: 15),

                // Email textfield
                EmailTextField(
                  controller: emailController,
                  width: width,
                  hintText: 'Email',
                  obScureText: false,
                ),

                const SizedBox(height: 15),

                // Nomor Telepon textfield
                NumberTextField(
                  controller: nomortlpnController,
                  width: width,
                  hintText: 'Nomor Telepon',
                  obScureText: false,
                ),

                const SizedBox(height: 15),

                // Alamar textfield
                MyTextField(
                  controller: alamatController,
                  width: width,
                  hintText: 'Alamat',
                  obScureText: false,
                ),

                const SizedBox(height: 15),

                // Password textfield
                PasswordField(
                  controller: passwordController,
                  width: width,
                  hintText: 'Password',
                ),

                const SizedBox(height: 15),

                // Confirm Password textfield
                PasswordField(
                  controller: confirmpasswordController,
                  width: width,
                  hintText: 'Confirm Password',
                ),

                const SizedBox(height: 20),

                // Sign in Button
                MyButton(
                  width: width,
                  label: "REGISTER",
                  ontap: () async {
                    // Panggil cekUsername terlebih dahulu

                    bool isEmailValid = await cekEmail(context);
                    // Jika cekUsername berhasil, lanjutkan proses registrasi

                    if (isEmailValid) {
                      registerPage(context);
                    } else {
                      await ArtSweetAlert.show(
                        context: context,
                        artDialogArgs: ArtDialogArgs(
                          type: ArtSweetAlertType.danger,
                          // title: "Username sudah digunakan",
                          text: "Email sudah digunakan",
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah memiliki akun?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/loginOrganizer');
                      },
                      child: Text(
                        'Sign In',
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
