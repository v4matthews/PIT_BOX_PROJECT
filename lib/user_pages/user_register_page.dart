import 'package:flutter/material.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:pit_box/components/asset_alert.dart';
import 'package:pit_box/components/asset_button.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_textfield_password.dart';
import 'package:pit_box/components/asset_textfield_email.dart';
import 'package:pit_box/components/asset_textfield_number.dart';
import 'package:pit_box/components/asset_dropdown.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/components/assset_button_loading.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final namaUserController = TextEditingController();
  final emailController = TextEditingController();
  final nomortlpnController = TextEditingController();
  final kotaController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  String? selectedValue;
  List<String> regionList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRegionData();
  }

  Future<void> fetchRegionData() async {
    try {
      final result = await ApiService.dataRegion();
      setState(() {
        regionList =
            result.map<String>((region) => region['name'] as String).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data region: $e')),
      );
    }
  }

  Future<void> registerPage(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      if (usernameController.text.isEmpty) {
        throw Exception('Username belum diisi');
      }
      if (namaUserController.text.isEmpty) {
        throw Exception('Nama belum diisi');
      }
      if (emailController.text.isEmpty || !emailController.text.contains('@')) {
        throw Exception('Email tidak valid');
      }
      if (nomortlpnController.text.isEmpty) {
        throw Exception('Nomor telepon belum diisi');
      }
      if (selectedValue == null || selectedValue!.isEmpty) {
        throw Exception('Kota belum dipilih');
      }
      if (passwordController.text.isEmpty ||
          passwordController.text.length < 6) {
        throw Exception('Password minimal 6 karakter');
      }
      if (passwordController.text != confirmpasswordController.text) {
        throw Exception('Password dan konfirmasi password tidak sama');
      }

      final result = await ApiService.registerUser(
        username: usernameController.text,
        nama: namaUserController.text,
        email: emailController.text,
        nomorTelepon: nomortlpnController.text,
        kota: selectedValue!,
        password: passwordController.text,
        confirmPassword: confirmpasswordController.text,
      );

      if (result == true) {
        showCustomDialog(
            context: context,
            isSuccess: true,
            title: 'Registrasi Berhasil',
            message: Text(
                'Silahkan periksa email anda untuk melakukan proses vertifikasi.'),
            routeName: '/login');
      }
    } catch (e) {
      showCustomDialog(
          context: context,
          isSuccess: false,
          title: 'Registrasi Gagal',
          message: Text(e.toString().replaceFirst('Exception: ', '')),
          routeName: '/login');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> cekUsername(BuildContext context) async {
    try {
      final result = await ApiService.cekUsername(
        username: usernameController.text,
      );
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<bool> cekEmail(BuildContext context) async {
    try {
      final result = await ApiService.getEmail(
        email: emailController.text,
      );
      return result;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final width = screenWidth * 0.8;

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Layer 1: Background Biru
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'), // Path to your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Layer 2: Layer dengan 60% dari ukuran layar, rounded 50px, dan berwarna putih
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.95,
              decoration: BoxDecoration(
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
                      const SizedBox(height: 40),
                      Text(
                        'Register Page',
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: isSmallScreen ? 35 : 35,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),

                      // Sub Title Text
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                        child: Text(
                          'Daftarkan diri Anda untuk bergabung dalam perlombaan tamiya di kota Anda',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: isSmallScreen ? 16 : 22,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      MyTextField(
                        controller: usernameController,
                        width: width,
                        hintText: 'Username',
                        obScureText: false,
                      ),
                      const SizedBox(height: 15),
                      MyTextField(
                        controller: namaUserController,
                        width: width,
                        hintText: 'Nama',
                        obScureText: false,
                      ),
                      const SizedBox(height: 15),
                      EmailTextField(
                        controller: emailController,
                        width: width,
                        hintText: 'Email',
                        obScureText: false,
                      ),
                      const SizedBox(height: 15),
                      NumberTextField(
                        controller: nomortlpnController,
                        width: width,
                        hintText: 'Nomor Telepon',
                        obScureText: false,
                      ),
                      const SizedBox(height: 15),
                      AssetDropdown(
                        hintText: "Pilih Kota",
                        selectedValue: selectedValue,
                        width: width,
                        onChanged: (newValue) {
                          setState(() {
                            selectedValue = newValue;
                          });
                        },
                        items: regionList,
                      ),
                      const SizedBox(height: 15),
                      PasswordField(
                        controller: passwordController,
                        width: width,
                        hintText: 'Password',
                        showValidation: true,
                      ),
                      const SizedBox(height: 15),
                      PasswordField(
                        controller: confirmpasswordController,
                        width: width,
                        hintText: 'Konfirmasi Password',
                      ),
                      const SizedBox(height: 40),
                      isLoading
                          ? CircularProgressIndicator()
                          : MyLoadingButton(
                              label: "REGISTER",
                              width: width,
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });

                                bool isEmailValid = await cekEmail(context);
                                bool isUsernameValid =
                                    await cekUsername(context);

                                if (!isUsernameValid) {
                                  showCustomDialog(
                                    context: context,
                                    isSuccess: false,
                                    title: 'Registrasi Gagal',
                                    message: Text('Username sudah digunakan'),
                                    routeName: '/login',
                                  );
                                } else if (!isEmailValid) {
                                  showCustomDialog(
                                    context: context,
                                    isSuccess: false,
                                    title: 'Registrasi Gagal',
                                    message: Text('Email sudah digunakan'),
                                    routeName: '/login',
                                  );
                                } else {
                                  await registerPage(context);
                                }

                                setState(() {
                                  isLoading = false;
                                });
                              },
                            ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          // Navigate to the '/login' page when the row is tapped
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sudah memiliki akun? ',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: isSmallScreen ? 16 : 22,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w400,
                                fontSize: isSmallScreen ? 16 : 22,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
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
