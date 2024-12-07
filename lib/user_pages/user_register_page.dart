import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_button_login.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_textfield_password.dart';
import 'package:pit_box/api_service.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final nomortlpnController = TextEditingController();
  final kotaController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  // Sign In Method
  void registerPage(BuildContext context) async {
    try {
      final result = await ApiService.registerUser(
        username: usernameController.text,
        email: emailController.text,
        nomorTelepon: nomortlpnController.text,
        kota: kotaController.text,
        password: passwordController.text,
        confirmPassword: confirmpasswordController.text,
      );

      if (result) {
        // Navigasi ke halaman login setelah sukses registrasi
        Navigator.pushReplacementNamed(context, '/login');
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
              const SizedBox(height: 40),

              // Welcome Text
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Register Page',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )),

              const SizedBox(height: 15),

              // Username textfield
              MyTextField(
                controller: usernameController,
                width: width,
                hintText: 'Username',
                obScureText: false,
              ),

              const SizedBox(height: 15),

              // Email textfield
              MyTextField(
                controller: emailController,
                width: width,
                hintText: 'Email',
                obScureText: false,
              ),

              const SizedBox(height: 15),

              // Nomor Telepon textfield
              MyTextField(
                controller: nomortlpnController,
                width: width,
                hintText: 'Nomor Telepon',
                obScureText: false,
              ),

              const SizedBox(height: 15),

              // Kota textfield
              MyTextField(
                controller: kotaController,
                width: width,
                hintText: 'Kota',
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
                hintText: 'Password',
              ),

              const SizedBox(height: 20),

              // Sign in Button
              MyButton(
                width: width,
                label: "REGISTER",
                ontap: () => registerPage(context), // Menangani pendaftaran
              ),

              const SizedBox(height: 25),

              // Register Button
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (MediaQuery.of(context).size.width - width) /
                      2, // Padding dinamis agar sejajar
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Sudah memiliki akun?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        // Navigasi ke LoginPage
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          // decoration: TextDecoration.underline,
                          // decorationColor: Colors.blue
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
