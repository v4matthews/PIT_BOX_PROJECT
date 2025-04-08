import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_alert.dart';
import 'package:pit_box/components/asset_button.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_textfield_password.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/components/assset_button_loading.dart';
import 'package:pit_box/session_service.dart';

class OrganizerLoginPage extends StatelessWidget {
  OrganizerLoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void loginOrganizer(BuildContext context) async {
    try {
      if (emailController.text.isEmpty) {
        throw Exception('Email belum diisi');
      }
      if (passwordController.text.isEmpty) {
        throw Exception('Password belum diisi');
      }

      final response = await ApiService.loginOrganizer(
        email: emailController.text,
        password: passwordController.text,
      );
      print("response organizer: $response");
      if (response['status'] == 'sukses') {
        // Simpan session login
        // await SessionService.saveLoginSession(usernameController.text);
        await SessionService.saveLoginSession(
          username: emailController.text,
          userType: 'organizer',
        );
        showCustomDialog(
          context: context,
          isSuccess: true,
          title: 'Login Organizer Berhasil',
          message: const Text('Selamat datang di PITBOX!'),
          routeName: '/homeOrganizer',
        );
        // showCustomDialog(
        //   context: context,
        //   isSuccess: true,
        //   title: 'Login Berhasil',
        //   message: Text('Selamat datang di PITBOX!'),
        //   routeName: '/homeOrganizer',
        // );
      } else {
        // Jika login gagal, tampilkan pesan error
        showCustomDialog(
          context: context,
          isSuccess: false,
          title: 'Login Gagal',
          message: Text(response['message'] ?? 'Terjadi kesalahan saat login'),
          routeName: '/loginOrganizer',
        );
      }

      // if (response['sukses']) {
      //   print("Login Berahsil");
      //   await SessionService.saveLoginSession(
      //     username: emailController.text,
      //     userType: 'organizer',
      //   );

      //   Navigator.pushReplacementNamed(context, '/homeOrganizer');
      // } else {
      //   throw Exception(response['message'] ?? 'Login failed');
      // }
    } catch (e) {
      showCustomDialog(
        context: context,
        isSuccess: false,
        title: 'Login Organizer Gagal',
        message: Text(e.toString().replaceFirst('Exception: ', '')),
        routeName: '/',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final width = screenWidth * 0.8;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(
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
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.1,
                          right: screenWidth * 0.1,
                          top: 120,
                        ),
                        child: Text(
                          'Organizer Login Page',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: isSmallScreen ? 35 : 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.1,
                          vertical: 10,
                        ),
                        child: Text(
                          'Jadilah bagian dari penyelenggara pertandingan Mini 4WD di kota Anda!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: isSmallScreen ? 16 : 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      MyTextField(
                        controller: emailController,
                        width: width,
                        hintText: 'Email Organizer',
                        obScureText: false,
                      ),
                      const SizedBox(height: 20),
                      PasswordField(
                        controller: passwordController,
                        width: width,
                        hintText: 'Password',
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: width,
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/forgotOrganizer');
                          },
                          child: Text(
                            'Forgot your password?',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: isSmallScreen ? 14 : 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      MyLoadingButton(
                        label: "LOGIN",
                        width: width,
                        onTap: () async {
                          loginOrganizer(context);
                        },
                      ),
                      const SizedBox(height: 25),
                      Container(
                        width: width,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/registerOrganizer');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Daftar sebagai penyelenggara? ',
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
                      ),
                      const SizedBox(height: 250),

                      // Login as user
                      Container(
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, '/login');
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
                                    'User',
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
      ),
    );
  }
}
