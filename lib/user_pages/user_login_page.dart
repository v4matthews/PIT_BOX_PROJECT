import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_button_login.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_textfield_password.dart';
import 'package:pit_box/components/square_tile.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

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
                      'Login Page',
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
                      'Siapkan mobil mini 4WD terbaik Anda dan taklukkan setiap pertandingan di kota Anda!',
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

              const SizedBox(height: 40),

              // Sign in Button
              MyButton(
                label: "LOGIN",
                width: width,
                ontap: () => loginUser(
                    context), // Fungsi login dipanggil saat tombol ditekan
              ),

              const SizedBox(height: 15),

              // Forget your password
              Container(
                width: width, // Sesuaikan lebar dengan TextField
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Sejajarkan kiri dan kanan
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context,
                            '/loginOrganizer'); // Arahkan ke halaman Register
                      },
                      child: Text(
                        'Login as Organizer',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Aksi Forget Password
                        Navigator.pushNamed(context, '/forgotUser');
                      },
                      child: Text(
                        'Forgot your password?',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // Login with Google
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or Continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(imagePath: 'assets/images/google.png'),
                ],
              ),

              const SizedBox(height: 15),

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
