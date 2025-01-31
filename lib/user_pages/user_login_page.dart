import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_alert.dart';
import 'package:pit_box/components/asset_button_login.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_textfield_password.dart';
import 'package:pit_box/components/square_tile.dart';
import 'package:pit_box/session_service.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Fungsi login
  void loginUser(BuildContext context) async {
    try {
      if (usernameController.text.isEmpty) {
        throw Exception('Username belum diisi');
      }
      if (passwordController.text.isEmpty) {
        throw Exception('Password belum diisi');
      }

      final response = await ApiService.loginUser(
        username: usernameController.text,
        password: passwordController.text,
      );

      if (response.isNotEmpty) {
        // Simpan session login
        await SessionService.saveLoginSession(usernameController.text);

        showCustomDialog(
          context: context,
          isSuccess: true,
          title: 'Login Berhasil',
          message: Text('Selamat datang di PITBOX!'),
          routeName: '/home',
        );
      }
    } catch (e) {
      showCustomDialog(
        context: context,
        isSuccess: false,
        title: 'Login Gagal',
        message: Text(e.toString()),
        routeName: '/home',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600; // Menyesuaikan untuk layar kecil
    final width = screenWidth * (isSmallScreen ? 0.7 : 0.6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // Tambahkan untuk mencegah overflow pada layar kecil
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // Title Page
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Text(
                    'Login Page',
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
                    'Siapkan mobil mini 4WD terbaik Anda dan taklukkan setiap pertandingan di kota Anda!',
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
                  ontap: () => loginUser(context),
                ),

                const SizedBox(height: 15),

                // Forget your password
                Container(
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/loginOrganizer');
                        },
                        child: Text(
                          'Login as Organizer',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/forgotUser');
                        },
                        child: Text(
                          'Forgot your password?',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // Login with Google
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
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
